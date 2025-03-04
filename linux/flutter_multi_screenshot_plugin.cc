#include "include/flutter_multi_screenshot/flutter_multi_screenshot_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>
#include "screenshot.h"
#include "flutter_multi_screenshot_plugin_private.h"

#define FLUTTER_MULTI_SCREENSHOT_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), flutter_multi_screenshot_plugin_get_type(), \
                              FlutterMultiScreenshotPlugin))

struct _FlutterMultiScreenshotPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(FlutterMultiScreenshotPlugin, flutter_multi_screenshot_plugin, g_object_get_type())

FlMethodResponse* get_platform_version() {
  struct utsname uname_data = {};
  uname(&uname_data);
  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
  g_autoptr(FlValue) result = fl_value_new_string(version);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static void flutter_multi_screenshot_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(flutter_multi_screenshot_plugin_parent_class)->dispose(object);
}

static void flutter_multi_screenshot_plugin_class_init(FlutterMultiScreenshotPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = flutter_multi_screenshot_plugin_dispose;
}

static void flutter_multi_screenshot_plugin_init(FlutterMultiScreenshotPlugin* self) {}

void flutter_multi_screenshot_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  FlutterMultiScreenshotPlugin* plugin = FLUTTER_MULTI_SCREENSHOT_PLUGIN(
      g_object_new(flutter_multi_screenshot_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "flutter_multi_screenshot",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, screenshot_plugin_handle_method_call,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
