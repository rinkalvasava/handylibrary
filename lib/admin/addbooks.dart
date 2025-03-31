import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _bookName, _author, _category, _isbn, _price;
  PlatformFile? _selectedFile;
  bool _isLoading = false;

  final List<String> _categories = ["MCA", "BCA", "MSC-IT", "BSC-IT", "PGDCA"];
  final TextEditingController _isbnController =
      TextEditingController(text: "978"); // Pre-fill "978"

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'ppt', 'png', 'jpg', 'jpeg'],
      withData: kIsWeb,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = result.files.first);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      var uri = Uri.parse("http://localhost/HL/add_book.php");
      var request = http.MultipartRequest("POST", uri);
      request.fields['book_name'] = _bookName!;
      request.fields['author'] = _author!;
      request.fields['category'] = _category!;
      request.fields['isbn'] = _isbn!;
      request.fields['price'] = _price!;

      if (_selectedFile != null) {
        if (kIsWeb) {
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            _selectedFile!.bytes!,
            filename: _selectedFile!.name,
          ));
        } else {
          request.files.add(await http.MultipartFile.fromPath(
            'file',
            _selectedFile!.path!,
          ));
        }
      }

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);
      var result = json.decode(responseBody.body);
      _showSnackBar(result['message'] ?? "Book added successfully");
    } catch (e) {
      _showErrorDialog(
          "Connection Error", "Failed to connect to the server: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.black)),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
          content: Text(message, style: const TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, Function(String?) onSave,
      {TextEditingController? controller, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true, // White background
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Enter $label";
        if (label == "ISBN" &&
            (!value.startsWith("978") || value.length != 13)) {
          return "ISBN must start with 978 and be 13 digits long";
        }
        return null;
      },
      onSaved: onSave,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Select Category",
        labelStyle: const TextStyle(color: Colors.black),
        filled: true, // White background
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
      ),
      dropdownColor:
          Colors.white, // Ensure dropdown items have a white background
      value: _category,
      items: _categories.map((String category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category,
              style: const TextStyle(color: Colors.black)), // Black text
        );
      }).toList(),
      onChanged: (value) => setState(() => _category = value),
      validator: (value) => value == null ? "Please select a category" : null,
      onSaved: (value) => _category = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add a Book", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Add a New Book",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 20),
              _buildTextField("Book Name", (value) => _bookName = value),
              const SizedBox(height: 12),
              _buildTextField("Author", (value) => _author = value),
              const SizedBox(height: 12),
              _buildTextField("ISBN", (value) => _isbn = value,
                  controller: _isbnController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField("Price", (value) => _price = value,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildCategoryDropdown(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Button color
                  foregroundColor: Colors.black, // Text color
                ),
                child: Text(
                  _selectedFile != null
                      ? "File Selected: ${_selectedFile!.name}"
                      : "Choose File",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Button color
                  foregroundColor: Colors.black, // Text color
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Submit Book"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
