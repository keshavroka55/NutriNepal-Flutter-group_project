import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../UI/splashes/app_colors.dart';
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
  String goal = 'maintain_weight';
  String activityLevel = 'light';

  bool saving = false;
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    userProfile = init;

    nameCtrl = TextEditingController(text: init?.username ?? '');
    emailCtrl = TextEditingController(text: init?.email ?? '');
    gender = init?.gender ?? 'prefer_not_to_say';
    ageCtrl = TextEditingController(text: init?.age?.toString() ?? '');
    heightCtrl = TextEditingController(text: init?.height?.toString() ?? '');
    weightCtrl = TextEditingController(text: init?.weight?.toString() ?? '');
    goal = init?.goal ?? 'maintain_weight';
    activityLevel = init?.activityLevel ?? 'light';
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

    final profile = UserProfile(
      username: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      gender: gender,
      age: ageCtrl.text.isEmpty ? null : int.tryParse(ageCtrl.text),
      height: heightCtrl.text.isEmpty ? null : double.tryParse(heightCtrl.text),
      weight: weightCtrl.text.isEmpty ? null : double.tryParse(weightCtrl.text),
      goal: goal,
      activityLevel: activityLevel,
    );

    try {
      UserProfile saved;

      if (widget.initial == null) {
        saved = await api.createProfile(profile);
      } else {
        saved = await api.updateProfile(profile);
      }

      final refreshed = await api.getProfile();

      if (mounted) {
        setState(() {
          userProfile = refreshed;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.initial == null
                  ? 'Profile created successfully!'
                  : 'Profile updated successfully!',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: NutriColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        Navigator.pop(context, refreshed);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Failed to save profile',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: NutriColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCreating = widget.initial == null;

    return Scaffold(
      backgroundColor: NutriColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: NutriColors.textPrimary,
        elevation: 0,
        title: Text(
          isCreating ? 'Complete Your Profile' : 'Edit Profile',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: NutriColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCreating ? Icons.person_add : Icons.edit,
                      color: NutriColors.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCreating ? 'Welcome!' : 'Update Your Info',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: NutriColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isCreating
                                ? 'Complete your profile to get personalized recommendations'
                                : 'Keep your information up to date',
                            style: TextStyle(
                              fontSize: 14,
                              color: NutriColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Personal Info Section
                    _buildSectionHeader(
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: nameCtrl,
                      label: 'Full Name',
                      icon: Icons.person,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: emailCtrl,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      value: gender,
                      label: 'Gender',
                      icon: Icons.transgender,
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Male')),
                        DropdownMenuItem(value: 'female', child: Text('Female')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                        DropdownMenuItem(value: 'prefer_not_to_say', child: Text('Prefer not to say')),
                      ],
                      onChanged: (v) => setState(() => gender = v ?? 'prefer_not_to_say'),
                    ),

                    // Health Metrics Section
                    const SizedBox(height: 32),
                    _buildSectionHeader(
                      icon: Icons.monitor_heart_outlined,
                      title: 'Health Metrics',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: ageCtrl,
                            label: 'Age',
                            icon: Icons.cake_outlined,
                            keyboardType: TextInputType.number,
                            suffixText: 'years',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: weightCtrl,
                            label: 'Weight',
                            icon: Icons.scale_outlined,
                            keyboardType: TextInputType.number,
                            suffixText: 'kg',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: heightCtrl,
                      label: 'Height',
                      icon: Icons.straighten_outlined,
                      keyboardType: TextInputType.number,
                      suffixText: 'cm',
                    ),

                    // Goals Section
                    const SizedBox(height: 32),
                    _buildSectionHeader(
                      icon: Icons.flag_outlined,
                      title: 'Fitness Goals',
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      value: goal,
                      label: 'Primary Goal',
                      icon: Icons.tablet,
                      items: const [
                        DropdownMenuItem(value: 'lose_weight', child: Text('Lose Weight')),
                        DropdownMenuItem(value: 'gain_weight', child: Text('Gain Weight')),
                        DropdownMenuItem(value: 'maintain_weight', child: Text('Maintain Weight')),
                        DropdownMenuItem(value: 'build_muscle', child: Text('Build Muscle')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (v) => setState(() => goal = v ?? 'other'),
                    ),

                    // Activity Level Section
                    const SizedBox(height: 32),
                    _buildSectionHeader(
                      icon: Icons.directions_run_outlined,
                      title: 'Activity Level',
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      value: activityLevel,
                      label: 'Daily Activity',
                      icon: Icons.fitness_center,
                      items: const [
                        DropdownMenuItem(value: 'sedentary', child: Text('Sedentary (Little or no exercise)')),
                        DropdownMenuItem(value: 'light', child: Text('Light Activity (1-3 days/week)')),
                        DropdownMenuItem(value: 'moderate', child: Text('Moderate Activity (3-5 days/week)')),
                        DropdownMenuItem(value: 'active', child: Text('Active (6-7 days/week)')),
                        DropdownMenuItem(value: 'very_active', child: Text('Very Active (Professional athlete)')),
                      ],
                      onChanged: (v) => setState(() => activityLevel = v ?? 'light'),
                    ),

                    // Save Button
                    const SizedBox(height: 40),
                    saving
                        ? Center(
                      child: CircularProgressIndicator(
                        color: NutriColors.primary,
                      ),
                    )
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NutriColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isCreating ? 'Create Profile' : 'Save Changes',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!isCreating)
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: NutriColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, color: NutriColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: NutriColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? suffixText,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
        style: TextStyle(color: NutriColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: NutriColors.textSecondary),
          prefixIcon: Icon(icon, color: NutriColors.textSecondary),
          suffixText: suffixText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: NutriColors.primary),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        style: TextStyle(color: NutriColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: NutriColors.textSecondary),
          prefixIcon: Icon(icon, color: NutriColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: NutriColors.primary),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        icon: Icon(Icons.arrow_drop_down, color: NutriColors.textSecondary),
      ),
    );
  }
}