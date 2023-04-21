part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loadMorePets() = _LoadMorePets;
  const factory HomeState.fetchPetsSuccess({
    required List<Pet> pets,
    List<Pet>? searchets,
  }) = _FetchPetsSuccess;
  const factory HomeState.fetchPetsFailure({
    required Exception exception,
  }) = _FetchPetsFailure;
}
