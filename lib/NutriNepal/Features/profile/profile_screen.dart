import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../UI/widgets/bottom_control_panel.dart';
import 'profile_api.dart';
import 'profile_model.dart';
import 'profile_update_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      setState(() {
        profile = p;
      });
    } catch (e, st) {
      debugPrint('getProfile error: $e\n$st');
      setState(() {
        error = 'Failed to load profile';
      });
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : profile == null
          ? const Center(child: Text('No profile yet'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Name: ${profile!.fullName}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Email: ${profile!.email}'),
            const SizedBox(height: 8),
            Text('Gender: ${profile!.gender}'),
            const SizedBox(height: 8),
            Text('Age: ${profile!.age ?? '-'}'),
            const SizedBox(height: 8),
            Text('Height: ${profile!.height ?? '-'} cm'),
            const SizedBox(height: 8),
            Text('Weight: ${profile!.weight ?? '-'} kg'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final updated = await Navigator.push<UserProfile?>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileUpdateScreen(initial: profile),
                  ),
                );
                // Refresh profile after return
                if (updated != null) {
                  setState(() => profile = updated);
                } else {
                  await loadProfile();
                }
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomControlPanel(currentIndex: 3),
    );
  }
}
