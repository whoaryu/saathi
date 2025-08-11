import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/features/auth/presentation/providers/auth_provider.dart';
import 'package:saathi/features/favorites/domain/models/favorite.dart';
import 'package:saathi/features/pet_adoption/domain/models/pet.dart';
import 'package:saathi/features/pet_adoption/presentation/screens/pet_detail_screen.dart';
import 'package:saathi/features/pet_adoption/presentation/widgets/pet_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ServiceProvider _serviceProvider = ServiceProvider();
  List<Favorite> _favorites = [];
  List<Favorite> _filteredFavorites = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String _searchQuery = '';
  String _sortBy = 'addedAt';
  String _sortOrder = 'desc';
  int _currentPage = 1;
  bool _hasMorePages = true;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMoreFavorites();
    }
  }

  Future<void> _loadFavorites({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _isRefreshing = true;
        _currentPage = 1;
      });
    } else if (!_isLoading) {
      return;
    }

    try {
      final result = await _serviceProvider.favoritesService.getFavorites(
        page: _currentPage,
        limit: 20,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      );

      if (result['success']) {
        final newFavorites = result['favorites'] as List<Favorite>;
        final pagination = result['pagination'] as Map<String, dynamic>;
        
        setState(() {
          if (refresh || _currentPage == 1) {
            _favorites = newFavorites;
          } else {
            _favorites.addAll(newFavorites);
          }
          _filteredFavorites = _favorites;
          _hasMorePages = _currentPage < (pagination['pages'] ?? 1);
          _isLoading = false;
          _isRefreshing = false;
        });
        
        _applySearch();
      } else {
        _showErrorSnackBar(result['message'] ?? 'Failed to load favorites');
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Network error: ${e.toString()}');
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _loadMoreFavorites() async {
    if (!_hasMorePages || _isLoading) return;

    setState(() {
      _currentPage++;
    });

    await _loadFavorites();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredFavorites = _favorites;
      });
    } else {
      setState(() {
        _filteredFavorites = _favorites.where((favorite) {
          final pet = favorite.pet;
          if (pet == null) return false;
          
          final query = _searchQuery.toLowerCase();
          return pet.name.toLowerCase().contains(query) ||
                 pet.breed.toLowerCase().contains(query) ||
                 pet.type.toLowerCase().contains(query) ||
                 pet.location.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  Future<void> _removeFromFavorites(String petId) async {
    try {
      final result = await _serviceProvider.favoritesService.removeFromFavorites(petId);
      
      if (result['success']) {
        setState(() {
          _favorites.removeWhere((fav) => fav.petId == petId);
          _applySearch();
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pet removed from favorites'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        _showErrorSnackBar(result['message'] ?? 'Failed to remove from favorites');
      }
    } catch (e) {
      _showErrorSnackBar('Network error: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onSortChanged(String? value) {
    if (value != null && value != _sortBy) {
      setState(() {
        _sortBy = value;
        _currentPage = 1;
      });
      _loadFavorites(refresh: true);
    }
  }

  void _onSortOrderChanged(String? value) {
    if (value != null && value != _sortOrder) {
      setState(() {
        _sortOrder = value;
        _currentPage = 1;
      });
      _loadFavorites(refresh: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _applySearch();
  }

  void _navigateToPetDetail(Pet pet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetDetailScreen(pet: pet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search favorites...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.1),
              ),
            ),
          ),
          
          // Favorites Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredFavorites.length} favorite${_filteredFavorites.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_favorites.isNotEmpty)
                  TextButton(
                    onPressed: () => _showSortDialog(),
                    child: Text('Sort by ${_sortBy == 'addedAt' ? 'Date' : 'Name'}'),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Favorites List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredFavorites.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () => _loadFavorites(refresh: true),
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _filteredFavorites.length + (_hasMorePages ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _filteredFavorites.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            
                            final favorite = _filteredFavorites[index];
                            final pet = favorite.pet;
                            
                            if (pet == null) {
                              return const SizedBox.shrink();
                            }
                            
                            return PetCard(
                              pet: pet,
                              onFavoriteToggle: () {
                                setState(() {
                                  _favorites.remove(favorite);
                                  _applySearch();
                                });
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No favorites yet' : 'No matching favorites',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Start adding pets to your favorites!'
                : 'Try adjusting your search terms',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.pets),
              label: const Text('Browse Pets'),
            ),
          ],
        ],
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Favorites'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Date Added'),
              leading: Radio<String>(
                value: 'addedAt',
                groupValue: _sortBy,
                onChanged: _onSortChanged,
              ),
            ),
            ListTile(
              title: const Text('Pet Name'),
              leading: Radio<String>(
                value: 'pet.name',
                groupValue: _sortBy,
                onChanged: _onSortChanged,
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Newest First'),
              leading: Radio<String>(
                value: 'desc',
                groupValue: _sortOrder,
                onChanged: _onSortOrderChanged,
              ),
            ),
            ListTile(
              title: const Text('Oldest First'),
              leading: Radio<String>(
                value: 'asc',
                groupValue: _sortOrder,
                onChanged: _onSortOrderChanged,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(Favorite favorite) {
    final pet = favorite.pet;
    if (pet == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Favorites'),
        content: Text('Are you sure you want to remove ${pet.name} from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeFromFavorites(favorite.petId);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
} 