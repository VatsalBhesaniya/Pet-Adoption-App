part of 'adoption_history_bloc.dart';

@freezed
class AdoptionHistoryState with _$AdoptionHistoryState {
  const factory AdoptionHistoryState.initial() = _Initial;
  const factory AdoptionHistoryState.loadInProgress() = _LoadInProgress;
  const factory AdoptionHistoryState.fetchAdoptedPetsSuccess({
    required List<Pet> pets,
  }) = _fetchAdoptedPetsSuccess;
  const factory AdoptionHistoryState.fetchAdoptedPetsFailure({
    required Exception exception,
  }) = _fetchAdoptedPetsFailure;
}
