import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet.freezed.dart';
part 'pet.g.dart';

@freezed
class Pet with _$Pet {
  factory Pet({
    @JsonKey() required String name,
    @JsonKey() required String description,
    @JsonKey() required int age,
    @JsonKey() required double price,
    @JsonKey() required String imageUrl,
  }) = _Pet;

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}
