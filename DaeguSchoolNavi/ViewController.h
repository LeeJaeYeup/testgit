//
//  ViewController.h
//  DaeguSchoolNavi
//
//  Created by SKOINFO_MACBOOK on 2015. 11. 27..
//  Copyright (c) 2015년 SKOINFO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, NSXMLParserDelegate,UIWebViewDelegate>

// 한컴뷰어 열결을 위해 document창
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

- (void)pushAlarmGet_ing:(NSArray*)objectArray;
- (void)pushAlarmProgress:(NSArray*)objectArray;

@end

