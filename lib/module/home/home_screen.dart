import 'package:adopt_pets/manager/app_storage_manager.dart';
import 'package:adopt_pets/models/pet.dart';
import 'package:adopt_pets/module/details/bloc/pet_details_bloc.dart';
import 'package:adopt_pets/module/details/pet_details_screen.dart';
import 'package:adopt_pets/module/history/adoption_history_screen.dart';
import 'package:adopt_pets/module/history/bloc/adoption_history_bloc.dart';
import 'package:adopt_pets/module/home/bloc/home_bloc.dart';
import 'package:adopt_pets/repository/pets_repository.dart';
import 'package:adopt_pets/theme/theme_changer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll) {
      context.read<HomeBloc>().add(
            const HomeEvent.fetchPets(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Pets'),
        centerTitle: true,
        actions: <Widget>[
          _historyButton(context),
          _settingsButton(theme),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (HomeState previous, HomeState current) {
            return current.maybeWhen(
              loadMorePets: () => false,
              orElse: () => true,
            );
          },
          builder: (BuildContext context, HomeState state) {
            return state.maybeWhen(
              initial: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              fetchPetsSuccess: (
                List<Pet> pets,
                List<Pet>? searchPets,
              ) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Column(
                    children: <Widget>[
                      _searchBox(
                        context: context,
                        pets: pets,
                      ),
                      const SizedBox(height: 8),
                      _petGridView(searchPets ?? pets),
                    ],
                  ),
                );
              },
              fetchPetsFailure: (Exception exception) {
                return const Center(
                  child: Text('Failed to fetch pets'),
                );
              },
              orElse: () => const SizedBox(),
            );
          },
        ),
      ),
    );
  }

  IconButton _historyButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return BlocProvider<AdoptionHistoryBloc>(
                create: (BuildContext context) => AdoptionHistoryBloc(
                  petsRepository:
                      RepositoryProvider.of<PetsRepository>(context),
                ),
                child: const AdoptionHistoryScreen(),
              );
            },
          ),
        );
      },
      icon: const Icon(
        Icons.history_rounded,
      ),
    );
  }

  IconButton _settingsButton(ThemeData theme) {
    return IconButton(
      onPressed: () {
        _changeThemeDialog();
      },
      icon: Icon(
        Icons.settings,
        color: Colors.grey.shade800,
      ),
    );
  }

  Future<dynamic> _changeThemeDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Select Theme',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                _themeOptions(context),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Row _themeOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _themeOption(
          onPressed: () {
            context.read<ThemeChanger>().setTheme(AppThemeMode.light);
          },
          iconData: Icons.light_mode_rounded,
        ),
        _themeOption(
          onPressed: () {
            context.read<ThemeChanger>().setTheme(AppThemeMode.dark);
          },
          iconData: Icons.nightlight_round,
        ),
        _themeOption(
          onPressed: () {
            context.read<ThemeChanger>().setTheme(AppThemeMode.system);
          },
          iconData: Icons.settings_suggest_rounded,
        ),
      ],
    );
  }

  CircleAvatar _themeOption({
    required void Function()? onPressed,
    required IconData iconData,
  }) {
    return CircleAvatar(
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(iconData),
      ),
    );
  }

  Padding _searchBox({
    required BuildContext context,
    required List<Pet> pets,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        onChanged: (String value) {
          _searchPets(context, pets);
        },
        controller: _searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          isDense: true,
          contentPadding: EdgeInsets.zero,
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 24,
            color: Colors.blueGrey,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              _searchController.clear();
              _searchPets(context, pets);
            },
            icon: const Icon(
              Icons.close_rounded,
            ),
          ),
          hintText: 'Pet name',
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  void _searchPets(BuildContext context, List<Pet> pets) {
    context.read<HomeBloc>().add(
          HomeEvent.searchPets(
            pets: pets,
            searchText: _searchController.text.trim(),
          ),
        );
  }

  Expanded _petGridView(List<Pet> pets) {
    return Expanded(
      child: pets.isEmpty
          ? const Center(
              child: Text('No pets to show.'),
            )
          : GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: pets.length,
              itemBuilder: (BuildContext context, int index) {
                final Pet pet = pets[index];
                return _petCard(context, pet);
              },
            ),
    );
  }

  GestureDetector _petCard(BuildContext context, Pet pet) {
    return GestureDetector(
      onTap: () {
        _navigateToDetailsScreen(context, pet);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: _decoration(pet.isAdopted),
        child: _petData(pet, pet.isAdopted),
      ),
    );
  }

  Future<void> _navigateToDetailsScreen(
    BuildContext context,
    Pet pet,
  ) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return BlocProvider<PetDetailsBloc>(
            create: (BuildContext context) => PetDetailsBloc(
              pet: pet,
              petsRepository: RepositoryProvider.of<PetsRepository>(context),
            ),
            child: const PetDetailsScreen(),
          );
        },
      ),
    );
  }

  BoxDecoration _decoration(bool isAdopted) {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(16),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          blurRadius: 4,
          spreadRadius: 1,
          color: Colors.grey.shade400,
        ),
      ],
      color: isAdopted ? Colors.blueGrey.shade200 : Colors.white,
    );
  }

  Column _petData(Pet pet, bool isAdopted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _petImage(pet),
        const SizedBox(height: 12),
        _petName(pet),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _petInfoItem(
              value: '${pet.age} Years',
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            _petInfoItem(
              value: '\$${pet.price}',
              color: Colors.blueGrey.shade900,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (isAdopted) _alreadyAdopted(),
      ],
    );
  }

  Column _alreadyAdopted() {
    return Column(
      children: <Widget>[
        Center(
          child: Chip(
            backgroundColor: Colors.grey.shade700,
            side: BorderSide.none,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            label: const Text(
              'Already Adopted',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Expanded _petImage(Pet pet) {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        child: Hero(
          tag: pet.id,
          child: Image.network(
            pet.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Padding _petName(Pet pet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        pet.name,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding _petInfoItem({
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        value,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }
}
