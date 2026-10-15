import '../../data/repositories/auth_repository.dart';
import '../core/base_view_model.dart';

class RegisterViewModel extends BaseViewModel {
  RegisterViewModel(this._repo);
  final AuthRepository _repo;

  bool needsConfirmation = false;

  Future<bool> register(String username, String email, String password) =>
      run(() async {
        needsConfirmation = await _repo.register(
          username: username,
          email: email,
          password: password,
        );
      });
}