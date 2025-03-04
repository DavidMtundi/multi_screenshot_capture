import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_multi_screenshot/flutter_multi_screenshot.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: ScreenshotPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class ScreenshotPage extends StatefulWidget {
  const ScreenshotPage({super.key});

  @override
  _ScreenshotPageState createState() => _ScreenshotPageState();
}

class _ScreenshotPageState extends State<ScreenshotPage> {
  String? screenshotPath;
  Uint8List? screenshotBytes;

  /// Capture screenshot and save as a file
  Future<void> captureScreenshotToFile() async {
    try {
    
      String filePath = await FlutterMultiScreenshot.captureToFile();
      print("Screenshot saved at: $filePath");

      setState(() {
        screenshotPath = filePath;
        screenshotBytes = null; // Reset base64 display
      });
    } catch (e) {
      print("Error capturing screenshot: $e");
    }
  }

  /// Capture screenshot and display it from Base64
  Future<void> captureScreenshotAsBase64() async {
    String filePath = "";
    try {
      String base64Image = await FlutterMultiScreenshot.captureAsBase64();
      print("Screenshot captured as base64: $base64Image");

      if (base64Image != null) {
        // Convert base64 to an image and display it
        String cleanBase64 = base64Image.replaceAll('\n', '').replaceAll('\r', '');
        Uint8List bytes = base64Decode(cleanBase64);

        // Get temp directory path
        Directory tempDir = await getTemporaryDirectory();
        filePath = '${tempDir.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';

        // Save bytes to file
        File file = File(filePath);
        await file.writeAsBytes(bytes);
      
        print("Screenshot saved at: $filePath");
        setState(() {
          screenshotPath = filePath;
          screenshotBytes = bytes;
        });
      }
    } catch (e) {
      print("Error capturing screenshot as base64: $e");
    }
  }

  /// Save Base64 screenshot to a file
  Future<void> saveBase64ToFile() async {
    if (screenshotBytes == null) return;

    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';

    File file = File(filePath);
    await file.writeAsBytes(screenshotBytes!);

    print("Base64 Screenshot saved at: $filePath");

    setState(() {
      screenshotPath = filePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Screenshot Plugin Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (screenshotPath != null)
              Column(
                children: [
                  Text("Screenshot saved at:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(screenshotPath!, style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
                  SizedBox(height: 10),
                  Image.file(File(screenshotPath!), width: 200, height: 200, fit: BoxFit.cover),
                ],
              ),
            if (screenshotBytes != null)
              Column(
                children: [
                  Text("Base64 Screenshot Preview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Image.memory(screenshotBytes!, width: 200, height: 200, fit: BoxFit.cover),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: saveBase64ToFile,
                    child: Text("Save Base64 to File"),
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: captureScreenshotToFile,
              child: Text("Capture Screenshot to File"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: captureScreenshotAsBase64,
              child: Text("Capture Screenshot as Base64"),
            ),
          ],
        ),
      ),
    );
  }
}
