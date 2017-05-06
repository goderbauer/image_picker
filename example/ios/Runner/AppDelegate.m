#include "AppDelegate.h"
#include "ImagePickerPlugin.h"

@implementation AppDelegate {
  ImagePickerPlugin *_image_picker;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  FlutterViewController *flutterController =
      (FlutterViewController *)self.window.rootViewController;
  _image_picker =
      [[ImagePickerPlugin alloc] initWithController:flutterController];
  return YES;
}

@end
