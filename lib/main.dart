import 'dart:async';

import 'package:adopt_pets/firebase_options.dart';
import 'package:adopt_pets/manager/app_storage_manager.dart';
import 'package:adopt_pets/module/home/bloc/home_bloc.dart';
import 'package:adopt_pets/module/home/home_screen.dart';
import 'package:adopt_pets/repository/pets_repository.dart';
import 'package:adopt_pets/theme/app_theme.dart';
import 'package:adopt_pets/theme/pet_adoption_theme.dart';
import 'package:adopt_pets/theme/theme_changer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    setPathUrlStrategy();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final AppStorageManager appStorageManager = AppStorageManager(
      sharedPreferences: sharedPreferences,
    );
    runApp(
      MultiProvider(
        providers: <SingleChildWidget>[
          Provider<AppTheme>.value(
            value: AppTheme(
              lightTheme: buildLightTheme(),
              darkTheme: buildDarkTheme(),
            ),
          ),
          Provider<AppStorageManager>.value(
            value: appStorageManager,
          ),
          RepositoryProvider<PetsRepository>(
            create: (BuildContext context) => PetsRepository(),
          ),
        ],
        child: const PetApp(),
      ),
    );
  }, (Object error, StackTrace stack) {});
}

class PetApp extends StatelessWidget {
  const PetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (BuildContext context) => ThemeChanger(
        appStorageManager: context.read<AppStorageManager>(),
      ),
      child: Consumer<ThemeChanger>(
        builder: (
          BuildContext context,
          ThemeChanger themeChanger,
          Widget? child,
        ) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            themeMode: themeChanger.getThemeMode(),
            theme: context.read<AppTheme>().lightTheme,
            darkTheme: context.read<AppTheme>().darkTheme,
            home: BlocProvider<HomeBloc>(
              create: (BuildContext context) => HomeBloc(
                petsRepository: RepositoryProvider.of<PetsRepository>(context),
              )..add(const HomeEvent.fetchPets()),
              child: const HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
