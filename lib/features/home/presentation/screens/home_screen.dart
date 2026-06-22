import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saathi/core/theme/app_theme.dart';
import 'package:saathi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:saathi/features/auth/presentation/bloc/auth_event.dart';
import 'package:saathi/features/auth/presentation/bloc/auth_state.dart';
import 'package:saathi/features/chatbot/presentation/screens/chatbot_screen.dart';
import 'package:saathi/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:saathi/features/pet_adoption/presentation/screens/pet_list_screen.dart';
import 'package:saathi/features/pet_grooming/presentation/screens/pet_grooming_screen.dart';
import 'package:saathi/features/pet_shop/presentation/screens/pet_shop_screen.dart';
import 'package:saathi/features/pet_training/presentation/screens/pet_selection_screen.dart';
import 'package:saathi/features/profile/presentation/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _pages = <Widget>[
    _DashboardPage(),
    PetListScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Adopt',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final name = user?['name'] as String? ?? 'Friend';
    final firstName = name.split(' ').first;

    return CustomScrollView(
      slivers: [
        // --- Hero AppBar ---
        SliverAppBar(
          expandedHeight: 240,
          pinned: true,
          stretch: true,
          backgroundColor: AppTheme.primaryColor,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            background: _buildHeroHeader(context, firstName),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatbotScreen()),
                );
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
              ),
              tooltip: 'AI Assistant',
            ),
            const SizedBox(width: 8),
            _LogoutButton(),
            const SizedBox(width: 8),
          ],
        ),

        // --- Quick Actions Grid ---
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
            ).animate().fadeIn(duration: 400.ms),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.1,
            ),
            delegate: SliverChildListDelegate(
              _buildActionCards(context),
            ),
          ),
        ),

        // --- Tip Banner ---
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          sliver: SliverToBoxAdapter(
            child: _TipBanner(),
          ),
        ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }

  Widget _buildHeroHeader(BuildContext context, String firstName) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$greeting 👋',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 4),
              Text(
                firstName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.pets, color: Colors.white, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Find your perfect companion',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActionCards(BuildContext context) {
    final cards = [
      _ActionCardData(
        label: 'Adopt a Pet',
        icon: Icons.pets,
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9A6C), Color(0xFFFF6B35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        delay: 0,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PetListScreen()),
        ),
      ),
      _ActionCardData(
        label: 'Pet Services',
        icon: Icons.medical_services_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF43D8C9), Color(0xFF22B8A3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        delay: 100,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PetGroomingScreen()),
        ),
      ),
      _ActionCardData(
        label: 'Training',
        icon: Icons.school_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF9B72E8), Color(0xFF7C5CBF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        delay: 200,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PetSelectionScreen()),
        ),
      ),
      _ActionCardData(
        label: 'Pet Shop',
        icon: Icons.shopping_bag_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B9D), Color(0xFFE53E7D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        delay: 300,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PetShopScreen()),
        ),
      ),
      _ActionCardData(
        label: 'AI Chat',
        icon: Icons.smart_toy_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF5BA4CF), Color(0xFF3A7CB8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        delay: 400,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatbotScreen()),
        ),
      ),
      _ActionCardData(
        label: 'Favorites',
        icon: Icons.favorite_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB547), Color(0xFFFF9500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        delay: 500,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        ),
      ),
    ];

    return cards.map((data) {
      return _ActionCard(data: data);
    }).toList();
  }
}

class _ActionCardData {
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final int delay;
  final VoidCallback onTap;

  const _ActionCardData({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.delay,
    required this.onTap,
  });
}

class _ActionCard extends StatefulWidget {
  final _ActionCardData data;
  const _ActionCard({required this.data});

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.data.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.data.gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.data.gradient.colors.first.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -12,
                bottom: -12,
                child: Icon(
                  widget.data.icon,
                  size: 80,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.data.icon, color: Colors.white, size: 24),
                    ),
                    Text(
                      widget.data.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(
              delay: Duration(milliseconds: widget.data.delay),
              duration: const Duration(milliseconds: 400),
            ).slideY(begin: 0.2, end: 0),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
      ),
      onPressed: () => _showLogoutDialog(context),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of Saathi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class _TipBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withOpacity(0.15),
            AppTheme.primaryColor.withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppTheme.accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Did you know? 🐾',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accentColor,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pets can reduce stress by 65% and increase your happiness score significantly.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(begin: 0.2, end: 0);
  }
}
