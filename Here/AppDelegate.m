//
//  AppDelegate.m
//  Here
//
//  Created by Cristian Monterroza on 11/3/14.
//  Copyright (c) 2014 Cristian Monterroza. All rights reserved.
//

#import "AppDelegate.h"
#import <SpriteKit/SpriteKit.h>
#import <WSMLogger/WSMLogger.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)load {
    WSMLogger *logger = WSMLogger.sharedInstance;
    [DDLog addLogger:logger];
    
    // Customize the WSLogger
    logger.formatStyle = kWSMLogFormatStyleQueue;
    logger[kWSMLogFormatKeyFile] = @7;
    logger[kWSMLogFormatKeyFunction] = @40;
    
    // Color the WSlogger. By default DDLog does not color VERBOSE or warn flags.
    [logger setColorsEnabled:YES];
    [logger setForegroundColor:SKColor.orangeColor
               backgroundColor:SKColor.blackColor
                       forFlag:LOG_FLAG_WARN];
    
    [logger setForegroundColor:SKColor.yellowColor
               backgroundColor:SKColor.blackColor
                       forFlag:LOG_FLAG_VERBOSE];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

+ (NSArray *)jobData {
    static dispatch_once_t onceToken;
    static NSArray  *jobData;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [NSBundle.mainBundle pathForResource:@"jobData"
                                                           ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        jobData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    });
    return jobData;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
