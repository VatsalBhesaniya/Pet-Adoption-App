import 'package:adopt_pets/models/pet.dart';
import 'package:adopt_pets/module/home/bloc/home_bloc.dart';
import 'package:adopt_pets/repository/pets_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Home Bloc', () {
    late FakeFirebaseFirestore firestore;
    late HomeBloc homeBloc;
    final Pet pet = Pet(
      id: 1,
      name: 'name',
      description: 'description',
      age: 2,
      price: 1000,
      imageUrl: 'imageUrl',
      location: 'location',
      gender: 'Male',
      weight: 2,
      length: 1,
      breed: 'breed',
      color: 'color',
      category: 'category',
    );
    final List<dynamic> petData = <dynamic>[pet.toJson()];

    setUp(() async {
      firestore = FakeFirebaseFirestore();
      homeBloc = HomeBloc(
          petsRepository: PetsRepository(
        firebaseFirestore: firestore,
      ));
      final CollectionReference<Map<String, dynamic>> doc =
          firestore.collection('pets');
      await doc.add(pet.toJson());
    });

    blocTest<HomeBloc, HomeState>(
      'Success',
      setUp: () async {
        await firestore.collection('pets').limit(8).get();
      },
      build: () => homeBloc,
      act: (HomeBloc bloc) => bloc.add(
        const HomeEvent.fetchPets(),
      ),
      wait: const Duration(milliseconds: 10),
      expect: () => <HomeState>[
        const HomeState.loadMorePets(),
        HomeState.fetchPetsSuccess(
          pets: <Pet>[pet],
        ),
      ],
    );
  });
}
