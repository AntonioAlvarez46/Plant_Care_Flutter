import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/plant.dart';
import '../../data/repositories/plant_repository.dart';
import '../core/watering_interval_field.dart';
import 'edit_plant_view_model.dart';

class EditPlantSheet extends StatelessWidget {
  const EditPlantSheet({super.key, required this.plant});
  final Plant plant;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (c) => EditPlantViewModel(c.read<PlantRepository>(), plant),
        child: _EditPlantForm(plant: plant),
      );
}

class _EditPlantForm extends StatefulWidget {
  const _EditPlantForm({required this.plant});
  final Plant plant;

  @override
  State<_EditPlantForm> createState() => _EditPlantFormState();
}

class _EditPlantFormState extends State<_EditPlantForm> {
  late final _nombre = TextEditingController(text: widget.plant.nombre);

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  Future<void> _update(EditPlantViewModel vm) async {
    final ok = await vm.update();
    if (ok && mounted) Navigator.of(context).pop(true);
  }

  Future<void> _delete(EditPlantViewModel vm) async {
    final scheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Borrar planta?'),
        content: Text(
            'Se borrará "${widget.plant.nombre}". Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: scheme.error,
              foregroundColor: scheme.onError,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final ok = await vm.delete();
    if (ok && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditPlantViewModel>();
    final scheme = Theme.of(context).colorScheme;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Editar planta', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _nombre,
            onChanged: vm.setNombre,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Nombre de la planta',
              errorText: vm.nombre.trim().isEmpty ? 'Escribe un nombre' : null,
            ),
          ),
          const SizedBox(height: 24),
          WateringIntervalField(
            unidad: vm.unidad,
            horas: vm.horas,
            dias: vm.dias,
            onUnidadChanged: vm.setUnidad,
            onHorasChanged: vm.setHoras,
            onDiasChanged: vm.setDias,
          ),
          if (vm.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(vm.error!, style: TextStyle(color: scheme.error)),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: vm.canUpdate ? () => _update(vm) : null,
              child: Text(vm.isLoading ? 'Guardando...' : 'Actualizar'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: scheme.error),
              onPressed: vm.isLoading ? null : () => _delete(vm),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Borrar planta'),
            ),
          ),
        ],
      ),
    );
  }
}