# **flutter_multi_screenshot**
A **Flutter plugin** for capturing screenshots on **Linux**. This plugin supports saving screenshots as **files** or **Base64-encoded strings**, making it easy to integrate screenshot functionality into Flutter desktop apps.

## **📌 Features**
- ✅ Capture a screenshot and **save it as a file**.
- ✅ Capture a screenshot and **return a Base64 string**.
- ✅ Automatically selects the **best available screenshot tool** on Linux (`scrot`, `gnome-screenshot`, `flameshot`, etc.).
- ✅ Works on **X11** (Wayland may need additional configuration).

---

## **🚀 Installation**
### **1️⃣ Add Dependency**
Add this plugin to your **pubspec.yaml**:
```yaml
dependencies:
  flutter_multi_screenshot:
    git:
      url: https://github.com/your-username/flutter_multi_screenshot.git
```
*(Replace `"your-username"` with your GitHub username if hosted on GitHub.)*

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

### **📸 Capture Screenshot as a File**
```dart
String filePath = await FlutterMultiScreenshot.captureToFile();
print("Screenshot saved at: $filePath");
```

### **📸 Capture Screenshot as Base64**
```dart
String base64Image = await FlutterMultiScreenshot.captureAsBase64();
print("Screenshot Base64: $base64Image");
```

### **🎯 Example App**
Here’s a simple example with buttons to **capture and display screenshots**:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_multi_screenshot/flutter_multi_screenshot.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(home: ScreenshotTestApp()));
}

class ScreenshotTestApp extends StatefulWidget {
  @override
  _ScreenshotTestAppState createState() => _ScreenshotTestAppState();
}

class _ScreenshotTestAppState extends State<ScreenshotTestApp> {
  String? screenshotPath;

  Future<void> captureScreenshot() async {
    String filePath = await FlutterMultiScreenshot.captureToFile();
    print("Screenshot saved at: $filePath");

    setState(() {
      screenshotPath = filePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Multi Screenshot Plugin Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (screenshotPath != null)
              Column(
                children: [
                  Text("Screenshot Path:"),
                  Text(screenshotPath!, style: TextStyle(color: Colors.blue)),
                  Image.file(File(screenshotPath!)),  // Show screenshot
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: captureScreenshot,
              child: Text("Capture Screenshot"),
            ),
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
If no supported tool is installed, **install one manually**:

```sh
sudo apt install gnome-screenshot scrot flameshot maim imagemagick
```

---

## **❌ Troubleshooting**
### **1️⃣ Screenshots are black/empty?**
If running on **Wayland**, switch to **X11**:
- **Log out** and click the **gear icon** on the login screen.
- Select **"Ubuntu on Xorg"**, then log in.
- Run your Flutter app again.

Or force X11 in your app:
```sh
export GDK_BACKEND=x11
flutter run -d linux
```

### **2️⃣ Plugin not found?**
Ensure Flutter detects the plugin:
```sh
flutter doctor -v
flutter pub get
flutter build linux
```

### **3️⃣ Check if the plugin is built correctly**
Run:
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

### 🎯 **Now your README file is ready!** 🚀  
Let me know if you want any modifications. 🔥
