import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet.freezed.dart';
part 'pet.g.dart';

@freezed
class Pet with _$Pet {
  factory Pet({
    @JsonKey() required int id,
    @JsonKey() required String name,
    @JsonKey() required String description,
    @JsonKey() required int age,
    @JsonKey() required double price,
    @JsonKey() required String imageUrl,
    @JsonKey() required String location,
    @JsonKey() required String gender,
    @JsonKey() required double weight,
    @JsonKey() required double length,
    @JsonKey() required String breed,
    @JsonKey() required String color,
    @JsonKey() required String category,
  }) = _Pet;

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}
