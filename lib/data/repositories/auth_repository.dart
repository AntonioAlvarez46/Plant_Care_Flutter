import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/env.dart';

class UsernameTakenException implements Exception {}

class EmailAlreadyRegisteredException implements Exception {}

class AuthRepository {
  AuthRepository(this._client);
  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  Stream<AuthState> get authChanges => _auth.onAuthStateChange;
  Session? get currentSession => _auth.currentSession;
  String? get currentEmail => _auth.currentUser?.email;

  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithPassword(email: email, password: password);
  }

  /// Devuelve true si hace falta confirmar el email.
  /// Nunca deja la sesión iniciada: el usuario debe pasar por el login.
  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final disponible = await _client
        .rpc('username_disponible', params: {'p_username': username});
    if (disponible != true) throw UsernameTakenException();

    final res = await _auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );

    // Email ya registrado: Supabase no da error, devuelve identities vacío
    if (res.user?.identities?.isEmpty ?? false) {
      throw EmailAlreadyRegisteredException();
    }

    if (res.session != null) {
      await _auth.signOut();
      return false;
    }
    return true;
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.resetPasswordForEmail(
      email,
      redirectTo: Env.resetPasswordRedirect,
    );
  }

  Future<void> updatePassword(String password) async {
    await _auth.updateUser(UserAttributes(password: password));
  }

  Future<void> signOut() => _auth.signOut();
}