import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/core/services/api_service.dart';
import 'package:saathi/features/pet_grooming/domain/models/grooming_booking.dart';
import 'grooming_event.dart';
import 'grooming_state.dart';

class GroomingBloc extends Bloc<GroomingEvent, GroomingState> {
  final ApiService _apiService = ServiceProvider().apiService;

  GroomingBloc() : super(const GroomingInitial()) {
    on<GroomingLoadRequested>(_onLoadRequested);
    on<GroomingAddBookingRequested>(_onAddBookingRequested);
    on<GroomingDeleteBookingRequested>(_onDeleteBookingRequested);
  }

  Future<void> _onLoadRequested(
    GroomingLoadRequested event,
    Emitter<GroomingState> emit,
  ) async {
    emit(const GroomingLoading());
    try {
      final response = await _apiService.get('/bookings');
      final data = json.decode(response.body);
      if (data['success'] == true) {
        final List list = data['data'] ?? [];
        final bookings = list.map((item) => GroomingBooking.fromJson(item)).toList();
        emit(GroomingLoadSuccess(bookings: bookings));
      } else {
        emit(GroomingFailure(errorMessage: data['message'] ?? 'Failed to load bookings.'));
      }
    } catch (e) {
      emit(GroomingFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onAddBookingRequested(
    GroomingAddBookingRequested event,
    Emitter<GroomingState> emit,
  ) async {
    emit(const GroomingLoading());
    try {
      final formattedDate = '${event.date.year}-${event.date.month.toString().padLeft(2, '0')}-${event.date.day.toString().padLeft(2, '0')}';
      
      final response = await _apiService.post(
        '/bookings',
        body: {
          'serviceName': event.service.name,
          'animalType': event.service.animalType,
          'date': formattedDate,
          'timeSlot': event.timeSlot,
          'price': event.service.price,
        },
      );

      final data = json.decode(response.body);
      if (response.statusCode == 201 && data['success'] == true) {
        emit(const GroomingAddSuccess());
        // Auto-refresh the list
        add(const GroomingLoadRequested());
      } else {
        emit(GroomingFailure(errorMessage: data['message'] ?? 'Failed to reserve booking.'));
      }
    } catch (e) {
      emit(GroomingFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteBookingRequested(
    GroomingDeleteBookingRequested event,
    Emitter<GroomingState> emit,
  ) async {
    emit(const GroomingLoading());
    try {
      final response = await _apiService.delete('/bookings/${event.bookingId}');
      final data = json.decode(response.body);
      if (data['success'] == true) {
        // Auto-refresh the list
        add(const GroomingLoadRequested());
      } else {
        emit(GroomingFailure(errorMessage: data['message'] ?? 'Failed to cancel booking.'));
      }
    } catch (e) {
      emit(GroomingFailure(errorMessage: e.toString()));
    }
  }
}
