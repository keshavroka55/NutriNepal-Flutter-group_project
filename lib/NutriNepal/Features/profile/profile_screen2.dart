import 'package:flutter/material.dart';
import 'package:nutrinepal_1/NutriNepal/Features/logs/logs_history2.dart';
import 'package:provider/provider.dart';
import '../../API/api_client.dart';
import '../../UI/splashes/app_colors.dart';
import '../../UI/widgets/bottom_control_panel.dart';
import '../../UI/widgets/testing.dart';
import '../Auth2/auth_service.dart';
import '../Auth2/login_page.dart';
import '../logs/totals_screen.dart';
import '../logs/totals_screen2.dart';
import 'profile_api.dart';
import 'profile_model.dart';
import 'profile_update_screen.dart';

class ProfileScreen2 extends StatefulWidget {
  const ProfileScreen2({super.key});

  @override
  State<ProfileScreen2> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen2> {
  UserProfile? profile;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final api = Provider.of<ProfileApi>(context, listen: false);
      final p = await api.getProfile();

      if (!mounted) return;

      setState(() {
        profile = p;
        error = null;
      });
    } catch (e) {
      if (e is ApiException && e.statusCode == 404) {
        setState(() {
          profile = null;
          error = null;
        });
      } else {
        setState(() {
          error = 'Failed to load profile: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NutriColors.background,
      body: _buildBody(),
      bottomNavigationBar: const BottomControlPanel(currentIndex: 3),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: NutriColors.primary,
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: NutriColors.danger,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                error!,
                style: TextStyle(
                  color: NutriColors.danger,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loadProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: NutriColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (profile == null) {
      return _buildNoProfileView();
    }

    return _buildProfileView();
  }

  Widget _buildNoProfileView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: NutriColors.primaryDark,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_add_alt_1,
                      size: 50,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Complete Your Profile',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Personalize your nutrition journey',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.emoji_objects_outlined,
                        size: 60,
                        color: NutriColors.accent.withOpacity(0.3),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Why create a profile?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: NutriColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        icon: Icons.tablet,
                        title: 'Personalized Goals',
                        description: 'Set nutrition targets based on your needs',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(
                        icon: Icons.trending_up,
                        title: 'Track Progress',
                        description: 'Monitor your daily nutrition intake',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(
                        icon: Icons.recommend,
                        title: 'Smart Recommendations',
                        description: 'Get food suggestions tailored for you',
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final created = await Navigator.push<UserProfile?>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfileUpdateScreen(initial: null),
                              ),
                            );
                            if (created != null) {
                              setState(() => profile = created);
                            } else {
                              loadProfile();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NutriColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Create Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: loadProfile,
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      color: NutriColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          Container(
            height: 280,
            decoration: BoxDecoration(
              color: NutriColors.primaryDark,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              color: Colors.white.withOpacity(0.1),
                              image: profile!.photoUrl != null
                                  ? DecorationImage(
                                image: NetworkImage(profile!.photoUrl!),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: profile!.photoUrl == null
                                ? Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white.withOpacity(0.7),
                            )
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: NutriColors.accent,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                color: Colors.white,
                                onPressed: () async {
                                  final updated = await Navigator.push<UserProfile?>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProfileUpdateScreen(initial: profile),
                                    ),
                                  );
                                  if (updated != null) {
                                    setState(() => profile = updated);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        profile!.username,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile!.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: NutriColors.accent,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Premium Member',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats Grid
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 0.85,
              children: [
                _buildStatCard(
                  title: 'Calories',
                  value: '${profile!.dailyCalories}',
                  unit: 'Cal',
                  icon: Icons.local_fire_department,
                  color: NutriColors.accent,
                ),
                _buildStatCard(
                  title: 'Protein',
                  value: '${profile!.dailyProtein}',
                  unit: 'g',
                  icon: Icons.fitness_center,
                  color: NutriColors.success,
                ),
                _buildStatCard(
                  title: 'Carbs',
                  value: '${profile!.dailyCarbs}',
                  unit: 'g',
                  icon: Icons.energy_savings_leaf,
                  color: NutriColors.accentLight,
                ),
                _buildStatCard(
                  title: 'Fat',
                  value: '${profile!.dailyFat}',
                  unit: 'g',
                  icon: Icons.water_drop,
                  color: NutriColors.danger.withOpacity(0.8),
                ),
              ],
            ),
          ),

          // Quick Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: NutriColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        icon: Icons.history,
                        label: 'History',
                        color: NutriColors.primary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LogsHistoryScreen2()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        icon: Icons.calculate,
                        label: 'Totals',
                        color: NutriColors.success,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TotalsScreen2()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        icon: Icons.insights,
                        label: 'Insights',
                        color: NutriColors.accent,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Settings Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: NutriColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSettingTile(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        color: NutriColors.primary,
                        onTap: () async {
                          final updated = await Navigator.push<UserProfile?>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileUpdateScreen(initial: profile),
                            ),
                          );
                          if (updated != null) {
                            setState(() => profile = updated);
                          } else {
                            loadProfile();
                          }
                        },
                      ),
                      _buildSettingTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        color: NutriColors.accent,
                        onTap: () {},
                      ),
                      _buildSettingTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'test Api',
                        color: NutriColors.success,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApiDebugScreen(),
                            ),
                          );
                        },
                      ),
                      _buildSettingTile(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        color: NutriColors.warning,
                        onTap: () {},
                      ),
                      _buildSettingTile(
                        icon: Icons.info_outline,
                        title: 'About',
                        color: NutriColors.textSecondary,
                        onTap: () {},
                      ),
                      _buildSettingTile(
                        icon: Icons.logout,
                        title: 'Logout',
                        color: NutriColors.danger,
                        isLast: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(
                                'Logout',
                                style: TextStyle(color: NutriColors.textPrimary),
                              ),
                              content: Text(
                                'Are you sure you want to logout?',
                                style: TextStyle(color: NutriColors.textSecondary),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: NutriColors.textSecondary),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _logout();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: NutriColors.danger,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: NutriColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: NutriColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: NutriColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: NutriColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: NutriColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              children: [
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                    fontSize: 14,
                    color: NutriColors.textSecondary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: NutriColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required Color color,
    bool isLast = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: NutriColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: NutriColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}