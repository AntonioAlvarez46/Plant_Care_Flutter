import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/auth_repository.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _disposed = false;
  String? _error;

  bool get isLoading => _loading;
  String? get error => _error;

  /// Ejecuta una acción gestionando carga y errores. Devuelve true si fue bien.
  Future<bool> run(Future<void> Function() action) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      _error = _message(e);
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  String _message(Object e) {
    if (e is UsernameTakenException) {
      return 'Ese nombre de usuario ya está en uso';
    }
    if (e is EmailAlreadyRegisteredException) {
      return 'Ese email ya está registrado. Inicia sesión';
    }
    if (e is AuthException) {
      final m = e.message.toLowerCase();
      if (m.contains('invalid login credentials')) {
        return 'Email o contraseña incorrectos';
      }
      if (m.contains('email not confirmed')) {
        return 'Debes confirmar tu email antes de entrar';
      }
      if (m.contains('database error')) {
        return 'No se pudo crear la cuenta. Puede que el nombre de usuario ya exista';
      }
      if (m.contains('rate limit')) {
        return 'Demasiados intentos. Espera un poco e inténtalo de nuevo';
      }
      return e.message;
    }
    return 'Ha ocurrido un error inesperado';
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }
}