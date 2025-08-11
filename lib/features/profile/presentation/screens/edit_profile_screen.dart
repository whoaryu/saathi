import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/features/profile/domain/models/user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile userProfile;

  const EditProfileScreen({
    super.key,
    required this.userProfile,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  
  bool _isLoading = false;
  List<String> _selectedPetTypes = [];
  int? _maxAge;
  
  // Notification settings
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _adoptionUpdates = true;
  bool _newPets = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserPreferences();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.userProfile.name);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _phoneController = TextEditingController(text: widget.userProfile.phone ?? '');
    _bioController = TextEditingController(text: widget.userProfile.bio ?? '');
    _locationController = TextEditingController(text: widget.userProfile.location ?? '');
  }

  void _loadUserPreferences() {
    final prefs = widget.userProfile.preferences;
    if (prefs != null) {
      _selectedPetTypes = List.from(prefs.petTypes);
      _maxAge = prefs.maxAge;
      _emailNotifications = prefs.notifications.email;
      _pushNotifications = prefs.notifications.push;
      _adoptionUpdates = prefs.notifications.adoptionUpdates;
      _newPets = prefs.notifications.newPets;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final profileService = ServiceProvider().profileService;
      
      // Create preferences object
      final preferences = UserPreferences(
        petTypes: _selectedPetTypes,
        maxAge: _maxAge,
        notifications: NotificationSettings(
          email: _emailNotifications,
          push: _pushNotifications,
          adoptionUpdates: _adoptionUpdates,
          newPets: _newPets,
        ),
      );

      await profileService.updateProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        bio: _bioController.text.isEmpty ? null : _bioController.text,
        location: _locationController.text.isEmpty ? null : _locationController.text,
        preferences: preferences,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines,
    int? maxLength,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue[600], size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPetTypesSection() {
    const petTypes = ['Dog', 'Cat', 'Bird', 'Other'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferred Pet Types',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: petTypes.map((type) {
              final isSelected = _selectedPetTypes.contains(type);
              return FilterChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedPetTypes.add(type);
                    } else {
                      _selectedPetTypes.remove(type);
                    }
                  });
                },
                selectedColor: Colors.blue[100],
                checkmarkColor: Colors.blue[600],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMaxAgeSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Maximum Pet Age',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: _maxAge,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            hint: const Text('Select maximum age'),
            items: [
              const DropdownMenuItem(value: null, child: Text('No preference')),
              ...List.generate(20, (index) => index + 1).map((age) {
                return DropdownMenuItem(
                  value: age,
                  child: Text('$age years'),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                _maxAge = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          _buildNotificationTile(
            'Email Notifications',
            'Receive updates via email',
            Icons.email,
            _emailNotifications,
            (value) => setState(() => _emailNotifications = value),
          ),
          _buildNotificationTile(
            'Push Notifications',
            'Receive push notifications',
            Icons.notifications,
            _pushNotifications,
            (value) => setState(() => _pushNotifications = value),
          ),
          _buildNotificationTile(
            'Adoption Updates',
            'Get notified about adoption status',
            Icons.favorite,
            _adoptionUpdates,
            (value) => setState(() => _adoptionUpdates = value),
          ),
          _buildNotificationTile(
            'New Pets',
            'Get notified about new pets',
            Icons.pets,
            _newPets,
            (value) => setState(() => _newPets = value),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue[600],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[600]!,
              Colors.blue[50]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Basic Information
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Basic Information',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: 'Full Name',
                          controller: _nameController,
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          label: 'Email',
                          controller: _emailController,
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          label: 'Phone (Optional)',
                          controller: _phoneController,
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        _buildTextField(
                          label: 'Bio (Optional)',
                          controller: _bioController,
                          icon: Icons.description,
                          maxLines: 3,
                          maxLength: 500,
                        ),
                        _buildTextField(
                          label: 'Location (Optional)',
                          controller: _locationController,
                          icon: Icons.location_on,
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: -0.2, end: 0),
                  
                  const SizedBox(height: 20),
                  
                  // Preferences
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preferences',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                        ),
                        const SizedBox(height: 20),
                        _buildPetTypesSection(),
                        _buildMaxAgeSection(),
                        _buildNotificationSection(),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: const Duration(milliseconds: 200)),
                  
                  const SizedBox(height: 30),
                  
                  // Save Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[600]!, Colors.purple[600]!],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.save, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: const Duration(milliseconds: 400)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 