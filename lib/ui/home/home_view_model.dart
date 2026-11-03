import 'dart:async';
import '../../data/models/plant.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/plant_repository.dart';
import '../../data/services/push_service.dart';
import '../core/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._auth, this._plants, this._push) {
    unawaited(_push.registerDevice());
    loadPlants();
    _timer =
        Timer.periodic(const Duration(seconds: 30), (_) => notifyListeners());
  }

  final AuthRepository _auth;
  final PlantRepository _plants;
  final PushService _push;
  late final Timer _timer;

  List<Plant> plants = [];

  Future<bool> loadPlants() => run(() async {
        plants = await _plants.fetchPlants();
      });

  Future<bool> water(Plant plant) => run(() async {
        await _plants.waterPlant(plant.id);
        plants = await _plants.fetchPlants();
      });

  Future<bool> signOut() => run(() async {
        await _push.unregisterDevice();
        await _auth.signOut();
      });

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}