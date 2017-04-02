#import "ImagePickerPlugin.h"

@implementation ImagePickerPlugin {
}

- (instancetype)initWithFlutterView:(FlutterViewController *)flutterView {
  self = [super init];
  if (self) {
    FlutterMethodChannel *channel =
        [FlutterMethodChannel methodChannelWithName:@"image_picker"
                                    binaryMessenger:flutterView];
    [channel setMethodCallHandler:^(FlutterMethodCall *call,
                                    FlutterResultReceiver result) {
      if ([@"pickImage" isEqualToString:call.method]) {
        result(
            @"http://www.burienwa.gov/images/pages/N884/"
            @"FreeDownloadKitten.jpg"); // TODO(jackson): This is a placeholder
      }
    }];
  }
  return self;
}

@end
