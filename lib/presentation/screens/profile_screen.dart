import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../providers/health_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glow = AppConstants.primary.withValues(alpha: 0.6);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF0A141A), Color(0xFF0E1B23), Color(0xFF122632)]
                : const [Color(0xFFF7F7FF), Color(0xFFEFF3FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  title: 'Profile',
                  subtitle: 'Your health snapshot',
                ),
                const SizedBox(height: 8),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'profile_avatar',
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: AppConstants.primary.withValues(alpha: 0.2),
                          child: const Icon(Icons.person, color: AppConstants.primary, size: 28),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name.isEmpty ? 'FitTrack User' : user.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    shadows: [
                                      Shadow(
                                        color: glow,
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.fitnessGoal,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _openEditProfile(context, ref, user),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionHeader(title: 'Stats'),
                const SizedBox(height: 12),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ProfileStat(label: 'Weight', value: '${user.weight} ${user.units}'),
                      _ProfileStat(label: 'Height', value: '${user.height} cm'),
                      _ProfileStat(label: 'Age', value: '${user.age}'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionHeader(title: 'Settings'),
                const SizedBox(height: 12),
                GlassCard(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      SwitchListTile.adaptive(
                        value: themeMode == ThemeMode.dark,
                        onChanged: (value) =>
                            ref.read(themeModeProvider.notifier).toggle(value),
                        title: const Text('Dark Mode'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Units'),
                        subtitle: Text(user.units.toUpperCase()),
                        trailing: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'kg', label: Text('KG')),
                            ButtonSegment(value: 'lbs', label: Text('LBS')),
                          ],
                          selected: {user.units},
                          onSelectionChanged: (value) {
                            final updated = user.copyWith(units: value.first);
                            ref.read(userProvider.notifier).updateUser(updated);
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      SwitchListTile.adaptive(
                        value: true,
                        onChanged: (_) {},
                        title: const Text('Notifications'),
                        subtitle: const Text('Workout and hydration reminders'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Sync health data'),
                        subtitle: const Text('Google Fit / Apple Health'),
                        trailing: FilledButton(
                          onPressed: () => ref.read(healthProvider.notifier).load(),
                          child: const Text('Sync'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openEditProfile(BuildContext context, WidgetRef ref, UserModel user) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditProfileSheet(user: user),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final glow = AppConstants.primary.withValues(alpha: 0.6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppConstants.primary,
                shadows: [
                  Shadow(
                    color: glow,
                    blurRadius: 12,
                  ),
                ],
              ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _EditProfileSheet extends ConsumerStatefulWidget {
  const _EditProfileSheet({required this.user});

  final UserModel user;

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _ageController;
  late final TextEditingController _goalController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _weightController = TextEditingController(text: widget.user.weight.toString());
    _heightController = TextEditingController(text: widget.user.height.toString());
    _ageController = TextEditingController(text: widget.user.age.toString());
    _goalController = TextEditingController(text: widget.user.fitnessGoal);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: GlassCard(
        borderRadius: 28,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profile',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(labelText: 'Fitness Goal'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    final updated = widget.user.copyWith(
                      name: _nameController.text,
                      weight: double.tryParse(_weightController.text) ?? widget.user.weight,
                      height: double.tryParse(_heightController.text) ?? widget.user.height,
                      age: int.tryParse(_ageController.text) ?? widget.user.age,
                      fitnessGoal: _goalController.text,
                    );
                    ref.read(userProvider.notifier).updateUser(updated);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
