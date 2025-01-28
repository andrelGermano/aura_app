import 'package:aura_novo/theme/theme.dart';
import 'package:aura_novo/theme/util.dart';
import 'package:aura_novo/ui/pages/reminder_page.dart';
import 'package:aura_novo/ui/widgets/auth_checker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/di/configure_providers.dart';
import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final data = await ConfigureProviders.createDependencyTree();
  runApp(AppRoot(data: data));
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key, required this.data});

  final ConfigureProviders data;


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    TextTheme textTheme = createTextTheme(context, "Quicksand", "Quicksand");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: data.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aura',
        theme: theme.light(),
        darkTheme: theme.dark(),
        highContrastDarkTheme: const MaterialTheme(TextTheme()).darkHighContrast(),
        highContrastTheme: const MaterialTheme(TextTheme()).lightHighContrast(),
        home: const AuthChecker(),
      ),
    );
  }
}