import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/config/env.dart';
import 'data/repositories/auth_repository.dart';
import 'ui/auth_gate/auth_gate_view_model.dart';
import 'data/repositories/plant_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Env.validate();
  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthRepository(Supabase.instance.client)),
        Provider(create: (_) => PlantRepository(Supabase.instance.client)),
        ChangeNotifierProvider(
          lazy: false,
          create: (c) => AuthGateViewModel(c.read<AuthRepository>()),
        ),
      ],
      child: const App(),
    ),
  );
}