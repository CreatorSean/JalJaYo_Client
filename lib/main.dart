import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaljayo/firebase_options.dart';
import 'package:jaljayo/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: JalJaYo(),
    ),
  );
}

class JalJaYo extends ConsumerWidget {
  const JalJaYo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvier),
      title: 'JalJaYo',
      themeMode: ThemeMode.system,
    );
  }
}
