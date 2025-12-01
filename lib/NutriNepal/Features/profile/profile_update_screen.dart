import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_api.dart';
import 'profile_model.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final UserProfile? initial;
  const ProfileUpdateScreen({super.key, this.initial});

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  String gender = 'prefer_not_to_say';
  late TextEditingController ageCtrl;
  late TextEditingController heightCtrl;
  late TextEditingController weightCtrl;

  bool saving = false;
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    userProfile = init;

    nameCtrl = TextEditingController(text: init?.fullName ?? '');
    emailCtrl = TextEditingController(text: init?.email ?? '');
    gender = init?.gender ?? 'prefer_not_to_say';
    ageCtrl = TextEditingController(text: init?.age?.toString() ?? '');
    heightCtrl = TextEditingController(text: init?.height?.toString() ?? '');
    weightCtrl = TextEditingController(text: init?.weight?.toString() ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    ageCtrl.dispose();
    heightCtrl.dispose();
    weightCtrl.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => saving = true);

    final api = Provider.of<ProfileApi>(context, listen: false);

    // Build updated profile payload
    final profile = UserProfile(
      userId: userProfile?.userId ?? '',
      fullName: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      gender: gender,
      age: ageCtrl.text.isEmpty ? null : int.tryParse(ageCtrl.text),
      height: heightCtrl.text.isEmpty ? null : double.tryParse(heightCtrl.text),
      weight: weightCtrl.text.isEmpty ? null : double.tryParse(weightCtrl.text),
      goal: userProfile?.goal ?? "maintain",
      activityLevel: userProfile?.activityLevel ?? "light",
    );

    try {
      // 1. Call update API
      await api.upsertProfile(profile);

      // 2. Re-fetch updated profile
      final refreshed = await api.getProfile();

      // 3. Update UI state
      if (mounted) {
        setState(() {
          userProfile = refreshed;
          nameCtrl.text = refreshed?.fullName ?? '';
          emailCtrl.text = refreshed?.email ?? '';
          gender = refreshed?.gender ?? 'prefer_not_to_say';
          ageCtrl.text = refreshed?.age?.toString() ?? '';
          heightCtrl.text = refreshed?.height?.toString() ?? '';
          weightCtrl.text = refreshed?.weight?.toString() ?? '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e, st) {
      debugPrint('upsertProfile error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile')),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? 'Create Profile' : 'Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: gender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                  DropdownMenuItem(value: 'prefer_not_to_say', child: Text('Prefer not to say')),
                ],
                onChanged: (v) => setState(() => gender = v ?? 'prefer_not_to_say'),
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: ageCtrl,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: heightCtrl,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: weightCtrl,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              saving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
