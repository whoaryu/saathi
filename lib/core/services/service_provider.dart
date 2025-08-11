import 'package:shared_preferences/shared_preferences.dart';
import 'package:saathi/core/services/api_service.dart';
import 'package:saathi/features/auth/data/services/auth_service.dart';
import 'package:saathi/features/pet_adoption/data/services/pet_service.dart';
import 'package:saathi/features/profile/data/services/profile_service.dart';
import 'package:saathi/features/favorites/data/services/favorites_service.dart';

class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._internal();
  factory ServiceProvider() => _instance;
  ServiceProvider._internal();

  late final SharedPreferences _prefs;
  late final ApiService _apiService;
  late final AuthService _authService;
  late final PetService _petService;
  late final ProfileService _profileService;
  late final FavoritesService _favoritesService;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _apiService = ApiService(_prefs);
    _authService = AuthService(_apiService, _prefs);
    _petService = PetService(_apiService);
    _profileService = ProfileService(_apiService);
    _favoritesService = FavoritesService(_apiService);
  }

  ApiService get apiService => _apiService;
  AuthService get authService => _authService;
  PetService get petService => _petService;
  ProfileService get profileService => _profileService;
  FavoritesService get favoritesService => _favoritesService;
} 