import '../../data/repositories/auth_repository.dart';
import '../core/base_view_model.dart';

class ResetPasswordViewModel extends BaseViewModel {
  ResetPasswordViewModel(this._repo);
  final AuthRepository _repo;

  Future<bool> save(String password) =>
      run(() => _repo.updatePassword(password));
}