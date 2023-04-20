import 'dart:async';

import 'package:adopt_pets/models/pet.dart';
import 'package:adopt_pets/repository/pets_repository.dart';
import 'package:adopt_pets/utils/api_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.dart';
part 'home_event.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required PetsRepository petsRepository,
  })  : _petsRepository = petsRepository,
        super(const HomeState.initial()) {
    on<_FetchPets>(_onFetchPets);
  }

  final PetsRepository _petsRepository;

  Future<FutureOr<void>> _onFetchPets(
      _FetchPets event, Emitter<HomeState> emit) async {
    emit(const HomeState.loadInProgress());
    final ApiResult<List<Pet>> apiResult = await _petsRepository.fetchPets();
    apiResult.when(
      success: (List<Pet> pets) {
        emit(
          HomeState.fetchPetsSuccess(pets: pets),
        );
      },
      failure: (Exception exception) {
        emit(
          HomeState.fetchPetsFailure(
            exception: exception,
          ),
        );
      },
    );
  }
}
