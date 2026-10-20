import 'dart:async';
import '../../data/models/plant.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/plant_repository.dart';
import '../core/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._auth, this._plants) {
    loadPlants();
    _timer =
        Timer.periodic(const Duration(seconds: 30), (_) => notifyListeners());
  }

  final AuthRepository _auth;
  final PlantRepository _plants;
  late final Timer _timer;

  List<Plant> plants = [];

  Future<bool> loadPlants() => run(() async {
        plants = await _plants.fetchPlants();
      });

  Future<bool> water(Plant plant) => run(() async {
        await _plants.waterPlant(plant.id);
        plants = await _plants.fetchPlants();
      });

  Future<bool> signOut() => run(_auth.signOut);

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}