import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/config/env.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/plant_repository.dart';
import 'data/services/push_service.dart';
import 'firebase_options.dart';
import 'ui/auth_gate/auth_gate_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Env.validate();
  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
  );

  if (PushService.supported) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthRepository(Supabase.instance.client)),
        Provider(create: (_) => PlantRepository(Supabase.instance.client)),
        Provider(create: (_) => PushService(Supabase.instance.client)),
        ChangeNotifierProvider(
          lazy: false,
          create: (c) => AuthGateViewModel(c.read<AuthRepository>()),
        ),
      ],
      child: const App(),
    ),
  );
}