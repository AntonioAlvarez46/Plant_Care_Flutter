import 'package:flutter/cupertino.dart' show CupertinoPicker;
import 'package:flutter/material.dart';
import '../../data/models/plant.dart';

class WateringIntervalField extends StatelessWidget {
  const WateringIntervalField({
    super.key,
    required this.unidad,
    required this.horas,
    required this.dias,
    required this.onUnidadChanged,
    required this.onHorasChanged,
    required this.onDiasChanged,
  });

  final WateringUnit unidad;
  final int horas;
  final int dias;
  final ValueChanged<WateringUnit> onUnidadChanged;
  final ValueChanged<int> onHorasChanged;
  final ValueChanged<int> onDiasChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Regar cada', style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Horas'),
                value: unidad == WateringUnit.horas,
                onChanged: (_) => onUnidadChanged(WateringUnit.horas),
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Días'),
                value: unidad == WateringUnit.dias,
                onChanged: (_) => onUnidadChanged(WateringUnit.dias),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (unidad == WateringUnit.horas)
          _HoursPicker(initial: horas, onChanged: onHorasChanged)
        else
          DropdownMenu<int>(
            expandedInsets: EdgeInsets.zero,
            initialSelection: dias,
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
              if (d != null) onDiasChanged(d);
            },
          ),
      ],
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