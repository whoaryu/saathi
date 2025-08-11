import 'package:flutter/material.dart';
import 'dart:math';

// pet_card.dart
class Pet {
  final String name;
  final String breed;
  final int age;
  final String imageUrl;
  final String description;
  final String location;

  Pet({
    required this.name,
    required this.breed,
    required this.age,
    required this.imageUrl,
    required this.description,
    required this.location,
  });
}

class PetCard extends StatelessWidget {
  final Pet pet;
  final double rotationAngle;

  const PetCard({
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
                      Text(
                        '${pet.age} years',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pet.breed,
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
                      Text(
                        pet.location,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
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

// pet_swipe_screen.dart
class PetSwipeScreen extends StatefulWidget {
  @override
  _PetSwipeScreenState createState() => _PetSwipeScreenState();
}

class _PetSwipeScreenState extends State<PetSwipeScreen>
    with SingleTickerProviderStateMixin {
  
  // Sample pet data - replace with your actual data source
  List<Pet> pets = [
    Pet(
      name: "Buddy",
      breed: "Golden Retriever",
      age: 3,
      imageUrl: "https://example.com/dog1.jpg",
      description: "Friendly and energetic dog looking for a loving home.",
      location: "Mumbai, Maharashtra",
    ),
    Pet(
      name: "Whiskers",
      breed: "Persian Cat",
      age: 2,
      imageUrl: "https://example.com/cat1.jpg",
      description: "Calm and affectionate cat who loves to cuddle.",
      location: "Delhi, India",
    ),
    Pet(
      name: "Max",
      breed: "German Shepherd",
      age: 4,
      imageUrl: "https://example.com/dog2.jpg",
      description: "Loyal and protective dog, great with kids.",
      location: "Bangalore, Karnataka",
    ),
  ];

  List<Pet> currentPets = [];
  int currentIndex = 0;
  
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
    
    // Initialize pets list
    currentPets = List.from(pets);
    
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
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      
      body: Column(
        children: [
          // Cards Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: currentPets.isEmpty 
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
        if (currentIndex + 2 < currentPets.length)
          _buildCard(2, cardAlignments[0], cardScales[0]),
        
        // Middle card (index + 1)  
        if (currentIndex + 1 < currentPets.length)
          _buildCard(1, cardAlignments[1], cardScales[1]),
        
        // Front card (index)
        if (currentIndex < currentPets.length)
          _buildFrontCard(),
        
        // Gesture detector
        if (_controller?.status != AnimationStatus.forward && currentIndex < currentPets.length)
          _buildGestureDetector(),
      ],
    );
  }

  Widget _buildCard(int offset, Alignment alignment, double scale) {
    int petIndex = currentIndex + offset;
    if (petIndex >= currentPets.length) return Container();
    
    return Align(
      alignment: alignment,
      child: Transform.scale(
        scale: scale,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.6,
          child: PetCard(pet: currentPets[petIndex]),
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
            child: PetCard(
              pet: currentPets[currentIndex],
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
            'Check back later for new arrivals!',
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
    if (currentIndex >= currentPets.length) return;
    
    // Animate card off screen
    setState(() {
      frontCardAlignment = Alignment(isLike ? 3.0 : -3.0, 0.0);
      frontCardRotation = isLike ? 0.5 : -0.5;
    });
    
    // Handle the swipe action
    if (isLike) {
      _onPetLiked(currentPets[currentIndex]);
    } else {
      _onPetRejected(currentPets[currentIndex]);
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
      currentIndex++;
      frontCardAlignment = Alignment(0.0, 0.0);
      frontCardRotation = 0.0;
    });
    
    _controller?.reset();
  }

  void _resetPets() {
    setState(() {
      currentIndex = 0;
      currentPets = List.from(pets);
      frontCardAlignment = Alignment(0.0, 0.0);
      frontCardRotation = 0.0;
    });
  }

  void _onPetLiked(Pet pet) {
    // Handle pet liked - add to favorites, show interest, etc.
    print('Liked: ${pet.name}');
    _showSnackBar('${pet.name} added to your favorites! ❤️', Colors.green);
  }

  void _onPetRejected(Pet pet) {
    // Handle pet rejected
    print('Rejected: ${pet.name}');
  }

  void _showPetDetails() {
    if (currentIndex >= currentPets.length) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPetDetailsModal(currentPets[currentIndex]),
    );
  }

  Widget _buildPetDetailsModal(Pet pet) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Pet image
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(pet.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Pet details
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${pet.breed} • ${pet.age} years old',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      Text(pet.location),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pet.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
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