import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class UploadPdfScreen extends StatefulWidget {
  const UploadPdfScreen({super.key});

  @override
  _UploadPdfScreenState createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _pdfTitle;
  String? _selectedFilePath;
  String? _selectedFileName;
  bool _isHoveringChooseFile = false;
  bool _isHoveringSubmit = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFilePath = result.files.single.path!;
        _selectedFileName = result.files.single.name;
      });
    }
  }

  void _openFile() {
    if (_selectedFilePath != null) {
      OpenFile.open(_selectedFilePath);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("PDF Title: $_pdfTitle");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF "$_pdfTitle" uploaded successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData(
        primaryColor: Colors.indigo,
        colorScheme: const ColorScheme.light(
            primary: Colors.indigo, secondary: Colors.orangeAccent),
        scaffoldBackgroundColor: Colors.blueGrey[50],
        cardColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Upload PDF",
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.indigo,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth > 600 ? screenWidth * 0.2 : 16,
                vertical: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 6,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextField(
                          "PDF Title", (value) => _pdfTitle = value),
                      const SizedBox(height: 20),

                      /// **File Picker Button with Hover Effect**
                      MouseRegion(
                        onEnter: (_) =>
                            setState(() => _isHoveringChooseFile = true),
                        onExit: (_) =>
                            setState(() => _isHoveringChooseFile = false),
                        child: ElevatedButton.icon(
                          onPressed: _pickFile,
                          icon: const Icon(Icons.attach_file,
                              color: Colors.white),
                          label: const Text("Choose PDF",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isHoveringChooseFile
                                ? Colors.indigoAccent
                                : Colors.indigo,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      if (_selectedFileName != null)
                        ListTile(
                          title: Text("Selected File: $_selectedFileName",
                              style: const TextStyle(color: Colors.black87)),
                          trailing: IconButton(
                            icon: const Icon(Icons.open_in_new,
                                color: Colors.indigo),
                            onPressed: _openFile,
                          ),
                        ),
                      const SizedBox(height: 20),

                      /// **Submit Button with Hover Effect**
                      MouseRegion(
                        onEnter: (_) =>
                            setState(() => _isHoveringSubmit = true),
                        onExit: (_) =>
                            setState(() => _isHoveringSubmit = false),
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isHoveringSubmit
                                ? Colors.deepOrange
                                : Colors.orangeAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 32),
                          ),
                          child: const Text("Upload",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) => value!.isEmpty ? "$label is required" : null,
        onSaved: (value) => onSaved(value!),
      ),
    );
  }
}
