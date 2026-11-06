import { withSupabase } from 'npm:@supabase/server@^1'
import { JWT } from 'npm:google-auth-library@^10'

interface NotificationRow {
  id: string
  user_id: string
  body: string
}

interface WebhookPayload {
  type: 'INSERT'
  table: string
  record: NotificationRow
  schema: 'public'
}

// La cuenta de servicio vive como secreto de Supabase, no en el repositorio
const serviceAccount = JSON.parse(Deno.env.get('FCM_SERVICE_ACCOUNT')!)

// Lo llama el webhook de la base de datos (se despliega con --no-verify-jwt)
export default {
  fetch: withSupabase({ auth: 'secret' }, async (req, ctx) => {
    const payload: WebhookPayload = await req.json()

    const { data: devices } = await ctx.supabaseAdmin
      .from('device_tokens')
      .select('token')
      .eq('user_id', payload.record.user_id)

    if (!devices || devices.length === 0) return Response.json({ sent: 0 })

    const jwt = new JWT({
      email: serviceAccount.client_email,
      key: serviceAccount.private_key,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
    })
    const { access_token } = await jwt.authorize()

    let sent = 0
    for (const { token } of devices) {
      const res = await fetch(
        `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${access_token}`,
          },
          body: JSON.stringify({
            message: {
              token,
              notification: { title: '💧 Hora de regar', body: payload.record.body },
              android: { priority: 'HIGH' },
            },
          }),
        }
      )

      if (res.ok) {
        sent++
      } else if (res.status === 404) {
        // Token caducado o app desinstalada: se limpia
        await ctx.supabaseAdmin.from('device_tokens').delete().eq('token', token)
      } else {
        console.error('Error de FCM', res.status, await res.text())
      }
    }

    return Response.json({ sent })
  }),
}