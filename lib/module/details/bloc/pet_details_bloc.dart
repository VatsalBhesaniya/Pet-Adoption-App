import 'package:adopt_pets/models/pet.dart';
import 'package:adopt_pets/repository/pets_repository.dart';
import 'package:adopt_pets/utils/api_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_details_state.dart';
part 'pet_details_event.dart';
part 'pet_details_bloc.freezed.dart';

class PetDetailsBloc extends Bloc<PetDetailsEvent, PetDetailsState> {
  PetDetailsBloc({
    required Pet pet,
    required PetsRepository petsRepository,
  })  : _petsRepository = petsRepository,
        super(PetDetailsState.initial(pet: pet)) {
    on<_AdoptPet>(_onAdoptPet);
  }

  final PetsRepository _petsRepository;

  Future<void> _onAdoptPet(
      _AdoptPet event, Emitter<PetDetailsState> emit) async {
    emit(
      const PetDetailsState.loadInProgress(),
    );
    final ApiResult<bool> apiResult = await _petsRepository.adoptPet(
      event.pet,
    );
    apiResult.when(
      success: (bool isAdopted) {
        if (isAdopted) {
          emit(
            PetDetailsState.adoptPetSuccess(
              pet: event.pet,
            ),
          );
        }
      },
      failure: (Exception exception) {
        emit(
          PetDetailsState.adoptPetFailure(
            exception: exception,
          ),
        );
      },
    );
  }
}
