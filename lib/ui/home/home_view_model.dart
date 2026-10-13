import '../../data/repositories/auth_repository.dart';
import '../core/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._repo);
  final AuthRepository _repo;

  String get email => _repo.currentEmail ?? '';

  Future<bool> signOut() => run(_repo.signOut);
}