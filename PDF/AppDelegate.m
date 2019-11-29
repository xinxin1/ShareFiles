//
//  AppDelegate.m
//  PDF
//
//  Created by valiant on 2019/11/8.
//  Copyright © 2019 xin. All rights reserved.
//

#import "AppDelegate.h"
//#import "ViewController.h"
#import "ShareViewController.h"



#import <GoogleSignIn/GoogleSignIn.h>
#import <EvernoteSDK/EvernoteSDK.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import <BoxContentSDK/BOXContentSDK.h>
#import <OneDriveSDK/OneDriveSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 印象笔记
    [ENSession setSharedSessionConsumerKey:@"valiant" consumerSecret:@"e4623f526044de60" optionalHost:ENSessionHostSandbox];
    [[ENSession sharedSession] setValue:@"sandbox.evernote.com" forKey:@"sessionHost"];
    // dropbox
    [DBClientsManager setupWithAppKey:@"jkf1tf5wzyw46tv"];
    // box
//    [BOXContentClient setClientID:@"jvhllgfnp8fdwra0pp1fkavhlah1q2wd" clientSecret:@"YcmOZ6gMdqnrqEgN736b0Kxndglg8ACm"];
    [BOXContentClient setClientID:@"svgdg6ekzvdhr2za0gqi9r78st54pkjh" clientSecret:@"KjjMQHPEvuqvCWEtFhrn5q9TE2WZXWUM"];
    // oneDrive
    [ODClient setMicrosoftAccountAppId:@"b0cd081d-67ee-4d37-a91b-ac1153e6c368" scopes:@[@"onedrive.readwrite",@"offline_access"]];
    [ODClient setActiveDirectoryAppId:@"b0cd081d-67ee-4d37-a91b-ac1153e6c368" redirectURL:@"msalb0cd081d-67ee-4d37-a91b-ac1153e6c368://auth"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self.window setRootViewController:[ShareViewController new]];
    return YES;
}


#pragma mark - UISceneSession lifecycle



// 如果手机有这些app，则需要进行判断这里
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    //
    [[GIDSignIn sharedInstance] handleURL:url];
    // dropbox :
    //souceApplication com.apple.SafariViewService
    //scheme db-xc9ycmqax1jm4v7
    DBOAuthResult *authResult = [DBClientsManager handleRedirectURL:url];
    if (authResult != nil) {
      if ([authResult isSuccess]) {
        NSLog(@"Success! User is logged into Dropbox.");
          return YES;
      } else if ([authResult isCancel]) {
        NSLog(@"Authorization flow was manually canceled by user!");
        return NO;
      } else if ([authResult isError]) {
        NSLog(@"Error: %@", authResult);
        return NO;
      }
    }
    
    /// box
    if ([@"boxsdk-svgdg6ekzvdhr2za0gqi9r78st54pkjh" isEqualToString:url.scheme]) {
        return YES;
    }
    
    return NO;
}


@end
