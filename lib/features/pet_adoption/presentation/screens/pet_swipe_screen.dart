import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/features/pet_adoption/domain/models/pet.dart';
import 'package:saathi/features/pet_adoption/presentation/screens/pet_detail_screen.dart';
import 'package:saathi/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:saathi/features/pet_adoption/presentation/bloc/matchmaker_bloc.dart';
import 'package:saathi/features/pet_adoption/presentation/bloc/matchmaker_event.dart';
import 'package:saathi/features/pet_adoption/presentation/bloc/matchmaker_state.dart';

class PetSwipeCard extends StatelessWidget {
  final Pet pet;
  final double rotationAngle;

  const PetSwipeCard({
    Key? key,
    required this.pet,
    this.rotationAngle = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          // Pet Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              pet.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.pets,
                    size: 100,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
          
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                begin: Alignment.center,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Match Score Pill Overlay
          Positioned(
            top: 16,
            right: 16,
            child: MatchScorePill(pet: pet),
          ),
          
          // Pet Information
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pet.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          pet.type,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FavoriteButton(
                        petId: pet.id,
                        size: 24,
                        color: Colors.white,
                        backgroundColor: Colors.red.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pet.breed} • ${pet.age} years',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          pet.location,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Action Icons Overlay (shown when swiping)
          if (rotationAngle.abs() > 0.1)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: rotationAngle > 0 
                    ? Colors.green.withOpacity(0.3)
                    : Colors.red.withOpacity(0.3),
              ),
              child: Center(
                child: Icon(
                  rotationAngle > 0 ? Icons.favorite : Icons.close,
                  size: 100,
                  color: rotationAngle > 0 ? Colors.green : Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PetSwipeScreen extends StatefulWidget {
  const PetSwipeScreen({super.key});

  @override
  State<PetSwipeScreen> createState() => _PetSwipeScreenState();
}

class _PetSwipeScreenState extends State<PetSwipeScreen>
    with SingleTickerProviderStateMixin {
  
  List<Pet> _pets = [];
  List<Pet> _currentPets = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _selectedType;
  
  // Animation controller
  AnimationController? _controller;
  
  // Card alignments and sizes
  List<Alignment> cardAlignments = [
    Alignment(0.0, 1.0),  // Back card
    Alignment(0.0, 0.8),  // Middle card  
    Alignment(0.0, 0.0),  // Front card
  ];
  
  List<double> cardScales = [0.8, 0.85, 0.9];
  
  // Front card properties
  Alignment frontCardAlignment = Alignment(0.0, 0.0);
  double frontCardRotation = 0.0;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _resetCards();
      }
    });
    
    _loadPets();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadPets() async {
    setState(() => _isLoading = true);
    try {
      final pets = await ServiceProvider().petService.getPets(
        type: _selectedType,
      );
      setState(() {
        _pets = pets;
        _currentPets = List.from(pets);
        _currentIndex = 0;
        frontCardAlignment = Alignment(0.0, 0.0);
        frontCardRotation = 0.0;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          // Filter Chips
          _buildFilterChips(),
          
          // Cards Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _currentPets.isEmpty 
                      ? _buildNoMorePetsWidget()
                      : _buildCardStack(),
            ),
          ),
          
          // Action Buttons
          _buildActionButtons(),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    return Stack(
      children: [
        // Back card (index + 2)
        if (_currentIndex + 2 < _currentPets.length)
          _buildCard(2, cardAlignments[0], cardScales[0]),
        
        // Middle card (index + 1)  
        if (_currentIndex + 1 < _currentPets.length)
          _buildCard(1, cardAlignments[1], cardScales[1]),
        
        // Front card (index)
        if (_currentIndex < _currentPets.length)
          _buildFrontCard(),
        
        // Gesture detector
        if (_controller?.status != AnimationStatus.forward && _currentIndex < _currentPets.length)
          _buildGestureDetector(),
      ],
    );
  }

  Widget _buildCard(int offset, Alignment alignment, double scale) {
    int petIndex = _currentIndex + offset;
    if (petIndex >= _currentPets.length) return Container();
    
    return Align(
      alignment: alignment,
      child: Transform.scale(
        scale: scale,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.6,
          child: PetSwipeCard(pet: _currentPets[petIndex]),
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Align(
      alignment: frontCardAlignment,
      child: Transform.rotate(
        angle: frontCardRotation * 0.1, // Rotation factor
        child: Transform.scale(
          scale: cardScales[2],
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.6,
            child: PetSwipeCard(
              pet: _currentPets[_currentIndex],
              rotationAngle: frontCardRotation,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGestureDetector() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          // Update alignment based on drag
          frontCardAlignment = Alignment(
            frontCardAlignment.x + (details.delta.dx / MediaQuery.of(context).size.width) * 4,
            frontCardAlignment.y + (details.delta.dy / MediaQuery.of(context).size.height) * 4,
          );
          
          // Update rotation
          frontCardRotation = frontCardAlignment.x;
        });
      },
      onPanEnd: (details) {
        // Check if swipe was significant enough
        if (frontCardAlignment.x.abs() > 0.4) {
          _handleSwipe(frontCardAlignment.x > 0);
        } else {
          // Return to center
          _returnToCenter();
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Reject button
          FloatingActionButton(
            onPressed: () => _handleSwipe(false),
            backgroundColor: Colors.white,
            child: const Icon(Icons.close, color: Colors.red, size: 32),
            heroTag: "reject",
          ),
          
          // Info button
          FloatingActionButton(
            onPressed: _showPetDetails,
            backgroundColor: Colors.white,
            child: const Icon(Icons.info, color: Colors.blue, size: 32),
            heroTag: "info",
          ),
          
          // Like button
          FloatingActionButton(
            onPressed: () => _handleSwipe(true),
            backgroundColor: Colors.white,
            child: const Icon(Icons.favorite, color: Colors.green, size: 32),
            heroTag: "like",
          ),
        ],
      ),
    );
  }

  Widget _buildNoMorePetsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No more pets to show',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or check back later!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _resetPets,
            child: const Text('Start Over'),
          ),
        ],
      ),
    );
  }

  void _handleSwipe(bool isLike) {
    if (_currentIndex >= _currentPets.length) return;
    
    // Animate card off screen
    setState(() {
      frontCardAlignment = Alignment(isLike ? 3.0 : -3.0, 0.0);
      frontCardRotation = isLike ? 0.5 : -0.5;
    });
    
    // Handle the swipe action
    if (isLike) {
      _onPetLiked(_currentPets[_currentIndex]);
    } else {
      _onPetRejected(_currentPets[_currentIndex]);
    }
    
    // Animate to next card
    _controller?.forward();
  }

  void _returnToCenter() {
    setState(() {
      frontCardAlignment = Alignment(0.0, 0.0);
      frontCardRotation = 0.0;
    });
  }

  void _resetCards() {
    setState(() {
      _currentIndex++;
      frontCardAlignment = Alignment(0.0, 0.0);
      frontCardRotation = 0.0;
    });
    
    _controller?.reset();
  }

  void _resetPets() {
    setState(() {
      _currentIndex = 0;
      _currentPets = List.from(_pets);
      frontCardAlignment = Alignment(0.0, 0.0);
      frontCardRotation = 0.0;
    });
  }

  void _onPetLiked(Pet pet) async {
    // Handle pet liked - add to favorites, show interest, etc.
    print('Liked: ${pet.name}');
    try {
      final result = await ServiceProvider().favoritesService.addToFavorites(pet.id);
      if (result['success'] == true) {
        _showSnackBar('${pet.name} added to your favorites! ❤️', Colors.green);
      } else {
        _showSnackBar(result['message'] ?? 'Failed to add to favorites', Colors.orange);
      }
    } catch (e) {
      _showSnackBar('Network error saving favorite', Colors.red);
    }
  }

  void _onPetRejected(Pet pet) {
    // Handle pet rejected
    print('Rejected: ${pet.name}');
  }

  void _showPetDetails() {
    if (_currentIndex >= _currentPets.length) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetDetailScreen(pet: _currentPets[_currentIndex]),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class MatchScorePill extends StatefulWidget {
  final Pet pet;
  const MatchScorePill({super.key, required this.pet});

  @override
  State<MatchScorePill> createState() => _MatchScorePillState();
}

class _MatchScorePillState extends State<MatchScorePill> {
  late final MatchmakerBloc _matchmakerBloc;

  @override
  void initState() {
    super.initState();
    _matchmakerBloc = MatchmakerBloc()..add(MatchmakerScoreRequested(pet: widget.pet));
  }

  @override
  void dispose() {
    _matchmakerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchmakerBloc, MatchmakerState>(
      bloc: _matchmakerBloc,
      builder: (context, state) {
        if (state is MatchmakerSuccess) {
          final percentage = (state.score * 100).toStringAsFixed(0);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$percentage% Match',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }
        
        if (state is MatchmakerLoading) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  'Calculating...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
} 