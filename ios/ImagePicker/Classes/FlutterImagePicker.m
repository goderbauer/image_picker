// Copyright 2016, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#import "FlutterGoogleSignIn.h"

@implementation FLTImagePicker {
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        // Initialize
    }
    return self;
}

- (void)didReceiveString:(NSString*)message
                callback:(void(^)(NSString*))sendResponse
{
    [_callbacks insertObject:sendResponse atIndex:0];
    NSString *method;
    NSError *error = nil;
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error == nil) {
        method = [jsonObject objectForKey:@"method"];
    }
    if ([method isEqualToString:@"pickImage"]) {
        NSLog("Pick image!");
    } else {
        [NSException raise:@"JSON parsing error" format:@"FlutterGoogleSignIn received an unexpected JSON message"];
    }
}

- (NSString *)messageName {
    return @"GoogleSignIn";
}

@end
