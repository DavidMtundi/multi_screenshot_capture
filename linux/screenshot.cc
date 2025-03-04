#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include "screenshot.h"
#include <cstring>
#include <cstdlib>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <chrono>
#include <unistd.h>
#include <sys/time.h>
#include <array>
#include <memory>
#include <stdexcept> 
#include <unistd.h>

//static const char* kChannelName = "screenshot";

// Method names
static const char* kCaptureScreenshotAsBase64 = "captureScreenshotAsBase64";
static const char* kCaptureScreenshotToFile = "captureScreenshotToFile";
static const char* kCaptureAllScreenshotsAsBase64 = "captureAllScreenshotsAsBase64";
static const char* kCpatureAllScreenShotsToFiles = "captureAllScreenshotsToFiles";
// Screenshot tool names
static const char* kScrot = "scrot";
static const char* kGnomeScreenshot = "gnome-screenshot";
static const char* kImageMagick = "import";

// Utility function to check if a command exists
bool command_exists(const std::string& command) {
    std::string path = "/usr/bin/" + command;  // Adjust based on system PATH
    return access(path.c_str(), X_OK) == 0;
}

// Utility function to execute a command and return its output
std::string execute_command(const std::string& command) {
    std::array<char, 128> buffer;  // Use std::array
    std::string result;
    std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(command.c_str(), "r"), pclose);
    if (!pipe) {
        throw std::runtime_error("popen() failed!");
    }
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        result += buffer.data();
    }
    return result;
}

// Utility function to get the current timestamp in milliseconds
std::string get_timestamp() {
    auto now = std::chrono::system_clock::now();
    auto duration = now.time_since_epoch();
    auto millis = std::chrono::duration_cast<std::chrono::milliseconds>(duration).count();
    return std::to_string(millis);
}
// Get number of monitors
int get_monitor_count() {
    int count = 0;
    std::string command = "xrandr --listmonitors | wc -l";
    std::string output = execute_command(command);
    try {
        count = std::stoi(output) - 1; // Remove header line
    } catch (...) {
        count = 1; // Default to one screen
    }
    return count;
}
// Capture screenshots from all monitors
std::vector<std::string> capture_all_screenshots() {
    std::vector<std::string> file_paths;
    int monitor_count = get_monitor_count();

    for (int i = 0; i < monitor_count; i++) {
        std::string file_path = "/tmp/screenshot_" + get_timestamp() + "_monitor" + std::to_string(i) + ".png";
        
        std::string command;
        if (command_exists(kGnomeScreenshot)) {
            command = "gnome-screenshot --file=" + file_path + " --include-pointer --delay=2 --screen";
        } else if (command_exists(kImageMagick)) {
            command = "import -window root " + file_path;
        } else if (command_exists(kScrot)) {
            command = "scrot " + file_path;
        } else {
            throw std::runtime_error("No supported screenshot tool found.");
        }

        if (system(command.c_str()) != 0) {
            throw std::runtime_error("Failed to capture screenshot for monitor " + std::to_string(i));
        }

        file_paths.push_back(file_path);
    }

    return file_paths;
}

// Convert all screenshots to Base64
std::vector<std::string> capture_all_screenshots_as_base64() {
    std::vector<std::string> base64_images;
    std::vector<std::string> file_paths = capture_all_screenshots();

    for (const auto& file_path : file_paths) {
        std::string command = "base64 " + file_path;
        std::string base64_image = execute_command(command);
        base64_images.push_back(base64_image);
        remove(file_path.c_str()); // Delete temporary file
    }

    return base64_images;
}
// Base class for screenshot tools
class ScreenshotTool {
public:
    virtual ~ScreenshotTool() = default;
    virtual std::string capture(const std::string& file_path) = 0;
    virtual std::string capture_as_base64() = 0;
};

// Scrot implementation
class ScrotTool : public ScreenshotTool {
public:
    std::string capture(const std::string& file_path) override {
        std::string command = kScrot + std::string(" -m ") + file_path;
        if (system(command.c_str()) != 0) {
            throw std::runtime_error("Failed to capture screenshot using scrot.");
        }
        return file_path;
    }

    std::string capture_as_base64() override {
        std::string file_path = "/tmp/screenshot_" + get_timestamp() + ".png";
        capture(file_path);
        std::string command = "base64 " + file_path;
        std::string base64_image = execute_command(command);
        remove(file_path.c_str());
        return base64_image;
    }
};

// Gnome-screenshot implementation
class GnomeScreenshotTool : public ScreenshotTool {
public:
    std::string capture(const std::string& file_path) override {
        std::string command = kGnomeScreenshot + std::string(" -f ") + file_path;
        if (system(command.c_str()) != 0) {
            throw std::runtime_error("Failed to capture screenshot using gnome-screenshot.");
        }
        return file_path;
    }

    std::string capture_as_base64() override {
        std::string file_path = "/tmp/screenshot_" + get_timestamp() + ".png";
        capture(file_path);
        std::string command = "base64 " + file_path;
        std::string base64_image = execute_command(command);
        remove(file_path.c_str());
        return base64_image;
    }
};

// ImageMagick implementation
class ImageMagickTool : public ScreenshotTool {
public:
    std::string capture(const std::string& file_path) override {
        std::string command = kImageMagick + std::string(" -window root ") + file_path;
        if (system(command.c_str()) != 0) {
            throw std::runtime_error("Failed to capture screenshot using ImageMagick.");
        }
        return file_path;
    }

    std::string capture_as_base64() override {
        std::string file_path = "/tmp/screenshot_" + get_timestamp() + ".png";
        capture(file_path);
        std::string command = "base64 " + file_path;
        std::string base64_image = execute_command(command);
        remove(file_path.c_str());
        return base64_image;
    }
};

class GenericScreenshotTool : public ScreenshotTool {
    std::string command;
public:
    explicit GenericScreenshotTool(std::string cmd) : command(std::move(cmd)) {}

    std::string capture(const std::string& file_path) override {
        std::string full_command = command + " -f " + file_path;
        if (system(full_command.c_str()) != 0) {
            throw std::runtime_error("Failed to capture screenshot using " + command);
        }
        return file_path;
    }

    std::string capture_as_base64() override {
        std::string file_path = "/tmp/screenshot_" + get_timestamp() + ".png";
        capture(file_path);
        std::string base64_image = execute_command("base64 " + file_path);
        remove(file_path.c_str());
        return base64_image;
    }
};


// Factory to create the appropriate screenshot tool
std::unique_ptr<ScreenshotTool> create_screenshot_tool() {
    if (command_exists(kScrot)) {
        return std::make_unique<ScrotTool>();
    } else if (command_exists(kGnomeScreenshot)) {
        return std::make_unique<GnomeScreenshotTool>();
    } else if (command_exists(kImageMagick)) {
        return std::make_unique<ImageMagickTool>();
    } else {
        throw std::runtime_error("No supported screenshot tool found.");
    }
}

std::unique_ptr<ScreenshotTool> create_screenshot_tool_updated() {
    // List of possible screenshot tools on Ubuntu
    std::vector<std::string> tools = {
        "gnome-screenshot",
        "screencapture",
        "import",     
        "scrot",           
        "flameshot",        
        "deepin-screenshot",
        "maim"               
    };

    for (const auto& tool : tools) {
        if (command_exists(tool)) {
            if (tool == "gnome-screenshot") {
                return std::make_unique<GnomeScreenshotTool>();
            } else if (tool == "import") {
                return std::make_unique<ImageMagickTool>();
            } else if (tool == "scrot") {
                return std::make_unique<ScrotTool>();
            } else {
                // Generic screenshot command wrapper
                return std::make_unique<GenericScreenshotTool>(tool);
            }
        }
    }

    throw std::runtime_error("No supported screenshot tool found.");
}

// Method call handler
void screenshot_plugin_handle_method_call(FlMethodChannel* channel, FlMethodCall* method_call, gpointer user_data) {
    const gchar* method = fl_method_call_get_name(method_call);

    try {
        auto screenshot_tool = create_screenshot_tool_updated();
        if (strcmp(method, kCaptureAllScreenshotsAsBase64) == 0) {
            std::vector<std::string> base64_images = capture_all_screenshots_as_base64();
            g_autoptr(FlValue) result = fl_value_new_list();
            for (const auto& img : base64_images) {
                fl_value_append_take(result, fl_value_new_string(img.c_str()));
            }
            fl_method_call_respond_success(method_call, result, nullptr);
        } else if (strcmp(method, kCpatureAllScreenShotsToFiles) == 0) {
            std::vector<std::string> file_paths = capture_all_screenshots();
            g_autoptr(FlValue) result = fl_value_new_list();
            for (const auto& path : file_paths) {
                fl_value_append_take(result, fl_value_new_string(path.c_str()));
            }
            fl_method_call_respond_success(method_call, result, nullptr);
        } 
        else if (strcmp(method, kCaptureScreenshotAsBase64) == 0) {
            std::string base64_image = screenshot_tool->capture_as_base64();
            g_autoptr(FlValue) result = fl_value_new_string(base64_image.c_str());
            fl_method_call_respond_success(method_call, result, nullptr);
        } else if (strcmp(method, kCaptureScreenshotToFile) == 0) {
            std::string file_path = "/tmp/screenshot_" + get_timestamp() + ".png";
            screenshot_tool->capture(file_path);
            g_autoptr(FlValue) result = fl_value_new_string(file_path.c_str());
            fl_method_call_respond_success(method_call, result, nullptr);
        } else {
            fl_method_call_respond_not_implemented(method_call, nullptr);
        }
    } catch (const std::exception& e) {
        fl_method_call_respond_error(method_call, "CAPTURE_ERROR", e.what(), nullptr, nullptr);
    }
}
