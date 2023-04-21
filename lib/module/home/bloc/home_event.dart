part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.fetchPets() = _FetchPets;
  const factory HomeEvent.searchPets({
    required List<Pet> pets,
    required String searchText,
  }) = _SearchPets;
}
