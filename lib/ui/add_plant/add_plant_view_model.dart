import '../../data/models/plant.dart';
import '../../data/repositories/plant_repository.dart';
import '../core/base_view_model.dart';

class AddPlantViewModel extends BaseViewModel {
  AddPlantViewModel(this._repo);
  final PlantRepository _repo;

  WateringUnit unidad = WateringUnit.dias;
  int horas = 12;
  int dias = 7;

  int get cantidad => unidad == WateringUnit.horas ? horas : dias;

  void setUnidad(WateringUnit value) {
    unidad = value;
    notifyListeners();
  }

  void setHoras(int value) => horas = value;

  void setDias(int value) => dias = value;

  Future<bool> save(String nombre) => run(() => _repo.addPlant(
        nombre: nombre.trim(),
        regar: cantidad,
        unidad: unidad,
      ));
}