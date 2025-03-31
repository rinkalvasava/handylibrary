import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: const Text("Admin Settings"),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // ignore: unused_local_variable
          bool isWideScreen = constraints.maxWidth > 600;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.book,
                        title: "Manage Books",
                        subtitle:
                            "Add, edit, or remove books from the digital library",
                      ),
                      _buildSettingsTile(
                        icon: Icons.group,
                        title: "Manage Users",
                        subtitle:
                            "View and control user access and permissions",
                      ),
                      _buildSettingsTile(
                        icon: Icons.settings,
                        title: "Library Settings",
                        subtitle:
                            "Configure library rules, policies, and system settings",
                      ),
                      _buildSettingsTile(
                        icon: Icons.security,
                        title: "Security & Permissions",
                        subtitle: "Manage security settings and user roles",
                      ),
                      _buildSettingsTile(
                        icon: Icons.info,
                        title: "About Digital Library",
                        subtitle: "View system information and version details",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black), // Ensuring icon visibility
          title: Text(title, style: const TextStyle(color: Colors.black)),
          subtitle:
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
        ),
        const Divider(),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SettingsPage(),
  ));
}
