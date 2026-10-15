import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/home_view.dart';
import '../login/login_view.dart';
import '../reset_password/reset_password_view.dart';
import 'auth_gate_view_model.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthGateViewModel>();
    if (vm.isRecovering) return const ResetPasswordView();
    return vm.isLoggedIn ? const HomeView() : const LoginView();
  }
}