part of 'adoption_history_bloc.dart';

@freezed
class AdoptionHistoryEvent with _$AdoptionHistoryEvent {
  const factory AdoptionHistoryEvent.fetchAdoptedPets() = _FetchAdoptedPets;
}
