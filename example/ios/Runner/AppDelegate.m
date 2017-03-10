#include "AppDelegate.h"
#include "FlutterImagePicker/ImagePicker.h"

@implementation AppDelegate {
  FLTImagePicker* _imagePicker;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  FlutterViewController* flutterController = (FlutterViewController*)self.window.rootViewController;
  _imagePicker = [[FLTImagePicker alloc] init];
  [flutterController addMessageListener:_imagePicker];
  return YES;
}

@end
