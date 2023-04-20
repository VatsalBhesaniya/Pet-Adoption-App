import 'package:adopt_pets/models/pet.dart';
import 'package:adopt_pets/utils/api_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetsRepository {
  Future<ApiResult<List<Pet>>> fetchPets() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> petsSnapshot =
          await FirebaseFirestore.instance.collection('pets').get();
      List<Pet> pets = <Pet>[];
      pets = petsSnapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> pet) {
          return Pet.fromJson(
            pet.data(),
          );
        },
      ).toList();
      return ApiResult<List<Pet>>.success(data: pets);
    } on Exception catch (e) {
      return ApiResult<List<Pet>>.failure(
        error: e,
      );
    }
  }
}
