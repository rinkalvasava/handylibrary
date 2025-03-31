import 'package:flutter/material.dart';
import 'package:handy_library/admin/addbooks.dart';
import 'package:handy_library/admin/centers_library.dart';
import 'package:handy_library/admin/issuebooks.dart';
import 'package:handy_library/login.dart';
import 'package:handy_library/payments.dart';
import 'package:handy_library/students.dart';
import 'library_overview.dart';
import 'books_collection.dart';
import 'borrowed_books.dart';
import 'settings.dart';

class LibraryDashboard extends StatefulWidget {
  const LibraryDashboard({super.key});

  @override
  _LibraryDashboardState createState() => _LibraryDashboardState();
}

class _LibraryDashboardState extends State<LibraryDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const LibraryOverviewPage(),
    const BooksCollectionPage(),
    const BorrowedBooksPage(),
    const IssueBooksPage(),
    const StudentsPage(),
    const PaymentsPage(),
    const CenterOfLibraryPage(),
    const SettingsPage(),
    const AddBookScreen()
  ];

  final List<String> _titles = [
    "Library Overview",
    "Books Collection",
    "Borrowed Books",
    "Issue Books",
    "Students",
    "Payments",
    "Center of Library",
    "Settings",
  ];

  void _onMenuItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: 500,
            height: 300,
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.redAccent, size: 32),
                    SizedBox(width: 12),
                    Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "Are you sure you want to log out?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoginPage(), // Navigate to LoginPage
                          ),
                        );
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.grey.shade900,
            child: Column(
              children: [
                Container(
                  height: 80,
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Text(
                      "📚 Handy Library ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildMenuItem(Icons.dashboard, "Library Overview", 0),
                      _buildMenuItem(Icons.book, "Books Collection", 1),
                      _buildMenuItem(Icons.assignment, "Borrowed Books", 2),
                      _buildMenuItem(Icons.library_books, "Issue Books", 3),
                      _buildMenuItem(Icons.people, "Students", 4),
                      _buildMenuItem(Icons.payment, "Payments", 5),
                      _buildMenuItem(
                          Icons.account_balance, "Center of Library", 6),
                      Divider(color: Colors.grey.shade700),
                      _buildMenuItem(Icons.settings, "Settings", 7),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Divider(color: Colors.grey.shade700),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.white),
                      title: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      onTap: _logout,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    _titles[_selectedIndex],
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.grey.shade800,
                  elevation: 2,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: _pages[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(
        icon,
        color: _selectedIndex == index ? Colors.white : Colors.grey.shade400,
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 16, color: Colors.white)),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.grey.shade800,
      onTap: () => _onMenuItemTapped(index),
    );
  }
}
