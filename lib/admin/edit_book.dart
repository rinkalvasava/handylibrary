import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditBookPage extends StatefulWidget {
  final Map<String, dynamic> book;

  const EditBookPage({super.key, required this.book});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController authorController;
  late TextEditingController categoryController;
  late TextEditingController isbnController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.book['book_name']);
    authorController = TextEditingController(text: widget.book['author']);
    categoryController = TextEditingController(text: widget.book['category']);
    isbnController = TextEditingController(text: widget.book['isbn']);
    priceController =
        TextEditingController(text: widget.book['price'].toString());
  }

  Future<void> updateBook() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.post(
      Uri.parse('http://localhost/HL/update_book.php'),
      body: {
        'book_id': widget.book['book_id'].toString(),
        'book_name': nameController.text,
        'author': authorController.text,
        'category': categoryController.text,
        'isbn': isbnController.text,
        'price': priceController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Book updated successfully!',
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData['message'],
                  style: const TextStyle(color: Colors.black)),
              backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update book!',
                style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Book", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField(nameController, "Book Name"),
              buildTextField(authorController, "Author"),
              buildTextField(categoryController, "Category", required: false),
              buildTextField(isbnController, "ISBN", required: false),
              buildTextField(priceController, "Price (₹)",
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                  ),
                  child: const Text("Update Book",
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      {TextInputType keyboardType = TextInputType.text, bool required = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue, width: 2),
          ),
        ),
        style: const TextStyle(color: Colors.black),
        keyboardType: keyboardType,
        validator: required
            ? (value) => value!.isEmpty ? "Enter $labelText" : null
            : null,
      ),
    );
  }
}
