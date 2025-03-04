import 'package:flutter/material.dart';
import 'package:flutter_multi_screenshot/flutter_multi_screenshot.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

void main() {
  runApp(MaterialApp(home: ScreenshotTestApp()));
}

class ScreenshotTestApp extends StatefulWidget {
  const ScreenshotTestApp({super.key});

  @override
  _ScreenshotTestAppState createState() => _ScreenshotTestAppState();
}

class _ScreenshotTestAppState extends State<ScreenshotTestApp> {
  List<String>? screenshotPaths;
  List<Uint8List>? base64Screenshots;
  String? singleScreenshotPath;
  Uint8List? singleScreenshotBase64;

  /// Capture a single screen as a file
  Future<void> captureSingleScreenToFile() async {
    String filePath = await FlutterMultiScreenshot.captureToFile();
    print("Single Screenshot saved at: $filePath");

    setState(() {
      singleScreenshotPath = filePath;
      singleScreenshotBase64 = null;
    });
  }

  /// Capture a single screen as Base64
  Future<void> captureSingleScreenAsBase64() async {
    String base64Image = await FlutterMultiScreenshot.captureAsBase64();
    String cleanBase64 = base64Image.replaceAll('\n', '').replaceAll('\r', '');

    print("Single Screenshot Base64 Captured.");

    setState(() {
      singleScreenshotBase64 = base64Decode(cleanBase64);
      singleScreenshotPath = null;
    });
  }

  /// Capture screenshots of all screens and save to files
  Future<void> captureAllScreenshotsToFile() async {
    List<String> filePaths = await FlutterMultiScreenshot.captureAllToFile();
    print("All Screenshots saved at: $filePaths");

    setState(() {
      screenshotPaths = filePaths;
      base64Screenshots = null;
    });
  }

  /// Capture screenshots of all screens as Base64
  Future<void> captureAllScreenshotsAsBase64() async {
    List<String> base64Images = await FlutterMultiScreenshot.captureAllAsBase64();

    // ✅ Apply `.replaceAll('\n', '').replaceAll('\r', '')` to EACH Base64 string
    List<Uint8List> decodedImages = base64Images.map((base64) {
      String cleanBase64 = base64.replaceAll('\n', '').replaceAll('\r', '');
      return base64Decode(cleanBase64);
    }).toList();

    print("All Screenshots as Base64 captured.");

    setState(() {
      base64Screenshots = decodedImages;
      screenshotPaths = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Multi-Screen Screenshot Test")),
      body: SingleChildScrollView(  // ✅ Enables scrolling
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (singleScreenshotPath != null) ...[
              Text("Single Screenshot File:"),
              Text(singleScreenshotPath!, style: TextStyle(color: Colors.blue)),
              Image.file(File(singleScreenshotPath!), width: 200, height: 200, fit: BoxFit.cover),
              SizedBox(height: 10),
            ],
            if (singleScreenshotBase64 != null) ...[
              Text("Single Screenshot Base64 Preview:"),
              Image.memory(singleScreenshotBase64!, width: 200, height: 200, fit: BoxFit.cover),
              SizedBox(height: 10),
            ],
            if (screenshotPaths != null) ...[
              Text("All Screenshots as Files:"),
              Container(  // ✅ Wrap in a container with a fixed height
                height: 300,  // Adjust height as needed
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: screenshotPaths!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(screenshotPaths![index], style: TextStyle(color: Colors.blue)),
                        Image.file(File(screenshotPaths![index]), width: 200, height: 200, fit: BoxFit.cover),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ],
            if (base64Screenshots != null) ...[
              Text("All Screenshots as Base64:"),
              Container(  // ✅ Wrap in a container with a fixed height
                height: 300,  // Adjust height as needed
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: base64Screenshots!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Image.memory(
                          base64Screenshots![index],
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: captureSingleScreenToFile,
              child: Text("Capture Single Screen (File)"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: captureSingleScreenAsBase64,
              child: Text("Capture Single Screen (Base64)"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: captureAllScreenshotsToFile,
              child: Text("Capture All Screens (Files)"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: captureAllScreenshotsAsBase64,
              child: Text("Capture All Screens (Base64)"),
            ),
          ],
        ),
      ),
    );
  }
}
