import 'package:adopt_pets/models/pet.dart';
import 'package:adopt_pets/module/history/bloc/adoption_history_bloc.dart';
import 'package:adopt_pets/widgets/pma_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdoptionHistoryScreen extends StatefulWidget {
  const AdoptionHistoryScreen({super.key});

  @override
  State<AdoptionHistoryScreen> createState() => _AdoptionHistoryScreenState();
}

class _AdoptionHistoryScreenState extends State<AdoptionHistoryScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AdoptionHistoryBloc, AdoptionHistoryState>(
        listener: (BuildContext context, AdoptionHistoryState state) {
          state.maybeWhen(
            fetchAdoptedPetsFailure: (Exception exception) {
              petAppAlertDialog(
                context: context,
                theme: Theme.of(context),
                error: 'Something went wrong',
              );
            },
            orElse: () => null,
          );
        },
        builder: (BuildContext context, AdoptionHistoryState state) {
          return state.when(
            initial: () {
              context.read<AdoptionHistoryBloc>().add(
                    const AdoptionHistoryEvent.fetchAdoptedPets(),
                  );
              return _loader();
            },
            loadInProgress: () {
              return _loader();
            },
            fetchAdoptedPetsSuccess: (List<Pet> pets) {
              return _stepper(pets);
            },
            fetchAdoptedPetsFailure: (Exception exception) {
              return const Center(
                child: Text('Failed to fetch pets'),
              );
            },
          );
        },
      ),
    );
  }

  Center _loader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  SingleChildScrollView _stepper(List<Pet> pets) {
    return SingleChildScrollView(
      child: Stepper(
        currentStep: _index,
        onStepTapped: (int index) {
          setState(() {
            _index = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (
          BuildContext context,
          ControlsDetails details,
        ) {
          return const SizedBox();
        },
        steps: pets.map(
          (Pet pet) {
            return _step(pet);
          },
        ).toList(),
      ),
    );
  }

  Step _step(Pet pet) {
    return Step(
      isActive: true,
      title: Text(
        pet.name,
        style: TextStyle(
          fontSize: 16,
          color: Colors.blueGrey.shade900,
        ),
      ),
      subtitle: Text(
        pet.breed,
        style: const TextStyle(
          color: Colors.blueGrey,
        ),
      ),
      content: _taskDescription(pet),
    );
  }

  Card _taskDescription(Pet pet) {
    return Card(
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          pet.description,
          style: const TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
