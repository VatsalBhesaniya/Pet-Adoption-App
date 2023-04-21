import 'package:adopt_pets/models/pet.dart';
import 'package:adopt_pets/module/home/bloc/home_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (BuildContext context, HomeState state) {
            state.maybeWhen(
              orElse: () => null,
            );
          },
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
                childAspectRatio: 0.6,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: pets.length,
              itemBuilder: (BuildContext context, int index) {
                final Pet pet = pets[index];
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: _decoration(),
                  child: _petData(pet),
                );
              },
            ),
    );
  }

  BoxDecoration _decoration() {
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
      color: Colors.white,
    );
  }

  Column _petData(Pet pet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _petImage(pet),
        const SizedBox(height: 8),
        _petName(pet),
        const SizedBox(height: 4),
        _petInfoItem(
          title: 'Age: ',
          value: '${pet.age} Years',
          backgroundColor: Colors.blue.shade100,
        ),
        _petInfoItem(
          title: 'Price: ',
          value: '\$${pet.price}',
          backgroundColor: Colors.blueAccent,
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
        child: Image.network(
          pet.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Padding _petName(Pet pet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        pet.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding _petInfoItem({
    required String title,
    required String value,
    required Color backgroundColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blueGrey,
            ),
          ),
          Chip(
            elevation: 4,
            shape: const StadiumBorder(),
            side: BorderSide.none,
            backgroundColor: Colors.blueAccent,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            label: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
