import 'package:flutter/material.dart';
import 'package:saathi/core/services/service_provider.dart';

class FavoriteButton extends StatefulWidget {
  final String petId;
  final bool initialIsFavorited;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onToggle;

  const FavoriteButton({
    super.key,
    required this.petId,
    this.initialIsFavorited = false,
    this.size = 24,
    this.color,
    this.backgroundColor,
    this.onToggle,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late bool _isFavorited;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final ServiceProvider _serviceProvider = ServiceProvider();

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.initialIsFavorited;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    if (!_isFavorited) {
      _checkStatus();
    }
  }

  Future<void> _checkStatus() async {
    try {
      final favorited = await _serviceProvider.favoritesService.isFavorited(widget.petId);
      if (mounted && favorited) {
        setState(() {
          _isFavorited = true;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIsFavorited != widget.initialIsFavorited) {
      setState(() {
        _isFavorited = widget.initialIsFavorited;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _serviceProvider.favoritesService.toggleFavorite(widget.petId);
      
      if (result['success']) {
        setState(() {
          _isFavorited = result['isFavorited'];
        });
        
        // Trigger animation
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
        
        // Call callback if provided
        widget.onToggle?.call();
        
        // Show feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isFavorited 
                    ? 'Added to favorites!' 
                    : 'Removed from favorites',
              ),
              duration: const Duration(seconds: 1),
              backgroundColor: _isFavorited ? Colors.green : Colors.orange,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to update favorites'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _isLoading ? null : _toggleFavorite,
            child: Container(
              width: widget.size + 16,
              height: widget.size + 16,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? 
                       (_isFavorited ? Colors.red : Colors.white.withValues(alpha: 0.8)),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                      ),
                    )
                  : Icon(
                      _isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: widget.color ?? 
                             (_isFavorited ? Colors.white : Colors.red),
                      size: widget.size,
                    ),
            ),
          ),
        );
      },
    );
  }
}

// A simpler version for use in lists
class SimpleFavoriteButton extends StatelessWidget {
  final String petId;
  final bool isFavorited;
  final VoidCallback? onToggle;
  final double size;

  const SimpleFavoriteButton({
    super.key,
    required this.petId,
    required this.isFavorited,
    this.onToggle,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isFavorited ? Colors.red : Colors.white.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorited ? Icons.favorite : Icons.favorite_border,
          color: isFavorited ? Colors.white : Colors.red,
          size: size,
        ),
      ),
    );
  }
} 