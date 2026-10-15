import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/auth_repository.dart';
import 'reset_password_view_model.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (c) => ResetPasswordViewModel(c.read<AuthRepository>()),
        child: const _ResetForm(),
      );
}

class _ResetForm extends StatefulWidget {
  const _ResetForm();

  @override
  State<_ResetForm> createState() => _ResetFormState();
}

class _ResetFormState extends State<_ResetForm> {
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ResetPasswordViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nueva contraseña'),
            ),
            if (vm.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(vm.error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: vm.isLoading ? null : () => vm.save(_password.text),
              child: Text(vm.isLoading ? 'Guardando...' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}