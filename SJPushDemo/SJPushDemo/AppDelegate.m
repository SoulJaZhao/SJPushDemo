//
//  AppDelegate.m
//  SJPushDemo
//
//  Created by SoulJa on 2017/6/17.
//  Copyright © 2017年 com.soulja. All rights reserved.
//

#import "AppDelegate.h"

static NSString *const Notification_Action_Follow_ID = @"Notification_Action_Follow_ID";
static NSString *const Notification_Action_Cancel_ID = @"Notification_Action_Cancel_ID";

static NSString *const Notification_Category_Follow = @"Notification_Category_Follow";

@interface AppDelegate () <UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerAPNS];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 注册APNS
- (void)registerAPNS {
    //Action Category Setting
    UIMutableUserNotificationAction *actionFollow = [[UIMutableUserNotificationAction alloc] init];
    actionFollow.identifier = Notification_Action_Follow_ID;
    actionFollow.activationMode = UIUserNotificationActivationModeBackground;
    actionFollow.title = @"关注";
    actionFollow.destructive = false;
    [actionFollow setAuthenticationRequired:NO];
    
    UIMutableUserNotificationAction *actionCancel = [[UIMutableUserNotificationAction alloc] init];
    actionCancel.identifier = Notification_Action_Cancel_ID;
    actionFollow.activationMode = UIUserNotificationActivationModeBackground;
    actionCancel.title = @"取消";
    actionCancel.destructive = false;
    [actionCancel setAuthenticationRequired:NO];
    
    UIMutableUserNotificationCategory *categoryFollow = [[UIMutableUserNotificationCategory alloc] init];
    categoryFollow.identifier = Notification_Category_Follow;
    [categoryFollow setActions:@[actionFollow,actionCancel] forContext:UIUserNotificationActionContextDefault];
    NSSet *categorys = [NSSet setWithObject:categoryFollow];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:categorys];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

#pragma mark - 注册到推送信息
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types == UIUserNotificationTypeNone) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请开启推送开关" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        [alertView show];
    } else {
        [application registerForRemoteNotifications];
    }
}

#pragma mark - 接收到消息通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"从后台进来");
    }
    NSLog(@"userInfo:%@",userInfo);
}

#pragma mark - 获取deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"%@",deviceTokenString);
}

#pragma mark - 注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"error:%@",error);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - 接收远程按钮
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    if ([identifier isEqualToString:Notification_Action_Follow_ID]) {
        NSLog(@"关注");
    }
}

@end
