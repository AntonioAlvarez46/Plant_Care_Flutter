import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PushService {
  PushService(this._client);
  final SupabaseClient _client;

  StreamSubscription<String>? _refreshSub;

  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> registerDevice() async {
    if (!supported) return;
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;

      final token = await messaging.getToken();
      debugPrint('FCM token: $token');
      if (token != null) await _saveToken(token);

      await _refreshSub?.cancel();
      _refreshSub = messaging.onTokenRefresh.listen(_saveToken);
    } catch (e) {
      debugPrint('No se pudo registrar el dispositivo para push: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    await _client.rpc('register_device_token', params: {
      'p_token': token,
      'p_platform': defaultTargetPlatform.name,
    });
  }

  Future<void> unregisterDevice() async {
    if (!supported) return;
    try {
      await _refreshSub?.cancel();
      _refreshSub = null;
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _client.from('device_tokens').delete().eq('token', token);
      }
    } catch (e) {
      debugPrint('No se pudo desregistrar el dispositivo: $e');
    }
  }
}