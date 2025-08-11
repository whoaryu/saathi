import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/features/pet_adoption/domain/models/pet.dart';
import 'package:saathi/features/pet_adoption/presentation/screens/pet_detail_screen.dart';
import 'package:saathi/features/favorites/presentation/widgets/favorite_button.dart';

class PetCard extends StatefulWidget {
  final Pet pet;
  final bool showFavoriteButton;
  final VoidCallback? onFavoriteToggle;

  const PetCard({
    super.key,
    required this.pet,
    this.showFavoriteButton = true,
    this.onFavoriteToggle,
  });

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  bool _isFavorited = false;
  bool _isLoadingFavoriteStatus = true;

  @override
  void initState() {
    super.initState();
    if (widget.showFavoriteButton) {
      _checkFavoriteStatus();
    } else {
      _isLoadingFavoriteStatus = false;
    }
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final serviceProvider = ServiceProvider();
      final isFavorited = await serviceProvider.favoritesService.isFavorited(widget.pet.id);
      if (mounted) {
        setState(() {
          _isFavorited = isFavorited;
          _isLoadingFavoriteStatus = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingFavoriteStatus = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetailScreen(pet: widget.pet),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.pet.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Icon(
                          Icons.pets,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.pet.type,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ),
                  ),
                  // Favorite button
                  if (widget.showFavoriteButton && !_isLoadingFavoriteStatus)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: FavoriteButton(
                        petId: widget.pet.id,
                        initialIsFavorited: _isFavorited,
                        size: 20,
                        onToggle: () {
                          setState(() {
                            _isFavorited = !_isFavorited;
                          });
                          widget.onFavoriteToggle?.call();
                        },
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pet.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.pet.breed,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.pet.location,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn().scale(),
    );
  }
} 