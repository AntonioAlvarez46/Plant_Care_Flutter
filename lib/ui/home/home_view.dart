import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/plant.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/plant_repository.dart';
import '../add_plant/add_plant_sheet.dart';
import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (c) => HomeViewModel(
          c.read<AuthRepository>(),
          c.read<PlantRepository>(),
        ),
        child: const _HomeBody(),
      );
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  Future<void> _openAddPlant(BuildContext context) async {
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const AddPlantSheet(),
    );
    if (added == true && context.mounted) {
      context.read<HomeViewModel>().loadPlants();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis plantas (${vm.plants.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: vm.signOut,
          ),
        ],
      ),
      body: Column(
        children: [
          if (vm.isLoading) const LinearProgressIndicator(),
          if (vm.error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(vm.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          Expanded(
            child: vm.plants.isEmpty
                ? (vm.isLoading
                    ? const SizedBox.shrink()
                    : const Center(
                        child: Text(
                          'Aún no tienes plantas.\nPulsa + para añadir la primera.',
                          textAlign: TextAlign.center,
                        ),
                      ))
                : RefreshIndicator(
                    onRefresh: vm.loadPlants,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 88),
                      itemCount: vm.plants.length,
                      itemBuilder: (_, i) => _PlantTile(plant: vm.plants[i]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Añadir planta',
        onPressed: () => _openAddPlant(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PlantTile extends StatelessWidget {
  const _PlantTile({required this.plant});
  final Plant plant;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<HomeViewModel>();
    final now = DateTime.now();
    final nivel = plant.nivelAgua(now);
    final necesitaAgua = nivel == 0;
    final color =
        necesitaAgua ? Theme.of(context).colorScheme.error : Colors.blue;

    return ListTile(
      title: Text(plant.nombre),
      subtitle: Text(necesitaAgua
          ? '¡Necesita agua!'
          : 'Próximo riego ${_formatRestante(plant.restante(now))}'),
      trailing: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              value: nivel,
              strokeWidth: 3,
              color: color,
              backgroundColor: color.withValues(alpha: 0.15),
            ),
          ),
          IconButton(
            icon: Icon(Icons.water_drop, color: color),
            tooltip: 'Regar',
            onPressed: () => vm.water(plant),
          ),
        ],
      ),
    );
  }
}

String _formatRestante(Duration d) {
  if (d.inMinutes < 60) return 'en ${d.inMinutes < 1 ? 1 : d.inMinutes} min';
  if (d.inHours < 48) return 'en ${d.inHours} h';
  return 'en ${d.inDays} días';
}