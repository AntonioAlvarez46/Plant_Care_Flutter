import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/auth_repository.dart';
import 'forgot_password_view_model.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (c) => ForgotPasswordViewModel(c.read<AuthRepository>()),
        child: const _ForgotForm(),
      );
}

class _ForgotForm extends StatefulWidget {
  const _ForgotForm();

  @override
  State<_ForgotForm> createState() => _ForgotFormState();
}

class _ForgotFormState extends State<_ForgotForm> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit(ForgotPasswordViewModel vm) async {
    final ok = await vm.send(_email.text.trim());
    if (!ok || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Si el email existe, recibirás un enlace')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            if (vm.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(vm.error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: null/*vm.isLoading ? null : () => _submit(vm)*/,
              child: Text(vm.isLoading ? 'Enviando...' : 'Enviar enlace'),
            ),
          ],
        ),
      ),
    );
  }
}