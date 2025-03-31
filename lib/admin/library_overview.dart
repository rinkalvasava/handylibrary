import 'package:flutter/material.dart';
import 'package:handy_library/admin/uploadpdf.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: unused_import
import 'addbooks.dart';

class LibraryOverviewPage extends StatefulWidget {
  const LibraryOverviewPage({super.key});

  @override
  _LibraryOverviewPageState createState() => _LibraryOverviewPageState();
}

class _LibraryOverviewPageState extends State<LibraryOverviewPage> {
  List<Map<String, String>> universities = [];
  List<Map<String, String>> colleges = [];
  bool isLoadingUniversities = true;
  bool isLoadingColleges = true;
  bool showUniversitiesList = false;
  bool showCollegesList = false;

  // Stores hover state for each card
  Map<String, bool> hoverStates = {};

  @override
  void initState() {
    super.initState();
    fetchUniversities();
    fetchColleges();
  }

  Future<void> fetchUniversities() async {
    final response =
        await http.get(Uri.parse("http://localhost/HL/get_universities.php"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        universities = data.map((item) {
          return {
            "name": item["university_name"]?.toString() ?? "Unknown",
            "email": item["email"]?.toString() ?? "N/A",
            "contact": item["contact_no"]?.toString() ?? "N/A",
            "username": item["username"]?.toString() ?? "N/A",
            "location": item["location"]?.toString() ?? "N/A",
          };
        }).toList();
        isLoadingUniversities = false;
      });
    } else {
      setState(() => isLoadingUniversities = false);
    }
  }

  Future<void> fetchColleges() async {
    final response =
        await http.get(Uri.parse("http://localhost/HL/get_colleges.php"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        colleges = data.map((item) {
          return {
            "name": item["college_name"]?.toString() ?? "Unknown",
            "email": item["email"]?.toString() ?? "N/A",
            "contact": item["contact_no"]?.toString() ?? "N/A",
            "username": item["username"]?.toString() ?? "N/A",
            "location": item["location"]?.toString() ?? "N/A",
          };
        }).toList();
        isLoadingColleges = false;
      });
    } else {
      setState(() => isLoadingColleges = false);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false, // Disables back navigation
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            showUniversitiesList
                ? "Universities List"
                : showCollegesList
                    ? "Colleges List"
                    : "Library Overview",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: null, // Removes back arrow
        ),
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: showUniversitiesList
                ? _buildDataTable(universities, isLoadingUniversities)
                : showCollegesList
                    ? _buildDataTable(colleges, isLoadingColleges)
                    : _buildLibraryOverview(),
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable(List<Map<String, String>> data, bool isLoading) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (data.isEmpty) return const Center(child: Text("No data available."));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
      children: [
        const SizedBox(height: 20), // Add spacing from the top
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1500, // Increased table width
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 40, // Increased spacing between columns
                  dataRowHeight: 60, // Increased row height
                  border: TableBorder.all(color: Colors.black, width: 2),
                  columns: const [
                    DataColumn(
                        label: Text("Name",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text("Email",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text("Contact",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text("Username",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text("Location",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                  ],
                  rows: data
                      .map((item) => DataRow(
                            cells: item.values
                                .map((e) => DataCell(
                                      Text(e,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                    ))
                                .toList(),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryOverview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          spacing: 30,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            _buildCard("Upload Book", Icons.book, Colors.yellow, onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBookScreen()),
              );
            }),
            _buildCard("Upload PPT", Icons.slideshow, Colors.yellow),
            _buildCard("Upload PDF", Icons.picture_as_pdf, Colors.yellow,
                onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UploadPdfScreen()),
              );
            }),
          ],
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 30,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            _buildCard("Total Universities: ${universities.length}",
                Icons.school, Colors.green, onTap: () {
              setState(() {
                showUniversitiesList = true; // Show university table
              });
            }),
            _buildCard("Total Colleges: ${colleges.length}", Icons.business,
                Colors.green, onTap: () {
              setState(() {
                showCollegesList = true; // Show college table
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(String title, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return MouseRegion(
      onEnter: (_) => setState(() => hoverStates[title] = true),
      onExit: (_) => setState(() => hoverStates[title] = false),
      child: GestureDetector(
        onTap: onTap, // Handles navigation on tap
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: hoverStates[title] == true ? 230 : 220, // Increased size
          width: hoverStates[title] == true ? 410 : 400, // Increased size
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: hoverStates[title] == true
                ? color.withOpacity(0.85)
                : color.withOpacity(0.7),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: hoverStates[title] == true ? 3 : 2,
                blurRadius: hoverStates[title] == true ? 12 : 10,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: Colors.black), // Slightly larger icon
              const SizedBox(height: 15), // More spacing
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, // Slightly larger text
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
