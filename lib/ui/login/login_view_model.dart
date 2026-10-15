import '../../data/repositories/auth_repository.dart';
import '../core/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel(this._repo);
  final AuthRepository _repo;

  Future<bool> signIn(String email, String password) =>
      run(() => _repo.signIn(email: email, password: password));
}