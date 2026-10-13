import 'package:flutter/foundation.dart' show kIsWeb;

class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  static const _redirectMobile = String.fromEnvironment('RESET_REDIRECT_MOBILE');
  static const _redirectWeb = String.fromEnvironment('RESET_REDIRECT_WEB');

  static String get resetPasswordRedirect =>
      kIsWeb ? _redirectWeb : _redirectMobile;

  static void validate() {
    final faltan = <String>[
      if (supabaseUrl.isEmpty) 'SUPABASE_URL',
      if (supabasePublishableKey.isEmpty) 'SUPABASE_PUBLISHABLE_KEY',
    ];
    if (faltan.isNotEmpty) {
      throw StateError(
          'Faltan: ${faltan.join(', ')}. Ejecuta con --dart-define-from-file=env.json');
    }
  }
}