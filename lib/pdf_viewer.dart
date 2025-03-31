import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PDFViewerScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: FutureBuilder<bool>(
        future: File(pdfPath).exists(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!) {
            return const Center(child: Text("PDF file not found"));
          }
          return PDFView(filePath: pdfPath);
        },
      ),
    );
  }
}
