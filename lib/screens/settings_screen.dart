import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showThemeDialog(
    BuildContext context,
    ThemeMode currentMode,
    void Function(ThemeMode) onChanged,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Select Theme'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: Text('Light'),
                  value: ThemeMode.light,
                  groupValue: currentMode,
                  onChanged: (value) {
                    onChanged(value!);
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text('Dark'),
                  value: ThemeMode.dark,
                  groupValue: currentMode,
                  onChanged: (value) {
                    onChanged(value!);
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text('System'),
                  value: ThemeMode.system,
                  groupValue: currentMode,
                  onChanged: (value) {
                    onChanged(value!);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeMode = themeProvider.themeMode;
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.color_lens),
                  title: Text('Theme'),
                  subtitle: Text(
                    themeMode == ThemeMode.light
                        ? 'Light'
                        : themeMode == ThemeMode.dark
                        ? 'Dark'
                        : 'System',
                  ),
                  onTap:
                      () => _showThemeDialog(
                        context,
                        themeMode,
                        (mode) => themeProvider.setThemeMode(mode),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
