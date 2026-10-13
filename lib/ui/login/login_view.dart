import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../forgot_password/forgot_password_view.dart';
import '../register/register_view.dart';
import 'login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (c) => LoginViewModel(c.read<AuthRepository>()),
        child: const _LoginForm(),
      );
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            if (vm.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(vm.error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: vm.isLoading
                  ? null
                  : () => vm.signIn(_email.text.trim(), _password.text),
              child: Text(vm.isLoading ? 'Entrando...' : 'Entrar'),
            ),
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordView())),
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RegisterView())),
              child: const Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}