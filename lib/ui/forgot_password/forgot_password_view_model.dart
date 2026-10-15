import '../../data/repositories/auth_repository.dart';
import '../core/base_view_model.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  ForgotPasswordViewModel(this._repo);
  final AuthRepository _repo;

  Future<bool> send(String email) => run(() => _repo.sendPasswordReset(email));
}