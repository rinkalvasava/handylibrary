import 'package:flutter/material.dart';
import 'package:handy_library/admin/edit_book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BooksCollectionPage extends StatefulWidget {
  const BooksCollectionPage({super.key});

  @override
  _BooksCollectionPageState createState() => _BooksCollectionPageState();
}

class _BooksCollectionPageState extends State<BooksCollectionPage> {
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final response = await http.get(Uri.parse('http://localhost/HL/books.php'));

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData["success"] == true && responseData["books"] is List) {
          setState(() {
            books = List<Map<String, dynamic>>.from(responseData["books"]);
          });
        } else {
          print("No books found.");
        }
      } catch (e) {
        print("JSON Decode Error: $e");
      }
    } else {
      print("Error: ${response.reasonPhrase}");
    }
  }

  Future<void> deleteBook(String bookId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this book?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (!confirmDelete) return;

    final response = await http.post(
      Uri.parse('http://localhost/HL/delete_book.php'),
      body: {'book_id': bookId},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData["success"] == true) {
        setState(() {
          books.removeWhere((book) => book['book_id'].toString() == bookId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData["message"]),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData["message"]),
              backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to connect to server"),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Books Collection"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: books.isEmpty
            ? const Center(
                child: Text(
                  "No books available.",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: DataTable(
                              columnSpacing: 20,
                              headingRowColor: WidgetStateColor.resolveWith(
                                  (states) =>
                                      Colors.blueAccent.withOpacity(0.2)),
                              border:
                                  TableBorder.all(color: Colors.grey.shade300),
                              columns: const [
                                DataColumn(
                                    label: Text('ID',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                                DataColumn(
                                    label: Text('Book Name',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                                DataColumn(
                                    label: Text('Author',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                                DataColumn(
                                    label: Text('Category',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                                DataColumn(
                                    label: Text('ISBN',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                                DataColumn(
                                    label: Text('Price',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                                DataColumn(
                                    label: Text('Actions',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                              ],
                              rows: books
                                  .map((book) => DataRow(
                                        cells: [
                                          DataCell(Text(
                                            book['book_id']?.toString() ?? '',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )),
                                          DataCell(Text(
                                            book['book_name'] ?? '',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )),
                                          DataCell(Text(
                                            book['author'] ?? '',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )),
                                          DataCell(Text(
                                            book['category'] ?? '',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )),
                                          DataCell(Text(
                                            book['isbn'] ?? '',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )),
                                          DataCell(Text(
                                            '₹${book['price']}',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )),
                                          DataCell(
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.blue),
                                                    onPressed: () async {
                                                      bool? result =
                                                          await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditBookPage(
                                                                  book: book),
                                                        ),
                                                      );
                                                      if (result == true) {
                                                        fetchBooks(); // Refresh list after editing
                                                      }
                                                    },
                                                    child: const Text("Edit",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.red),
                                                    onPressed: () => deleteBook(
                                                        book['book_id']
                                                            .toString()),
                                                    child: const Text("Delete",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))
                                  .toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
