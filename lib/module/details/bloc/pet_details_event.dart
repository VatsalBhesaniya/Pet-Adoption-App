part of 'pet_details_bloc.dart';

@freezed
class PetDetailsEvent with _$PetDetailsEvent {
  const factory PetDetailsEvent.adoptPet({
    required Pet pet,
  }) = _AdoptPet;
}
