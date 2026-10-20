import '../../data/models/plant.dart';
import '../../data/repositories/plant_repository.dart';
import '../core/base_view_model.dart';

class EditPlantViewModel extends BaseViewModel {
  EditPlantViewModel(this._repo, this._plant)
      : nombre = _plant.nombre,
        unidad = _plant.unidad,
        horas = _plant.unidad == WateringUnit.horas
            ? _plant.regar.clamp(1, 23).toInt()
            : 12,
        dias = _plant.unidad == WateringUnit.dias
            ? _plant.regar.clamp(1, 30).toInt()
            : 7;

  final PlantRepository _repo;
  final Plant _plant;

  String nombre;
  WateringUnit unidad;
  int horas;
  int dias;

  int get cantidad => unidad == WateringUnit.horas ? horas : dias;

  /// Compara lo que hay en el formulario con la planta original
  bool get hasChanges =>
      nombre.trim() != _plant.nombre ||
      unidad != _plant.unidad ||
      cantidad != _plant.regar;

  bool get canUpdate => hasChanges && nombre.trim().isNotEmpty && !isLoading;

  void setNombre(String value) {
    nombre = value;
    notifyListeners();
  }

  void setUnidad(WateringUnit value) {
    unidad = value;
    notifyListeners();
  }

  void setHoras(int value) {
    horas = value;
    notifyListeners();
  }

  void setDias(int value) {
    dias = value;
    notifyListeners();
  }

  Future<bool> update() => run(() => _repo.updatePlant(
        id: _plant.id,
        nombre: nombre.trim(),
        regar: cantidad,
        unidad: unidad,
      ));

  Future<bool> delete() => run(() => _repo.deletePlant(_plant.id));
}