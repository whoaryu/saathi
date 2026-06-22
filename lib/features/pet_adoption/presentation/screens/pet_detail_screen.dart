import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/features/pet_adoption/domain/models/pet.dart';
import 'package:saathi/features/pet_adoption/presentation/widgets/adoption_request_dialog.dart';
import 'package:saathi/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;

  const PetDetailScreen({
    super.key,
    required this.pet,
  });

  Future<void> _launchWhatsApp(BuildContext context, String phone, String petName) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-()+]+'), '');
    final message = Uri.encodeComponent("Hello! I'm interested in adopting $petName from Saathi. Can you share more details?");
    final url = "https://wa.me/$cleanPhone?text=$message";
    
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to direct launch
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open WhatsApp: $e')),
        );
      }
    }
  }

  Widget _buildInfoSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    ).animate().fadeIn().slideX(begin: 0.2, end: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                pet.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.pets,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pet.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          pet.type,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FavoriteButton(
                        petId: pet.id,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pet.breed,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoSection(
                    context,
                    'Age',
                    '${pet.age} years old',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    context,
                    'Location',
                    pet.location,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    context,
                    'Description',
                    pet.description,
                  ),
                  const SizedBox(height: 16),
                  if (pet.ownerName != null)
                    _buildInfoSection(
                      context,
                      'Owner/Shelter Name',
                      pet.ownerName!,
                    ),
                  const SizedBox(height: 100), // Spacing to avoid bottom navigation overlap
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final phone = pet.ownerPhone;
                    if (phone != null && phone.isNotEmpty) {
                      _launchWhatsApp(context, phone, pet.name);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Owner's WhatsApp contact not available. Please submit an adoption request."),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.chat, color: Colors.green),
                  label: const Text('Contact Owner'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.green, width: 2),
                    foregroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => AdoptionRequestDialog(pet: pet),
                    );
                    if (result == true && context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Adopt Me'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}