part of 'pet_details_bloc.dart';

@freezed
class PetDetailsState with _$PetDetailsState {
  const factory PetDetailsState.initial({
    required Pet pet,
  }) = _Initial;
  const factory PetDetailsState.loadInProgress() = _LoadInProgress;
  const factory PetDetailsState.adoptPetSuccess({
    required Pet pet,
  }) = _AdoptPetSuccess;
  const factory PetDetailsState.adoptPetFailure({
    required Exception exception,
  }) = _AdoptPetFailure;
}
