import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:saathi/core/services/api_service.dart';
import 'package:saathi/features/pet_adoption/domain/models/pet.dart';

class PetService {
  final ApiService _apiService;

  PetService(this._apiService);

  Future<List<Pet>> getPets({
    String? type,
    String? searchTerm,
    int? minAge,
    int? maxAge,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (type != null) queryParams['type'] = type;
      if (searchTerm != null) queryParams['search'] = searchTerm;
      if (minAge != null) queryParams['minAge'] = minAge.toString();
      if (maxAge != null) queryParams['maxAge'] = maxAge.toString();

      print('🐕 Fetching pets with params: $queryParams');
      
      final response = await _apiService.get('/pets', queryParams: queryParams);
      final data = json.decode(response.body);
      
      print('📊 Response data: $data');
      
      if (data['success'] == true) {
        if (data['data'] is List) {
          final pets = (data['data'] as List).map((json) => Pet.fromJson(json)).toList();
          print('✅ Successfully loaded ${pets.length} pets');
          return pets;
        } else if (data['data'] is Map) {
          // If the API returns a single pet as a map
          final pet = Pet.fromJson(data['data']);
          print('✅ Successfully loaded 1 pet');
          return [pet];
        }
      }
      
      print('⚠️ No pets found or invalid response format');
      return [];
    } catch (e) {
      print('❌ Error fetching pets: $e');
      rethrow;
    }
  }

  Future<Pet> getPet(String id) async {
    final response = await _apiService.get('/pets/$id');
    final data = json.decode(response.body);
    if (data['success'] == true) {
      return Pet.fromJson(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to get pet details');
  }

  Future<Pet> createPet({
    required String name,
    required String type,
    required String breed,
    required int age,
    required String description,
    required String location,
    required File imageFile,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiService.baseUrl}/pets'),
      );

      // Add headers
      request.headers.addAll(_apiService.headers);
      
      // Add text fields
      request.fields.addAll({
        'name': name,
        'type': type,
        'breed': breed,
        'age': age.toString(),
        'description': description,
        'location': location,
      });

      // Add image file
      final imageStream = http.ByteStream(imageFile.openRead());
      final imageLength = await imageFile.length();
      
      final multipartFile = http.MultipartFile(
        'image',
        imageStream,
        imageLength,
        filename: '${name.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      
      request.files.add(multipartFile);

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 201) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to create pet. Status: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return Pet.fromJson(data['data']);
      } else {
        throw Exception('Invalid response format: ${response.body}');
      }
    } catch (e) {
      print('Error in createPet: $e');
      rethrow;
    }
  }

  Future<Pet> updatePet({
    required String id,
    String? name,
    String? type,
    String? breed,
    int? age,
    String? description,
    String? location,
    File? imageFile,
  }) async {
    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse('${ApiService.baseUrl}/pets/$id'),
    );

    request.headers.addAll(_apiService.headers);
    if (name != null) request.fields['name'] = name;
    if (type != null) request.fields['type'] = type;
    if (breed != null) request.fields['breed'] = breed;
    if (age != null) request.fields['age'] = age.toString();
    if (description != null) request.fields['description'] = description;
    if (location != null) request.fields['location'] = location;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    return Pet.fromJson(json.decode(response.body));
  }

  Future<void> deletePet(String id) async {
    await _apiService.delete('/pets/$id');
  }

  Future<void> submitAdoptionRequest({
    required String petId,
    required String name,
    required String email,
    required String phone,
    required String reason,
  }) async {
    await _apiService.post(
      '/pets/$petId/adopt',
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'reason': reason,
      },
    );
  }

  Future<void> updateAdoptionRequestStatus({
    required String petId,
    required String requestId,
    required String status,
  }) async {
    await _apiService.patch(
      '/pets/$petId/adopt/$requestId',
      body: {'status': status},
    );
  }
} 