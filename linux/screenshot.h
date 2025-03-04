#ifndef SCREENSHOT_H
#define SCREENSHOT_H

#include <flutter_linux/flutter_linux.h>

#ifdef __cplusplus
extern "C" {
#endif

// Declare the method call handler
void screenshot_plugin_handle_method_call(FlMethodChannel* channel, FlMethodCall* method_call, gpointer user_data);

#ifdef __cplusplus
}
#endif

#endif // SCREENSHOT_H