import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saathi/features/pet_grooming/domain/models/grooming_booking.dart';
import 'package:saathi/features/pet_grooming/domain/models/grooming_service.dart';
import 'package:saathi/features/pet_grooming/presentation/bloc/grooming_bloc.dart';
import 'package:saathi/features/pet_grooming/presentation/bloc/grooming_event.dart';
import 'package:saathi/features/pet_grooming/presentation/bloc/grooming_state.dart';

class PetGroomingScreen extends StatelessWidget {
  const PetGroomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroomingBloc()..add(const GroomingLoadRequested()),
      child: const _PetGroomingScreenContent(),
    );
  }
}

class _PetGroomingScreenContent extends StatefulWidget {
  const _PetGroomingScreenContent();

  @override
  State<_PetGroomingScreenContent> createState() => _PetGroomingScreenContentState();
}

class _PetGroomingScreenContentState extends State<_PetGroomingScreenContent> {
  final List<String> _timeSlots = [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  GroomingService? _selectedService;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String? _selectedAnimalType;

  void _addBooking() {
    if (_selectedService == null || _selectedDate == null || _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<GroomingBloc>().add(
      GroomingAddBookingRequested(
        service: _selectedService!,
        date: _selectedDate!,
        timeSlot: _selectedTimeSlot!,
      ),
    );

    setState(() {
      _selectedService = null;
      _selectedDate = null;
      _selectedTimeSlot = null;
    });
  }

  void _deleteBooking(String bookingId) {
    context.read<GroomingBloc>().add(GroomingDeleteBookingRequested(bookingId: bookingId));
  }

  List<GroomingService> get _filteredServices {
    if (_selectedAnimalType == null) {
      return GroomingService.services;
    }
    return GroomingService.services.where((service) => service.animalType == _selectedAnimalType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocListener<GroomingBloc, GroomingState>(
        listener: (context, state) {
          if (state is GroomingAddSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking Confirmed! 🎉'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is GroomingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pet Services'),
          ),
          bottomNavigationBar: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(
                icon: Icon(Icons.spa),
                text: 'Services',
              ),
              Tab(
                icon: Icon(Icons.calendar_today),
                text: 'Book a Slot',
              ),
              Tab(
                icon: Icon(Icons.list_alt),
                text: 'My Bookings',
              ),
            ],
          ),
          body: TabBarView(
            children: [
              // Services Tab
              Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: _selectedAnimalType == null,
                          onSelected: (selected) {
                            setState(() {
                              _selectedAnimalType = null;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ...['Dog', 'Cat', 'Bird', 'Small Animal'].map((type) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(type),
                              selected: _selectedAnimalType == type,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedAnimalType = selected ? type : null;
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = _filteredServices[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getIconForAnimalType(service.animalType),
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    service.name,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '₹${service.price.toStringAsFixed(0)}',
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  service.description,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.secondaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        service.animalType,
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.timer,
                                      size: 14,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      service.duration,
                                      style: Theme.of(context).textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        ).animate().fadeIn().slideX();
                      },
                    ),
                  ),
                ],
              ),

              // Book a Slot Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Service',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<GroomingService>(
                              value: _selectedService,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              items: GroomingService.services.map((service) {
                                return DropdownMenuItem(
                                  value: service,
                                  child: Text('${service.name} (${service.animalType})'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedService = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Select Date',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 30),
                                  ),
                                );
                                if (date != null) {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                }
                              },
                              icon: const Icon(Icons.calendar_today),
                              label: Text(
                                _selectedDate == null
                                    ? 'Choose Date'
                                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Select Time',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _timeSlots.length,
                                itemBuilder: (context, index) {
                                  final timeSlot = _timeSlots[index];
                                  final isSelected = _selectedTimeSlot == timeSlot;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text(timeSlot),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          _selectedTimeSlot = selected ? timeSlot : null;
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<GroomingBloc, GroomingState>(
                      builder: (context, state) {
                        final isLoading = state is GroomingLoading;
                        return ElevatedButton(
                          onPressed: isLoading ? null : _addBooking,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Confirm Booking'),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // My Bookings Tab
              BlocBuilder<GroomingBloc, GroomingState>(
                builder: (context, state) {
                  if (state is GroomingLoading && state is! GroomingAddSuccess) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Read bookings from GroomingLoadSuccess
                  final bookings = state is GroomingLoadSuccess
                      ? state.bookings
                      : <GroomingBooking>[];

                  if (bookings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No bookings yet',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Book a grooming service to see it here',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      booking.service.name,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  if (booking.id != null)
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => _deleteBooking(booking.id!),
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    booking.formattedDate,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    booking.timeSlot,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Duration: ${booking.service.duration}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Text(
                                    '₹${booking.price.toStringAsFixed(0)}',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn().slideX();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForAnimalType(String animalType) {
    switch (animalType) {
      case 'Dog':
        return Icons.pets;
      case 'Cat':
        return Icons.pets_outlined;
      case 'Bird':
        return Icons.flutter_dash;
      case 'Small Animal':
        return Icons.emoji_nature;
      default:
        return Icons.pets;
    }
  }
}