//
//  AppDelegate.m
//  WCRedditCards
//
//  Created by David Xiang on 3/18/15.
//  Copyright (c) 2015 com.trywildcard. All rights reserved.
//

#import "AppDelegate.h"
@import WildcardSDK;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"Using WildcardSDK version: %f", WildcardSDKVersionNumber);
    
    // initialize
    [WildcardSDK initializeWithApiKey:@"b17442d4-5ca1-4173-bc90-bb9ee60086ab"];
    
    return YES;
}



@end
