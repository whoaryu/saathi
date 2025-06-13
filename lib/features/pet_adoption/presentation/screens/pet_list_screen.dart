import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/features/auth/presentation/screens/login_screen.dart';
import 'package:saathi/features/pet_adoption/domain/models/pet.dart';
import 'package:saathi/features/pet_adoption/presentation/screens/add_pet_screen.dart';
import 'package:saathi/features/pet_adoption/presentation/screens/pet_detail_screen.dart';
import 'package:saathi/features/pet_adoption/presentation/widgets/pet_card.dart';
import 'package:saathi/features/pet_grooming/presentation/screens/pet_grooming_screen.dart';
import 'package:saathi/features/pet_training/presentation/screens/pet_training_screen.dart';
import 'package:saathi/features/pet_training/presentation/screens/pet_selection_screen.dart';
import 'package:saathi/features/pet_shop/presentation/screens/pet_shop_screen.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  List<Pet> _pets = [];
  String? _selectedType;
  String? _selectedBreed;
  String? _selectedLocation;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPets() async {
    setState(() => _isLoading = true);
    try {
      final pets = await ServiceProvider().petService.getPets(
        type: _selectedType,
        searchTerm: _searchController.text.isNotEmpty ? _searchController.text : null,
      );
      setState(() => _pets = pets);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading pets: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _selectedType == null,
            onSelected: (selected) {
              setState(() {
                _selectedType = null;
                _loadPets();
              });
            },
          ),
          const SizedBox(width: 8),
          ...['Dog', 'Cat', 'Bird', 'Other'].map((type) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(type),
                selected: _selectedType == type,
                onSelected: (selected) {
                  setState(() {
                    _selectedType = selected ? type : null;
                    _loadPets();
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPetGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_pets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No pets found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _pets.length,
      itemBuilder: (context, index) {
        final pet = _pets[index];
        return PetCard(pet: pet);
      },
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 3) {
      return const PetShopScreen();
    }
    switch (_selectedIndex) {
      case 0:
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search pets...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _loadPets();
                    },
                  ),
                ),
                onSubmitted: (_) => _loadPets(),
              ),
            ),
            _buildFilterChips(),
            Expanded(child: _buildPetGrid()),
          ],
        );
      case 1:
        return const PetGroomingScreen();
      case 2:
        return  PetSelectionScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saathi Pet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPetScreen()),
              );
              if (result == true) {
                _loadPets();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ServiceProvider().authService.logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.pets),
            label: 'Adopt',
          ),
          NavigationDestination(
            icon: Icon(Icons.medical_services),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.school),
            label: 'Training',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
        ],
      ),
    );
  }
} 