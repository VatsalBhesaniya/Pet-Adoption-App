import 'package:adopt_pets/models/pet.dart';
import 'package:adopt_pets/repository/pets_repository.dart';
import 'package:adopt_pets/utils/api_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'adoption_history_state.dart';
part 'adoption_history_event.dart';
part 'adoption_history_bloc.freezed.dart';

class AdoptionHistoryBloc
    extends Bloc<AdoptionHistoryEvent, AdoptionHistoryState> {
  AdoptionHistoryBloc({
    required PetsRepository petsRepository,
  })  : _petsRepository = petsRepository,
        super(const AdoptionHistoryState.initial()) {
    on<_FetchAdoptedPets>(_onFetchAdoptedPets);
  }

  final PetsRepository _petsRepository;

  Future<void> _onFetchAdoptedPets(
      _FetchAdoptedPets event, Emitter<AdoptionHistoryState> emit) async {
    emit(const AdoptionHistoryState.loadInProgress());
    final ApiResult<List<Pet>> apiResult =
        await _petsRepository.fetchAdoptedPets();
    apiResult.when(
      success: (List<Pet> pets) {
        emit(
          AdoptionHistoryState.fetchAdoptedPetsSuccess(
            pets: pets,
          ),
        );
      },
      failure: (Exception exception) {
        emit(
          AdoptionHistoryState.fetchAdoptedPetsFailure(
            exception: exception,
          ),
        );
      },
    );
  }
}
