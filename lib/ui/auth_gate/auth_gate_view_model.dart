import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/auth_repository.dart';

class AuthGateViewModel extends ChangeNotifier {
  AuthGateViewModel(AuthRepository repo)
      : _isLoggedIn = repo.currentSession != null {
    _sub = repo.authChanges.listen((state) {
      _isLoggedIn = state.session != null;
      if (state.event == AuthChangeEvent.passwordRecovery) {
        _isRecovering = true;
      }
      if (state.event == AuthChangeEvent.userUpdated ||
          state.event == AuthChangeEvent.signedOut) {
        _isRecovering = false;
      }
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _sub;
  bool _isLoggedIn;
  bool _isRecovering = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isRecovering => _isRecovering;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}