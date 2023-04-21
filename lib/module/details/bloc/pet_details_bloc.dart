import 'package:adopt_pets/models/pet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_details_state.dart';
part 'pet_details_event.dart';
part 'pet_details_bloc.freezed.dart';

class PetDetailsBloc extends Bloc<PetDetailsEvent, PetDetailsState> {
  PetDetailsBloc({
    required Pet pet,
    required bool isAdopted,
  }) : super(PetDetailsState.initial(
          pet: pet,
          isAdopted: isAdopted,
        )) {
    on<_AdoptPet>(_onAdoptPet);
  }

  void _onAdoptPet(_AdoptPet event, Emitter<PetDetailsState> emit) {
    emit(
      const PetDetailsState.loadInProgress(),
    );
    emit(
      PetDetailsState.adoptPetSuccess(
        pet: event.pet,
      ),
    );
  }
}
