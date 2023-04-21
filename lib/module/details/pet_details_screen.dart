import 'package:adopt_pets/manager/app_storage_manager.dart';
import 'package:adopt_pets/models/pet.dart';
import 'package:adopt_pets/module/details/bloc/pet_details_bloc.dart';
import 'package:adopt_pets/module/details/image_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PetDetailsScreen extends StatefulWidget {
  const PetDetailsScreen({super.key});

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<PetDetailsBloc, PetDetailsState>(
          listener: (BuildContext context, PetDetailsState state) {
            state.maybeWhen(
              adoptPetSuccess: (Pet pet) {
                context.read<AppStorageManager>().setAdoptedPet(
                      pet.id.toString(),
                      pet.name,
                    );
                _adoptPetDialog(context, pet.name);
              },
              orElse: () => true,
            );
          },
          buildWhen: (PetDetailsState previous, PetDetailsState current) {
            return current.maybeWhen(
              orElse: () => true,
            );
          },
          builder: (BuildContext context, PetDetailsState state) {
            return state.maybeWhen(
              initial: (Pet pet, bool isAdopted) {
                return CustomScrollView(
                  slivers: <Widget>[
                    _sliverBox(context, pet),
                    if (!isAdopted) _sliverFill(context, pet)
                  ],
                );
              },
              orElse: () => const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> _adoptPetDialog(BuildContext context, String petName) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Thank You',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'You’ve now adopted $petName',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  SliverToBoxAdapter _sliverBox(BuildContext context, Pet pet) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          _petImage(context, pet),
          _petDetails(context, pet),
        ],
      ),
    );
  }

  SliverFillRemaining _sliverFill(BuildContext context, Pet pet) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FilledButton(
            child: const Text('Adopt Me'),
            onPressed: () {
              context.read<PetDetailsBloc>().add(
                    PetDetailsEvent.adoptPet(pet: pet),
                  );
            },
          ),
        ),
      ),
    );
  }

  Stack _petImage(BuildContext context, Pet pet) {
    return Stack(
      children: <Widget>[
        _image(pet, context),
        _backButton(context),
      ],
    );
  }

  ClipRRect _image(Pet pet, BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return ImageViewerScreen(
                  imageUrl: pet.imageUrl,
                );
              },
            ),
          );
        },
        child: Hero(
          tag: pet.id,
          child: Image.network(
            pet.imageUrl,
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Positioned _backButton(BuildContext context) {
    return Positioned(
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.white,
        icon: const Icon(
          Icons.chevron_left_rounded,
          size: 42,
        ),
      ),
    );
  }

  Widget _petDetails(BuildContext context, Pet pet) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _title(pet),
              _price(pet),
            ],
          ),
          const SizedBox(height: 16),
          _description(pet),
          const SizedBox(height: 16),
          Wrap(
            runSpacing: 16,
            spacing: 16,
            alignment: WrapAlignment.center,
            children: <Widget>[
              _petInfoCard(
                title: 'Age',
                value: '${pet.age} Years',
                backgroundColor: Colors.lime.shade100,
              ),
              _petInfoCard(
                title: 'Gender',
                value: pet.gender,
                backgroundColor: Colors.orange.shade100,
              ),
              _petInfoCard(
                title: 'Breed',
                value: pet.breed,
                backgroundColor: Colors.deepPurple.shade100,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _petInfoItem(
            icon: Icon(
              Icons.category_rounded,
              color: Colors.amberAccent.shade100,
            ),
            title: 'Category',
            value: pet.category,
          ),
          _petInfoItem(
            icon: Icon(
              Icons.my_location_rounded,
              color: Colors.teal.shade100,
            ),
            title: 'Location',
            value: pet.category,
          ),
          _petInfoItem(
            icon: Icon(
              Icons.color_lens_rounded,
              color: Colors.redAccent.shade100,
            ),
            title: 'Color',
            value: pet.color,
          ),
          _petInfoItem(
            icon: Icon(
              Icons.linear_scale_sharp,
              color: Colors.indigoAccent.shade100,
            ),
            title: 'Length',
            value: pet.length.toString(),
          ),
          _petInfoItem(
            icon: Icon(
              Icons.monitor_weight_rounded,
              color: Colors.blueAccent.shade100,
            ),
            title: 'Weight',
            value: pet.length.toString(),
          ),
        ],
      ),
    );
  }

  Text _title(Pet pet) {
    return Text(
      pet.name,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
      ),
    );
  }

  Chip _price(Pet pet) {
    return Chip(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      side: BorderSide.none,
      backgroundColor: Colors.deepPurple,
      visualDensity: VisualDensity.compact,
      label: Text(
        '\$${pet.price}',
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Text _description(Pet pet) {
    return Text(
      pet.description,
      style: TextStyle(
        color: Colors.grey.shade700,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Card _petInfoCard({
    required String title,
    required String value,
    required Color backgroundColor,
  }) {
    return Card(
      elevation: 4,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      color: backgroundColor,
      shadowColor: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _petInfoItem({
    required Icon icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: icon,
      title: Text(title),
      trailing: Text(value),
    );
  }
}
