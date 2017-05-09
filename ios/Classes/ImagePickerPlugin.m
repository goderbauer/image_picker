@import UIKit;

#import "ImagePickerPlugin.h"

@interface ImagePickerPlugin ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation ImagePickerPlugin {
  FlutterResult _result;
  UIImagePickerController *_imagePickerController;
}

- (instancetype)initWithController:(FlutterViewController *)flutterView {
  self = [super init];
  if (self) {
    _imagePickerController = [[UIImagePickerController alloc] init];
    FlutterMethodChannel *channel =
        [FlutterMethodChannel methodChannelWithName:@"image_picker" binaryMessenger:flutterView];
    [channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
      if (_result) {
        _result([FlutterError errorWithCode:@"multiple_request"
                                    message:@"Cancelled by a second request"
                                    details:nil]);
        _result = nil;
      }
      if ([@"pickImage" isEqualToString:call.method]) {
        _imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        _imagePickerController.delegate = self;
        _result = result;

        UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:nil
                                                message:nil
                                         preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *camera = [UIAlertAction
            actionWithTitle:@"Camera"
                      style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction *action) {
                      _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                      [flutterView presentViewController:_imagePickerController
                                                animated:YES
                                              completion:nil];
                    }];
        UIAlertAction *library =
            [UIAlertAction actionWithTitle:@"Photo Library"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                     _imagePickerController.sourceType =
                                         UIImagePickerControllerSourceTypePhotoLibrary;
                                     [flutterView presentViewController:_imagePickerController
                                                               animated:YES
                                                             completion:nil];
                                   }];
        [alert addAction:camera];
        [alert addAction:library];
        [flutterView presentViewController:alert animated:YES completion:nil];
      } else {
        result(FlutterMethodNotImplemented);
      }
    }];
  }
  return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
  [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  if (image == nil) {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
  }
  if (image == nil) {
    image = [info objectForKey:UIImagePickerControllerCropRect];
  }
  image = [self normalizedImage:image];
  NSData *data = UIImageJPEGRepresentation(image, 1.0);
  NSString *tmpDirectory = NSTemporaryDirectory();
  NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
  // TODO(jackson): Using the cache directory might be better than temporary
  // directory.
  NSString *tmpFile = [NSString stringWithFormat:@"image_picker_%@.jpg", guid];
  NSString *tmpPath = [tmpDirectory stringByAppendingPathComponent:tmpFile];
  if ([[NSFileManager defaultManager] createFileAtPath:tmpPath contents:data attributes:nil]) {
    _result(tmpPath);
  } else {
    _result([FlutterError errorWithCode:@"create_error"
                                message:@"Temporary file could not be created"
                                details:nil]);
  }
  _result = nil;
}

// The way we save images to the tmp dir currently throws away all EXIF data
// (including the orientation of the image). That means, pics taken in portrait
// will not be orientated correctly as is. To avoid that, we rotate the actual
// image data.
// TODO(goderbauer): investigate how to preserve EXIF data.
- (UIImage *)normalizedImage:(UIImage *)image {
  if (image.imageOrientation == UIImageOrientationUp) return image;

  UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
  [image drawInRect:(CGRect){0, 0, image.size}];
  UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return normalizedImage;
}

@end
