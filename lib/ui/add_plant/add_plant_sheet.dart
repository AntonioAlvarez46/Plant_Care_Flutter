import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/plant_repository.dart';
import '../core/watering_interval_field.dart';
import 'add_plant_view_model.dart';

class AddPlantSheet extends StatelessWidget {
  const AddPlantSheet({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (c) => AddPlantViewModel(c.read<PlantRepository>()),
        child: const _AddPlantForm(),
      );
}

class _AddPlantForm extends StatefulWidget {
  const _AddPlantForm();

  @override
  State<_AddPlantForm> createState() => _AddPlantFormState();
}

class _AddPlantFormState extends State<_AddPlantForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  Future<void> _submit(AddPlantViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await vm.save(_nombre.text);
    if (ok && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddPlantViewModel>();
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nueva planta',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombre,
              textCapitalization: TextCapitalization.sentences,
              decoration:
                  const InputDecoration(labelText: 'Nombre de la planta'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Escribe un nombre' : null,
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
                child: Text(vm.error!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: vm.isLoading ? null : () => _submit(vm),
                child: Text(vm.isLoading ? 'Guardando...' : 'Añadir planta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}