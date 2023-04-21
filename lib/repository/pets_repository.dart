import 'package:adopt_pets/models/pet.dart';
import 'package:adopt_pets/utils/api_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetsRepository {
  DocumentSnapshot<Object?>? lastDocument;
  bool hasMore = true;
  List<Pet> pets = <Pet>[];

  Future<ApiResult<List<Pet>>> fetchPets() async {
    try {
      if (!hasMore) {
        return ApiResult<List<Pet>>.success(data: pets);
      }
      QuerySnapshot<Map<String, dynamic>> petsSnapshot;
      if (lastDocument == null) {
        petsSnapshot =
            await FirebaseFirestore.instance.collection('pets').limit(8).get();
      } else {
        petsSnapshot = await FirebaseFirestore.instance
            .collection('pets')
            .startAfterDocument(lastDocument!)
            .limit(8)
            .get();
      }
      lastDocument = petsSnapshot.docs.last;
      hasMore = !(petsSnapshot.docs.length < 8);
      List<Pet> petsList = <Pet>[];
      petsList = petsSnapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> pet) {
          return Pet.fromJson(
            pet.data(),
          );
        },
      ).toList();
      pets.addAll(petsList);
      return ApiResult<List<Pet>>.success(data: pets);
    } on Exception catch (e) {
      return ApiResult<List<Pet>>.failure(
        error: e,
      );
    }
  }

  Future<ApiResult<bool>> adoptPet(Pet pet) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('pets')
              .where('id', isEqualTo: pet.id)
              .get();
      final DocumentReference<Map<String, dynamic>> docRef =
          querySnapshot.docs.first.reference;
      docRef.update(pet.toJson());
      return const ApiResult<bool>.success(data: true);
    } on Exception catch (e) {
      return ApiResult<bool>.failure(
        error: e,
      );
    }
  }

  Future<ApiResult<List<Pet>>> fetchAdoptedPets() async {
    try {
      QuerySnapshot<Map<String, dynamic>> petsSnapshot;
      petsSnapshot = await FirebaseFirestore.instance
          .collection('pets')
          .where('isAdopted', isEqualTo: true)
          .get();
      final List<Pet> adoptedPets = petsSnapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> pet) {
          return Pet.fromJson(
            pet.data(),
          );
        },
      ).toList();
      return ApiResult<List<Pet>>.success(data: adoptedPets);
    } on Exception catch (e) {
      return ApiResult<List<Pet>>.failure(
        error: e,
      );
    }
  }
}
