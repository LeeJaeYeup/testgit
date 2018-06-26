// third git Test
//
// second git Test
//
// git Test
//
//  AppDelegate.m
//  DaeguSchoolNavi
//
//  Created by SKOINFO_MACBOOK on 2015. 11. 27..
//  Copyright (c) 2015년 SKOINFO. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "KeychainItemWrapper.h"

@import Firebase;
@import UserNotifications;

@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
{
    NSString *pushUrlStr;
    NSString *pushTitleStr;
    NSArray *pushObjectArray;
}

@end

@implementation AppDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if (buttonIndex == 1) {
            [self.viewController performSelectorOnMainThread:@selector(pushAlarmProgress:) withObject:pushObjectArray waitUntilDone:YES];
        }
    }
    //탈옥이 감지되었을 경우...
    else if(alertView.tag == 2)
    {
        exit(0);
    }
    //업데이트 알림창...
    else if(alertView.tag == 3)
    {
        if(buttonIndex == 1)
        {
            NSString *updateUrl = [@"https://itunes.apple.com/kr/app/seukulnabi/id893129176?l=ko&ls=1&mt=8" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:updateUrl]];
        }
        //취소버튼 선택시
        else
        {
            exit(0);
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 480) {
        NSLog(@"ScreenSize 3.5inch");
        UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone34" bundle:nil];
        UIViewController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = initialViewController;
        [self.window makeKeyAndVisible];
    }else { //if (iOSDeviceScreenSize.height == 568) {
        NSLog(@"ScreenSize 4.0inch");
        UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = initialViewController;
        [self.window makeKeyAndVisible];
    }
    
    if(launchOptions)
    {
        pushUrlStr = [NSString stringWithFormat:@"%@",[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"url"]];
        
        pushTitleStr = [NSString stringWithFormat:@"%@",[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] objectForKey:@"alert"]];
        
        pushObjectArray = [NSArray arrayWithObjects:pushUrlStr, pushTitleStr, nil];
        
        UIAlertView *pushAlert;
        
        [pushAlert dismissWithClickedButtonIndex:0 animated:YES];
        
        
        if ([[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] == nil || [[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] == (id)[NSNull null]) {
            // nil branch
        } else {
            UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:pushTitleStr
                                                                message:@"새로운 알림이 있습니다.\n지금바로 확인 하시겠습니까?"
                                                               delegate:self
                                                      cancelButtonTitle:@"닫기"
                                                      otherButtonTitles:@"확인하기", nil];
            pushAlert.tag = 1;
            [pushAlert show];
            NSLog(@"test33322 -- %@",launchOptions);
        }
    }
    
    
    
    // FCM firebase
    [FIRApp configure];
    
    [FIRMessaging messaging].delegate = self;
    
    
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
             // ...
         }];
    } else {
        // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [application registerForRemoteNotifications];
    
    
    //탐옥여부 확인
    if([self detectJailBreak])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림"
                                                            message:@"탈옥된 단말입니다.\n보안의 위험성이 있으므로 앱을 종료합니다."
                                                           delegate:self
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil, nil];
        alertView.tag = 2;
        [alertView show];
    }
    
    return YES;
}






// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    
    // Print full message.
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
// 앱이 실행중일때 푸시 알림
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    

    // Print full message.
    NSLog(@"%@", userInfo);
    
    if ([userInfo objectForKey:@"url"]) {
        pushUrlStr = [userInfo objectForKey:@"url"];
        
        pushTitleStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        pushObjectArray = [NSArray arrayWithObjects:pushUrlStr, pushTitleStr, nil];
        
        [self.viewController performSelectorOnMainThread:@selector(pushAlarmGet_ing:) withObject:pushObjectArray waitUntilDone:YES];
        
    }
    
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
// 노티를 통해 들어왔을때
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    if ([userInfo objectForKey:@"url"]) {
        pushUrlStr = [userInfo objectForKey:@"url"];
        
        pushTitleStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    }else {
        pushUrlStr = [NSString stringWithFormat:@""];
    }
    pushObjectArray = [NSArray arrayWithObjects:pushUrlStr, pushTitleStr, nil];
    
    [self.viewController performSelectorOnMainThread:@selector(pushAlarmGet_ing:) withObject:pushObjectArray waitUntilDone:YES];
    
    completionHandler();
}

// [END ios_10_message_handling]

// [START refresh_token]
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
    
    [self setToken:fcmToken];
    
}
// [END refresh_token]

// [START ios_10_data_message]
// Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
// To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"Received data message: %@", remoteMessage.appData);
}
// [END ios_10_data_message]

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs device token can be paired to
// the FCM registration token.
// 디바이스 토큰값 받아오기
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs device token retrieved: %@", deviceToken);
    
    // With swizzling disabled you must set the APNs device token here.
    // [FIRMessaging messaging].APNSToken = deviceToken;
}



-(void)setToken:(NSString *)token
{
    NSString *deviceUUID = [self getUUID];
    NSLog(@"test299312 UUID -- %@",deviceUUID);

    NSString *url_str =[[NSString alloc] initWithFormat:@"http://118.219.7.120/push/pushInit.jsp?uuid=%@&os=I&regid=%@",deviceUUID,token];
    
    NSLog(@"test80 -- %@",url_str);
    
    NSURL *url = [NSURL URLWithString:[url_str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    
    NSURLConnection *SendConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (SendConnection) {
    
    }
    NSLog(@"test2992 -- token post");
}

- (NSString*)getUUID
{
    // initialize keychaing item for saving UUID.
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UUID" accessGroup:nil];
    
    NSString *uuid = [wrapper objectForKey:(__bridge id)(kSecAttrAccount)];
    
    if( uuid == nil || uuid.length == 0)
    {
        // if there is not UUID in keychain, make UUID and save it.
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        uuid = [NSString stringWithString:(__bridge NSString *) uuidStringRef];
        CFRelease(uuidStringRef);
        
        // save UUID in keychain
        [wrapper setObject:uuid forKey:(__bridge id)(kSecAttrAccount)];
    }
    
    return uuid;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", error];
    NSLog(@"Error:%@",str);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //앱 버전 확인하기...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL bNeedUpdate = [self needsUpdate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(bNeedUpdate == YES)
            {
                UIAlertView *versionAlertView =
                [[UIAlertView alloc] initWithTitle:@"알림"
                                           message:@"이전 버전을 사용하고 계십니다.\n업데이트 하시겠습니까?"
                                          delegate:self
                                 cancelButtonTitle:@"취소"
                                 otherButtonTitles:@"확인", nil];
                versionAlertView.tag = 3;
                [versionAlertView show];
            }
        });
    });
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "skoinfo.co.kr.DaeguSchoolNavi" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DaeguSchoolNavi" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DaeguSchoolNavi.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - 탈옥 감지

-(BOOL)detectJailBreak
{
#if !(TARGET_IPHONE_SIMULATOR)
    
    if([self detectJailBreakExistenceCommonFiles])
    {
        return [self detectJailBreakAccessSystemDirectory];
    }
#endif
    
    return NO;
}

//공용파일 존재확인
-(BOOL)detectJailBreakExistenceCommonFiles
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbin/sshd"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ||
        [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]])
    {
        return YES;
    }
    
    return NO;
}

//시스템 디렉토리 접근가능 여부 확인
-(BOOL)detectJailBreakAccessSystemDirectory
{
    FILE *f = NULL ;
    if ((f = fopen("/bin/bash", "r")) ||
        (f = fopen("/Applications/Cydia.app", "r")) ||
        (f = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r")) ||
        (f = fopen("/usr/sbin/sshd", "r")) ||
        (f = fopen("/etc/apt", "r"))) {
        fclose(f);
        return YES;
    }
    
    NSError *error;
    NSString *stringToBeWritten = @"Jailbreak Test.";
    [stringToBeWritten writeToFile:@"/private/jailbreak.txt" atomically:YES
                          encoding:NSUTF8StringEncoding error:&error];
    if(error==nil){
        //Device is jailbroken
        return YES;
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/jailbreak.txt" error:nil];
    }
    return NO;
}

#pragma mark -

//앱스토어에 있는 앱 버전과 로컬 앱 버전 비교해서 최신인지 알려주기
-(BOOL)needsUpdate
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@",appID]];
    NSLog(@"앱 버전확인 url : %@",url);
    NSData* data = [NSData dataWithContentsOfURL:url];
    
    if(data != nil)
    {
        NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"lookup : %@",lookup);
        
        //결과값이 있으면....
        if ([lookup[@"resultCount"] integerValue] >= 1)
        {
            NSString* appStoreVersion = lookup[@"results"][0][@"version"];
            NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
            
            appStoreVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            //버전 자리수가 다르면 글자길이가 작은애한테 0을 붙여준다.
            if([appStoreVersion length] != [currentVersion length])
            {
                int gapLength = 0;
                
                if([appStoreVersion length] < [currentVersion length])
                {
                    gapLength = (int)([currentVersion length] - [appStoreVersion length]);
                    
                    for(int j = 0; j < gapLength; j++)
                    {
                        appStoreVersion = [appStoreVersion stringByAppendingString:@"0"];
                    }
                }
                else
                {
                    gapLength = (int)([appStoreVersion length] - [currentVersion length]);
                    
                    for(int j = 0; j < gapLength; j++)
                    {
                        currentVersion = [currentVersion stringByAppendingString:@"0"];
                    }
                }
            }
            
            NSLog(@"appStoreVersion : %@",appStoreVersion);
            NSLog(@"currentVersion : %@",currentVersion);
            
            int storeVersion = [appStoreVersion intValue];
            int localVersion = [currentVersion intValue];
            
            if(storeVersion > localVersion)
            {
                NSLog(@"Need to update [%@ != %@]",appStoreVersion ,currentVersion);
                return YES;
            }
            
        }
    }
    
    return NO;
}


@end
