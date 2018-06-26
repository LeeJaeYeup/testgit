//
//  AppDelegate.h
//  DaeguSchoolNavi
//
//  Created by SKOINFO_MACBOOK on 2015. 11. 27..
//  Copyright (c) 2015년 SKOINFO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (weak, nonatomic) ViewController *viewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSString*)getUUID;

@end

