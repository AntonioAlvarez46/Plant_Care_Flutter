import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/auth_repository.dart';
import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (c) => HomeViewModel(c.read<AuthRepository>()),
        child: const _HomeBody(),
      );
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis plantas'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: vm.signOut),
        ],
      ),
      body: Center(child: Text('Hola ${vm.email}')),
    );
  }
}