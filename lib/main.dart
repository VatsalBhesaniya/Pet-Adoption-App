import 'package:adopt_pets/firebase_options.dart';
import 'package:adopt_pets/module/home/bloc/home_bloc.dart';
import 'package:adopt_pets/module/home/home_screen.dart';
import 'package:adopt_pets/repository/pets_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: BlocProvider<HomeBloc>(
        create: (BuildContext context) => HomeBloc(
          petsRepository: PetsRepository(),
        )..add(const HomeEvent.fetchPets()),
        child: const HomeScreen(),
      ),
    );
  }
}
