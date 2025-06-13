class GroomingService {
  final String name;
  final String description;
  final String duration;
  final double price;
  final String animalType;
  final String imageUrl;

  const GroomingService({
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.animalType,
    required this.imageUrl,
  });

  static const List<GroomingService> services = [
    // Dog Services
    GroomingService(
      name: 'Full Grooming',
      description: 'Complete grooming package including bath, haircut, and styling',
      duration: '2 hours',
      price: 1499.0,
      animalType: 'Dog',
      imageUrl: 'https://images.unsplash.com/photo-1591946614720-90a587da4a36',
    ),
    GroomingService(
      name: 'Bath & Brush',
      description: 'Thorough cleaning and brushing session',
      duration: '1 hour',
      price: 799.0,
      animalType: 'Dog',
      imageUrl: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b',
    ),
    GroomingService(
      name: 'Nail Trim',
      description: 'Professional nail trimming and filing',
      duration: '30 min',
      price: 299.0,
      animalType: 'Dog',
      imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1',
    ),
    GroomingService(
      name: 'Ear Cleaning',
      description: 'Gentle ear cleaning and inspection',
      duration: '30 min',
      price: 399.0,
      animalType: 'Dog',
      imageUrl: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e',
    ),
    GroomingService(
      name: 'Teeth Cleaning',
      description: 'Professional teeth cleaning and fresh breath treatment',
      duration: '45 min',
      price: 599.0,
      animalType: 'Dog',
      imageUrl: 'https://images.unsplash.com/photo-1583512603806-077998240c7a',
    ),
    GroomingService(
      name: 'Paw Treatment',
      description: 'Paw pad care and moisturizing treatment',
      duration: '30 min',
      price: 349.0,
      animalType: 'Dog',
      imageUrl: 'https://images.unsplash.com/photo-1583511655826-05700a52f8e0',
    ),

    // Cat Services
    GroomingService(
      name: 'Cat Full Grooming',
      description: 'Complete grooming package for cats including bath and styling',
      duration: '1.5 hours',
      price: 1299.0,
      animalType: 'Cat',
      imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba',
    ),
    GroomingService(
      name: 'Cat Bath & Brush',
      description: 'Gentle cleaning and brushing session for cats',
      duration: '45 min',
      price: 699.0,
      animalType: 'Cat',
      imageUrl: 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131',
    ),
    GroomingService(
      name: 'Cat Nail Trim',
      description: 'Professional nail trimming for cats',
      duration: '20 min',
      price: 249.0,
      animalType: 'Cat',
      imageUrl: 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce',
    ),
    GroomingService(
      name: 'Cat Ear Cleaning',
      description: 'Gentle ear cleaning and inspection for cats',
      duration: '20 min',
      price: 349.0,
      animalType: 'Cat',
      imageUrl: 'https://images.unsplash.com/photo-1519052537078-e6308a97aad2',
    ),

    // Bird Services
    GroomingService(
      name: 'Bird Wing Trim',
      description: 'Professional wing trimming for birds',
      duration: '30 min',
      price: 399.0,
      animalType: 'Bird',
      imageUrl: 'https://images.unsplash.com/photo-1522858547137-f1dcec554f55',
    ),
    GroomingService(
      name: 'Bird Nail Trim',
      description: 'Professional nail trimming for birds',
      duration: '20 min',
      price: 299.0,
      animalType: 'Bird',
      imageUrl: 'https://images.unsplash.com/photo-1552728089-57bdde30beb3',
    ),
    GroomingService(
      name: 'Bird Bath',
      description: 'Gentle bathing and feather care',
      duration: '30 min',
      price: 449.0,
      animalType: 'Bird',
      imageUrl: 'https://images.unsplash.com/photo-1552728089-57bdde30beb3',
    ),

    // Small Animal Services
    GroomingService(
      name: 'Small Animal Grooming',
      description: 'Complete grooming for rabbits, hamsters, and guinea pigs',
      duration: '45 min',
      price: 599.0,
      animalType: 'Small Animal',
      imageUrl: 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308',
    ),
    GroomingService(
      name: 'Small Animal Nail Trim',
      description: 'Professional nail trimming for small animals',
      duration: '20 min',
      price: 249.0,
      animalType: 'Small Animal',
      imageUrl: 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308',
    ),
  ];
} 