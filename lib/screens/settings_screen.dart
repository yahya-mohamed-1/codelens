import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';
import '../bloc/barcode/barcode_bloc.dart';
import '../utils/constants.dart';

import '../widgets/custom_dialog.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _autoSaveScans;
  late bool _vibrateOnScan;
  late bool _beepOnScan;
  late bool _autoFlash;
  String _appVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadAppVersion();
  }

  void _loadPreferences() async {
    // Load saved preferences - in a real app, you'd use SharedPreferences
    setState(() {
      _autoSaveScans = true;
      _vibrateOnScan = true;
      _beepOnScan = true;
      _autoFlash = false;
    });
  }

  void _loadAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          _buildAppearanceSection(),
          _buildScanningSection(),
          _buildHistorySection(),
          _buildImportExportSection(),
          _buildAppInfoSection(),
          _buildSupportSection(),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return _SettingsSection(
      title: 'Appearance',
      children: [
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text('Theme'),
          subtitle: Text('System default'),
          onTap: () => _showThemeDialog(context),
        ),
        ListTile(
          leading: Icon(Icons.palette),
          title: Text('Accent Color'),
          subtitle: Text('Blue (default)'),
          onTap: () => _showColorPickerDialog(context),
        ),
      ],
    );
  }

  Widget _buildScanningSection() {
    return _SettingsSection(
      title: 'Scanning',
      children: [
        SwitchListTile(
          value: _autoSaveScans,
          onChanged: (value) => setState(() => _autoSaveScans = value),
          title: Text('Auto-save scanned codes'),
          subtitle: Text('Save codes to history automatically'),
        ),
        SwitchListTile(
          value: _vibrateOnScan,
          onChanged: (value) => setState(() => _vibrateOnScan = value),
          title: Text('Vibrate on scan'),
          subtitle: Text('Device vibrates when code is detected'),
        ),
        SwitchListTile(
          value: _beepOnScan,
          onChanged: (value) => setState(() => _beepOnScan = value),
          title: Text('Beep on scan'),
          subtitle: Text('Play sound when code is detected'),
        ),
        SwitchListTile(
          value: _autoFlash,
          onChanged: (value) => setState(() => _autoFlash = value),
          title: Text('Auto-flash'),
          subtitle: Text('Automatically enable flash in low light'),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return _SettingsSection(
      title: 'History',
      children: [
        ListTile(
          leading: Icon(Icons.delete_forever),
          title: Text('Clear history'),
          subtitle: Text('Remove all scanned and generated codes'),
          onTap: () => _showClearHistoryDialog(context),
        ),
        ListTile(
          leading: Icon(Icons.auto_delete),
          title: Text('Auto-delete old entries'),
          subtitle: Text('Delete codes older than 30 days'),
          onTap: () => _showAutoDeleteDialog(context),
        ),
      ],
    );
  }

  Widget _buildImportExportSection() {
    return _SettingsSection(
      title: 'Import & Export',
      children: [
        ListTile(
          leading: Icon(Icons.import_export),
          title: Text('Export history'),
          subtitle: Text('Save codes as CSV or JSON file'),
          onTap: () => _exportHistory(context),
        ),
        ListTile(
          leading: Icon(Icons.file_upload),
          title: Text('Import codes'),
          subtitle: Text('Import codes from file'),
          onTap: () => _importCodes(context),
        ),
      ],
    );
  }

  Widget _buildAppInfoSection() {
    return _SettingsSection(
      title: 'About',
      children: [
        ListTile(
          leading: Icon(Icons.info),
          title: Text('Version'),
          subtitle: Text(_appVersion),
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip),
          title: Text('Privacy Policy'),
          onTap: () => _launchUrl(AppConstants.privacyPolicyUrl),
        ),
        ListTile(
          leading: Icon(Icons.star),
          title: Text('Rate this app'),
          onTap: _rateApp,
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _SettingsSection(
      title: 'Support',
      children: [
        ListTile(
          leading: Icon(Icons.feedback),
          title: Text('Send feedback'),
          onTap: () => _sendFeedback(context),
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Help & instructions'),
          onTap: () => _showHelp(context),
        ),
      ],
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => CustomDialog(
            title: 'Select Theme',
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Light'),
                  leading: Icon(Icons.light_mode),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  title: Text('Dark'),
                  leading: Icon(Icons.dark_mode),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  title: Text('System default'),
                  leading: Icon(Icons.phone_android),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    // This would show a color picker in a real implementation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Color picker would appear here')));
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => CustomDialog(
            title: 'Clear History',
            content: Text(
              'Are you sure you want to delete all history? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<BarcodeBloc>().add(ClearAllHistory());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('History cleared successfully')),
                  );
                },
                child: Text('Clear', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _showAutoDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => CustomDialog(
            title: 'Auto-delete Settings',
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Never'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  title: Text('After 7 days'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  title: Text('After 30 days'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  title: Text('After 90 days'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  void _exportHistory(BuildContext context) async {
    try {
      // In a real app, this would generate and share a file
      final history =
          context.read<BarcodeBloc>().state is BarcodeHistoryLoaded
              ? (context.read<BarcodeBloc>().state as BarcodeHistoryLoaded)
                  .history
              : [];

      if (history.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No history to export')));
        return;
      }

      // Create a simple text representation (in real app, create CSV/JSON)
      final exportText = history
          .map(
            (item) =>
                '${item.timestamp.toIso8601String()},${item.type},${item.data}${item.note != null ? ",${item.note}" : ""}',
          )
          .join('\n');

      // Share the text (in real app, this would be a file)
      await Share.share(exportText, subject: 'Barcode History Export');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('History exported successfully')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to export history: $e')));
    }
  }

  void _importCodes(BuildContext context) {
    // This would open a file picker and process the imported file
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Import functionality would open a file picker')),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch URL')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error launching URL: $e')));
    }
  }

  void _rateApp() {
    // Platform-specific rating implementation
    final appId = Platform.isAndroid ? 'com.example.barcodeapp' : 'id123456789';
    final url =
        Platform.isAndroid
            ? 'market://details?id=$appId'
            : 'itms-apps://itunes.apple.com/app/id$appId';

    _launchUrl(url);
  }

  void _sendFeedback(BuildContext context) {
    final email = 'support@barcodeapp.com';
    final subject = 'Barcode App Feedback';
    final body = 'App Version: $_appVersion\n\n';

    _launchUrl('mailto:$email?subject=$subject&body=$body');
  }

  void _showHelp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: Text('Help & Instructions')),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to use the Barcode Scanner App',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 16),
                    _buildHelpItem(
                      context,
                      'Scanning Codes',
                      'Point your camera at a barcode or QR code. The app will automatically detect and decode it.',
                    ),
                    _buildHelpItem(
                      context,
                      'Generating Codes',
                      'Go to the Generate tab, enter your text or URL, select the code type, and tap Generate.',
                    ),
                    _buildHelpItem(
                      context,
                      'Importing Codes',
                      'Use the import option to scan codes from images in your gallery.',
                    ),
                    _buildHelpItem(
                      context,
                      'Managing History',
                      'View your scan history, export it, or clear it from the History tab or Settings.',
                    ),
                    _buildHelpItem(
                      context,
                      'Barcode Types',
                      'Learn about different barcode formats supported by the app:\n\n'
                      '• QR Code: 2D matrix code that can store text, URLs, contact info, and more. Widely used for mobile payments, website links, and sharing information.\n\n'
                      '• Code 128: 1D linear barcode supporting alphanumeric characters. Commonly used for shipping labels, inventory management, and product identification.\n\n'
                      '• Code 39: 1D barcode with alphanumeric support. Simpler format used in various industries for labeling and identification.\n\n'
                      '• EAN-8: 8-digit 1D barcode for small retail products. Compact version of EAN-13 for items with limited space.\n\n'
                      '• EAN-13: 13-digit 1D barcode standard for retail products worldwide. Used on most consumer goods for checkout and inventory.\n\n'
                      '• UPC-A: 12-digit 1D barcode primarily used in North America for retail products. Similar to EAN-13 but with different digit allocation.\n\n'
                      '• Data Matrix: 2D matrix code that can store large amounts of data in a small space. Used in manufacturing, healthcare, and electronics for tracking and identification.',
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildHelpItem(BuildContext context, String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(children: children),
        ),
      ],
    );
  }
}
