import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../UI/splashes/app_colors.dart';
import '../../UI/widgets/bottom_control_panel.dart';
import '../Auth2/auth_service.dart';
import '../Auth2/login_page.dart';
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
    setState(() => loading = true);
    try {
      final api = Provider.of<ProfileApi>(context, listen: false);
      final p = await api.getProfile();
      setState(() => profile = p);
    } catch (e) {
      setState(() => error = 'Failed to load profile');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  // LOGOUT LOGIC — Clears auth & goes back to Welcome/Login
  Future<void> _logout() async {
    final api = Provider.of<ProfileApi>(context, listen: false);
    // await api.logout(); // This should clear token, user data, etc.
    // keshav this is the current logic that i comment this like ok.

    if (!mounted) return;

    // Option 1: Go to Welcome screen and remove all previous routes
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/welcome', // or '/login' if you prefer
          (route) => false,
    );

    // Option 2: If you want to fully exit app (not recommended on iOS)
    // SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NutriColors.background,
      appBar: AppBar(
        backgroundColor: NutriColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
          : profile == null
          ? const Center(child: Text('No profile data'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar Circle
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: profile!.photoUrl != null
                  ? NetworkImage(profile!.photoUrl!)
                  : null,
              child: profile!.photoUrl == null
                  ? const Icon(Icons.person, size: 70, color: Colors.grey)
                  : null,
            ),

            const SizedBox(height: 16),

            // Name & Email
            Text(
              profile!.fullName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: NutriColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile!.email,
              style: TextStyle(fontSize: 16, color: NutriColors.textSecondary),
            ),

            const SizedBox(height: 32),

            // My Info Button
            _buildListTile(
              icon: Icons.person_outline,
              title: 'Update Info',
              color: NutriColors.success,
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
            // need to create a seperate page to show the details or info.
            // Calorie Intake (Example Stat)
            _buildStatTile(
              title: 'Calorie Intake Today',
              value: '1,840 Cal',
              target: '2,200 Cal goal',
              color: NutriColors.accent,
            ),

            const Divider(height: 40),

            // Settings List
            _buildListTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark theme',
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (val) {
                  // Add your theme provider logic here later
                },
                activeColor: NutriColors.accent,
              ),
            ),

            _buildListTile(icon: Icons.mail_outline, title: 'Contact us'),
            _buildListTile(icon: Icons.info_outline, title: 'About app'),
            _buildListTile(icon: Icons.settings_outlined, title: 'Settings'),

            const SizedBox(height: 20),

            // Logout Button (Red)
            _buildListTile(
              icon: Icons.logout,
              title: 'Logout',
              color: NutriColors.danger,
              onTap: () => showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        final authService = Provider.of<AuthService>(context, listen: false);
                        await authService.logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen2()),
                        );
                      },
                      child: const Text("Logout"),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomControlPanel(currentIndex: 3),
    );
  }

  // Reusable List Tile
  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: (color ?? NutriColors.primary).withOpacity(0.1),
        child: Icon(icon, color: color ?? NutriColors.primary, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // Special Stat Tile
  Widget _buildStatTile({
    required String title,
    required String value,
    required String target,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(Icons.local_fire_department, color: color)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: NutriColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
              Text(target, style: TextStyle(fontSize: 12, color: NutriColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}