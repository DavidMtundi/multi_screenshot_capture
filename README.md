# **flutter_multi_screenshot**
A **Flutter plugin** for capturing screenshots on **Linux**. This plugin supports capturing **single or multiple screens** and saving them as **files** or **Base64-encoded strings**, making it easy to integrate screenshot functionality into Flutter desktop apps.

## **📌 Features**
- ✅ Capture **a single screen** and **save it as a file**.
- ✅ Capture **a single screen** and **return a Base64 string**.
- ✅ Capture **all connected screens** and **save them as files**.
- ✅ Capture **all connected screens** and **return multiple Base64 strings**.
- ✅ Automatically selects the **best available screenshot tool** on Linux (`scrot`, `gnome-screenshot`, `flameshot`, etc.).
- ✅ Works on **X11** (Wayland may need additional configuration).

---

## **🚀 Installation**
### **1️⃣ Add Dependency**
Add this plugin to your **pubspec.yaml**:
```yaml
dependencies:
  flutter_multi_screenshot: ^1.0.2
```

### **2️⃣ Install Packages**
Run:
```sh
flutter pub get
```

---

## **🖼️ Usage**
### **Import the Plugin**
```dart
import 'package:flutter_multi_screenshot/flutter_multi_screenshot.dart';
```

### **📸 Capture a Single Screen as a File**
```dart
String filePath = await FlutterMultiScreenshot.captureToFile();
print("Screenshot saved at: $filePath");
```

### **📸 Capture a Single Screen as Base64**
```dart
String base64Image = await FlutterMultiScreenshot.captureAsBase64();
String cleanBase64 = base64Image.replaceAll('\n', '').replaceAll('\r', '');
Uint8List imageBytes = base64Decode(cleanBase64);
print("Screenshot captured as Base64.");
```

### **📸 Capture All Screens as Files**
```dart
List<String> filePaths = await FlutterMultiScreenshot.captureAllToFile();
print("Screenshots saved at: $filePaths");
```

### **📸 Capture All Screens as Base64**
```dart
List<String> base64Images = await FlutterMultiScreenshot.captureAllAsBase64();
List<Uint8List> decodedImages = base64Images.map((base64) {
  String cleanBase64 = base64.replaceAll('\n', '').replaceAll('\r', '');
  return base64Decode(cleanBase64);
}).toList();
print("All Screenshots captured as Base64.");
```

---

## **🎯 Example App**
Here’s a **full example** with buttons to **capture and display screenshots**:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_multi_screenshot/flutter_multi_screenshot.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

void main() {
  runApp(MaterialApp(home: ScreenshotTestApp()));
}

class ScreenshotTestApp extends StatefulWidget {
  @override
  _ScreenshotTestAppState createState() => _ScreenshotTestAppState();
}

class _ScreenshotTestAppState extends State<ScreenshotTestApp> {
  List<String>? screenshotPaths;
  List<Uint8List>? base64Screenshots;
  String? singleScreenshotPath;
  Uint8List? singleScreenshotBase64;

  Future<void> captureSingleScreenToFile() async {
    String filePath = await FlutterMultiScreenshot.captureToFile();
    setState(() {
      singleScreenshotPath = filePath;
      singleScreenshotBase64 = null;
    });
  }

  Future<void> captureSingleScreenAsBase64() async {
    String base64Image = await FlutterMultiScreenshot.captureAsBase64();
    String cleanBase64 = base64Image.replaceAll('\n', '').replaceAll('\r', '');
    setState(() {
      singleScreenshotBase64 = base64Decode(cleanBase64);
      singleScreenshotPath = null;
    });
  }

  Future<void> captureAllScreenshotsToFile() async {
    List<String> filePaths = await FlutterMultiScreenshot.captureAllToFile();
    setState(() {
      screenshotPaths = filePaths;
      base64Screenshots = null;
    });
  }

  Future<void> captureAllScreenshotsAsBase64() async {
    List<String> base64Images = await FlutterMultiScreenshot.captureAllAsBase64();
    List<Uint8List> decodedImages = base64Images.map((base64) {
      String cleanBase64 = base64.replaceAll('\n', '').replaceAll('\r', '');
      return base64Decode(cleanBase64);
    }).toList();
    setState(() {
      base64Screenshots = decodedImages;
      screenshotPaths = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Multi-Screen Screenshot Test")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (singleScreenshotPath != null) ...[
              Text("Single Screenshot File:"),
              Image.file(File(singleScreenshotPath!), width: 200, height: 200),
            ],
            if (singleScreenshotBase64 != null) ...[
              Text("Single Screenshot Base64 Preview:"),
              Image.memory(singleScreenshotBase64!, width: 200, height: 200),
            ],
            if (screenshotPaths != null) ...[
              Text("All Screenshots as Files:"),
              for (var path in screenshotPaths!)
                Image.file(File(path), width: 200, height: 200),
            ],
            if (base64Screenshots != null) ...[
              Text("All Screenshots as Base64:"),
              for (var image in base64Screenshots!)
                Image.memory(image, width: 200, height: 200),
            ],
            SizedBox(height: 20),
            ElevatedButton(onPressed: captureSingleScreenToFile, child: Text("Capture Single Screen (File)")),
            ElevatedButton(onPressed: captureSingleScreenAsBase64, child: Text("Capture Single Screen (Base64)")),
            ElevatedButton(onPressed: captureAllScreenshotsToFile, child: Text("Capture All Screens (Files)")),
            ElevatedButton(onPressed: captureAllScreenshotsAsBase64, child: Text("Capture All Screens (Base64)")),
          ],
        ),
      ),
    );
  }
}
```

---

## **🛠️ Supported Screenshot Tools**
This plugin **automatically detects** and uses one of the following tools:
- 🖼 **`gnome-screenshot`** (Default for Ubuntu GNOME)
- 🖼 **`scrot`** (Lightweight CLI alternative)
- 🖼 **`flameshot`** (Modern screenshot tool)
- 🖼 **`maim`** (Alternative to `scrot`)
- 🖼 **`import`** (ImageMagick)

### **📌 Install a Screenshot Tool (If Missing)**
```sh
sudo apt install gnome-screenshot scrot flameshot maim imagemagick
```

---

## **❌ Troubleshooting**
### **1️⃣ Screenshots are black/empty?**
If running on **Wayland**, switch to **X11**:
```sh
export GDK_BACKEND=x11
flutter run -d linux
```

### **2️⃣ Plugin not found?**
```sh
flutter doctor -v
flutter pub get
flutter build linux
```

### **3️⃣ Check if the plugin is built correctly**
```sh
ls build/linux/x64/debug/bundle/libflutter_multi_screenshot.so
```
If the file doesn’t exist, **rebuild the plugin**:
```sh
flutter clean
flutter build linux
```

---

## **📄 License**
This plugin is licensed under the **MIT License**.

---

## **👨‍💻 Contributing**
Pull requests are welcome! If you find a bug or have suggestions, **open an issue**.

---
