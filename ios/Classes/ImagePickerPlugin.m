@import UIKit;

#import "ImagePickerPlugin.h"

@interface ImagePickerPlugin() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation ImagePickerPlugin {
  FlutterResultReceiver _result;
  UIImagePickerController *_imagePickerController;
}

- (instancetype)initWithFlutterView:(FlutterViewController *)flutterView {
  self = [super init];
  if (self) {
    _imagePickerController = [[UIImagePickerController alloc] init];
    FlutterMethodChannel *channel =
        [FlutterMethodChannel methodChannelWithName:@"image_picker"
                                    binaryMessenger:flutterView];
    [channel setMethodCallHandler:^(FlutterMethodCall *call,
                                    FlutterResultReceiver result) {
      if (_result) {
        _result([FlutterError errorWithCode:@"multiple_request" message:@"Cancelled by a second request" details:nil]);
        _result = nil;
      }
      if ([@"pickImage" isEqualToString:call.method]) {
        _imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.delegate = self;
        [flutterView presentViewController:_imagePickerController animated:YES completion:nil];
        _result = result;
      }
    }];
  }
  return self;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
  [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
  UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
  if (image == nil) {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
  }
  if (image == nil) {
    image = [info objectForKey:UIImagePickerControllerCropRect];
  }
  NSData *data = UIImageJPEGRepresentation(image, 1.0);
  NSString *tmpDirectory = NSTemporaryDirectory();
  NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
  // TODO(jackson): Using the cache directory might be better than temporary directory.
  NSString *tmpFile = [NSString stringWithFormat:@"image_picker_%@.jpg", guid];
  NSString *tmpPath = [tmpDirectory stringByAppendingPathComponent:tmpFile];
  if ([[NSFileManager defaultManager] createFileAtPath:tmpPath contents:data attributes:nil]) {
    _result(tmpPath);
  } else {
    _result([FlutterError errorWithCode:@"create_error" message:@"Temporary file could not be created" details:nil]);
  }
  _result = nil;
}

@end
