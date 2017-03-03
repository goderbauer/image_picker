#include "AppDelegate.h"

#import <FlutterImagePicker/FlutterImagePicker.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController *controller = (FlutterViewController*)self.window.rootViewController;
    [controller addAsyncMessageListener:[FLTImagePicker sharedInstance]];
    return YES;
}

@end
