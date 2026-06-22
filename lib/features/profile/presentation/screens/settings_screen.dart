import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:saathi/features/auth/presentation/bloc/auth_event.dart';
import 'package:saathi/features/auth/presentation/screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showDeleteAccountDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure you want to delete your account? This action cannot be undone.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _passwordController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _deleteAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profileService = ServiceProvider().profileService;
      await profileService.deleteAccount(_passwordController.text);

      if (mounted) {
        _passwordController.clear();
        Navigator.of(context).pop(); // Close dialog
        
        // Logout and navigate to login
        context.read<AuthBloc>().add(const AuthLogoutRequested());
        
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
    Color? iconColor,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? Colors.blue).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor ?? Colors.blue[600],
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Account Settings
                _buildSettingsSection(
                  title: 'Account',
                  children: [
                    _buildSettingsTile(
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      icon: Icons.lock,
                      iconColor: Colors.orange,
                      onTap: () {
                        // TODO: Navigate to change password screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Change Password feature coming soon!'),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      title: 'Privacy Settings',
                      subtitle: 'Manage your privacy preferences',
                      icon: Icons.privacy_tip,
                      iconColor: Colors.purple,
                      onTap: () {
                        // TODO: Navigate to privacy settings screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Privacy Settings feature coming soon!'),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      title: 'Delete Account',
                      subtitle: 'Permanently delete your account',
                      icon: Icons.delete_forever,
                      iconColor: Colors.red,
                      onTap: _showDeleteAccountDialog,
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: -0.2, end: 0),

                // App Settings
                _buildSettingsSection(
                  title: 'App Settings',
                  children: [
                    _buildSettingsTile(
                      title: 'Notifications',
                      subtitle: 'Manage notification preferences',
                      icon: Icons.notifications,
                      iconColor: Colors.green,
                      onTap: () {
                        // TODO: Navigate to notification settings screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification Settings feature coming soon!'),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      title: 'Language',
                      subtitle: 'Change app language',
                      icon: Icons.language,
                      iconColor: Colors.blue,
                      trailing: const Text('English'),
                      onTap: () {
                        // TODO: Navigate to language settings screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Language Settings feature coming soon!'),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      title: 'Theme',
                      subtitle: 'Choose app theme',
                      icon: Icons.palette,
                      iconColor: Colors.indigo,
                      trailing: const Text('Light'),
                      onTap: () {
                        // TODO: Navigate to theme settings screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Theme Settings feature coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: const Duration(milliseconds: 200)),

                // Support & Info
                _buildSettingsSection(
                  title: 'Support & Info',
                  children: [
                    _buildSettingsTile(
                      title: 'Help & FAQ',
                      subtitle: 'Get help and find answers',
                      icon: Icons.help,
                      iconColor: Colors.teal,
                      onTap: () {
                        // TODO: Navigate to help screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Help & FAQ feature coming soon!'),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      title: 'Contact Support',
                      subtitle: 'Get in touch with our team',
                      icon: Icons.support_agent,
                      iconColor: Colors.cyan,
                      onTap: () {
                        // TODO: Navigate to contact support screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Contact Support feature coming soon!'),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      title: 'About Saathi',
                      subtitle: 'Learn more about the app',
                      icon: Icons.info,
                      iconColor: Colors.blue,
                      onTap: () {
                        _showAboutDialog();
                      },
                    ),
                    _buildSettingsTile(
                      title: 'Terms of Service',
                      subtitle: 'Read our terms and conditions',
                      icon: Icons.description,
                      iconColor: Colors.grey,
                      onTap: () {
                        // TODO: Navigate to terms of service screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Terms of Service feature coming soon!'),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      title: 'Privacy Policy',
                      subtitle: 'Read our privacy policy',
                      icon: Icons.security,
                      iconColor: Colors.grey,
                      onTap: () {
                        // TODO: Navigate to privacy policy screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Privacy Policy feature coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: const Duration(milliseconds: 400)),

                const SizedBox(height: 20),

                // Logout Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthLogoutRequested());
                      
                      if (mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: const Duration(milliseconds: 600)),

                const SizedBox(height: 20),

                // App Version
                Text(
                  'Saathi Pet App v1.0.0',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ).animate().fadeIn(delay: const Duration(milliseconds: 800)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Saathi'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saathi Pet App',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Saathi is your trusted companion for pet adoption, care, and community. '
                'Find your perfect furry friend, access pet services, and connect with fellow pet lovers.',
                style: TextStyle(
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Made with ❤️ for pets and their humans',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
} 