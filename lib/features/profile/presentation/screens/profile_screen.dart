import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/features/profile/domain/models/user_profile.dart';
import 'package:saathi/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:saathi/features/profile/presentation/screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _userProfile;
  Map<String, int>? _userStats;
  bool _isLoading = true;
  bool _isUploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() => _isLoading = true);
      
      final profileService = ServiceProvider().profileService;
      final [profile, stats] = await Future.wait([
        profileService.getProfile(),
        profileService.getUserStats(),
      ]);

      if (mounted) {
        setState(() {
          _userProfile = profile as UserProfile;
          _userStats = stats as Map<String, int>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() => _isUploadingAvatar = true);

        final profileService = ServiceProvider().profileService;
        final newAvatarName = await profileService.uploadAvatar(File(pickedFile.path));

        if (mounted) {
          setState(() {
            _userProfile = _userProfile?.copyWith(profileImage: newAvatarName);
            _isUploadingAvatar = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avatar updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload avatar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userProfile == null
              ? _buildErrorState()
              : _buildProfileContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load profile',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadProfile,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Container(
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(),
              
              const SizedBox(height: 24),
              
              // Stats Cards
              if (_userStats != null) _buildStatsCards(),
              
              const SizedBox(height: 24),
              
              // Profile Actions
              _buildProfileActions(),
              
              const SizedBox(height: 24),
              
              // Profile Details
              _buildProfileDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar Section
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: _userProfile!.profileImage != null
                    ? NetworkImage('http://192.168.29.188:5000/uploads/avatars/${_userProfile!.profileImage}')
                    : null,
                child: _userProfile!.profileImage == null
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[400],
                      )
                    : null,
              ),
              if (_isUploadingAvatar)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _isUploadingAvatar ? null : _pickAndUploadImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // User Info
          Text(
            _userProfile!.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
            textAlign: TextAlign.center,
          ),
          
          if (_userProfile!.email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              _userProfile!.email,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          
          if (_userProfile!.location != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  _userProfile!.location!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildStatsCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'My Pets',
          _userStats!['totalPets']?.toString() ?? '0',
          Icons.pets,
          Colors.orange,
        ),
        _buildStatCard(
          'Adoptions',
          _userStats!['totalAdoptions']?.toString() ?? '0',
          Icons.favorite,
          Colors.red,
        ),
        _buildStatCard(
          'Pending',
          _userStats!['pendingAdoptions']?.toString() ?? '0',
          Icons.schedule,
          Colors.blue,
        ),
        _buildStatCard(
          'Approved',
          _userStats!['approvedAdoptions']?.toString() ?? '0',
          Icons.check_circle,
          Colors.green,
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: const Duration(milliseconds: 200));
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionTile(
            'Edit Profile',
            Icons.edit,
            Colors.blue,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(userProfile: _userProfile!),
                ),
              ).then((_) => _loadProfile());
            },
          ),
          const Divider(height: 1),
          _buildActionTile(
            'My Pets',
            Icons.pets,
            Colors.orange,
            () {
              // TODO: Navigate to user's pets screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('My Pets feature coming soon!')),
              );
            },
          ),
          const Divider(height: 1),
          _buildActionTile(
            'Adoption History',
            Icons.history,
            Colors.purple,
            () {
              // TODO: Navigate to adoption history screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Adoption History feature coming soon!')),
              );
            },
          ),
          const Divider(height: 1),
          _buildActionTile(
            'Settings',
            Icons.settings,
            Colors.grey,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: const Duration(milliseconds: 400));
  }

  Widget _buildActionTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildProfileDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
          ),
          const SizedBox(height: 16),
          if (_userProfile!.bio != null && _userProfile!.bio!.isNotEmpty)
            Text(
              _userProfile!.bio!,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                height: 1.5,
              ),
            )
          else
            Text(
              'No bio added yet.',
              style: TextStyle(
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          const SizedBox(height: 20),
          if (_userProfile!.preferences != null) ...[
            Text(
              'Preferences',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
            const SizedBox(height: 16),
            _buildPreferencesSection(),
          ],
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: const Duration(milliseconds: 600));
  }

  Widget _buildPreferencesSection() {
    final prefs = _userProfile!.preferences!;
    
    return Column(
      children: [
        if (prefs.petTypes.isNotEmpty) ...[
          _buildPreferenceItem(
            'Preferred Pet Types',
            prefs.petTypes.join(', '),
            Icons.pets,
          ),
          const SizedBox(height: 12),
        ],
        if (prefs.maxAge != null) ...[
          _buildPreferenceItem(
            'Maximum Pet Age',
            '${prefs.maxAge} years',
            Icons.cake,
          ),
          const SizedBox(height: 12),
        ],
        _buildPreferenceItem(
          'Email Notifications',
          prefs.notifications.email ? 'Enabled' : 'Disabled',
          Icons.email,
        ),
        const SizedBox(height: 12),
        _buildPreferenceItem(
          'Push Notifications',
          prefs.notifications.push ? 'Enabled' : 'Disabled',
          Icons.notifications,
        ),
      ],
    );
  }

  Widget _buildPreferenceItem(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 