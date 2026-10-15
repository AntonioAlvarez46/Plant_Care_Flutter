import 'package:flutter/cupertino.dart' show CupertinoPicker;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/plant.dart';
import '../../data/repositories/plant_repository.dart';
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
            Text('Regar cada', style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Horas'),
                    value: vm.unidad == WateringUnit.horas,
                    onChanged: (_) => vm.setUnidad(WateringUnit.horas),
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Días'),
                    value: vm.unidad == WateringUnit.dias,
                    onChanged: (_) => vm.setUnidad(WateringUnit.dias),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (vm.unidad == WateringUnit.horas)
              _HoursPicker(initial: vm.horas, onChanged: vm.setHoras)
            else
              DropdownMenu<int>(
                expandedInsets: EdgeInsets.zero,
                initialSelection: vm.dias,
                label: const Text('Días'),
                menuHeight: 240,
                requestFocusOnTap: false,
                enableFilter: false,
                dropdownMenuEntries: [
                  for (var d = 1; d <= 30; d++)
                    DropdownMenuEntry(
                        value: d, label: '$d ${d == 1 ? 'día' : 'días'}'),
                ],
                onSelected: (d) {
                  if (d != null) vm.setDias(d);
                },
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

class _HoursPicker extends StatefulWidget {
  const _HoursPicker({required this.initial, required this.onChanged});
  final int initial;
  final ValueChanged<int> onChanged;

  @override
  State<_HoursPicker> createState() => _HoursPickerState();
}

class _HoursPickerState extends State<_HoursPicker> {
  late final _controller =
      FixedExtentScrollController(initialItem: widget.initial - 1);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: CupertinoPicker(
        scrollController: _controller,
        itemExtent: 40,
        onSelectedItemChanged: (i) => widget.onChanged(i + 1),
        children: [
          for (var h = 1; h <= 23; h++)
            Center(child: Text('$h ${h == 1 ? 'hora' : 'horas'}')),
        ],
      ),
    );
  }
}