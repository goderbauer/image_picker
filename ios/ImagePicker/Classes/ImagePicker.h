// Copyright 2016, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#import <Google/SignIn.h>

@class UIViewController;

// If Flutter's engine were a CocoaPod, we'd import it here instead
@protocol FlutterAsyncMessageListener<NSObject>
- (void)didReceiveString:(NSString*)message
                callback:(void(^)(NSString*))sendResponse;
@property(readonly, strong, nonatomic) NSString* messageName;
@end

@interface FLTGoogleSignIn : NSObject <GIDSignInDelegate, GIDSignInUIDelegate, FlutterAsyncMessageListener>
+ (instancetype)sharedInstance;
- (BOOL)  handleURL:(NSURL*)url
  sourceApplication:(NSString*)sourceApplication
         annotation:(id)annotation;
@property(nonatomic) id uiDelegate;
@property(nonatomic, strong) NSString *clientID;

@end
