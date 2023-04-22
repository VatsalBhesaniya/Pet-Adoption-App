// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:adopt_pets/main.dart';
import 'package:adopt_pets/manager/app_storage_manager.dart';
import 'package:adopt_pets/repository/pets_repository.dart';
import 'package:adopt_pets/theme/app_theme.dart';
import 'package:adopt_pets/theme/pet_adoption_theme.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAppStorageManager extends Mock implements AppStorageManager {}

class MockPetsRepository extends Mock implements PetsRepository {}

void main() {
  late AppStorageManager appStorageManager;
  late PetsRepository petsRepository;
  late FakeFirebaseFirestore firestore;
  late SharedPreferences sharedPreferences;
  setUp(() async {
    firestore = FakeFirebaseFirestore();
    SharedPreferences.setMockInitialValues(
      <String, String>{'themeMode': 'System'},
    );
    sharedPreferences = await SharedPreferences.getInstance();
    appStorageManager = AppStorageManager(
      sharedPreferences: sharedPreferences,
    );
    petsRepository = PetsRepository(
      firebaseFirestore: firestore,
    );
  });

  Widget createWidget() {
    return MultiProvider(
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
          create: (BuildContext context) => petsRepository,
        ),
      ],
      child: const PetApp(),
    );
  }

  testWidgets('Material app test', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();
  });
}
