//
//  Tab3_Cell_2.h
//  DynamicBUSAN_F
//
//  Created by JaeYeup Lee on 2014. 9. 15..
//  Copyright (c) 2014년 skoinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Sub_Cell_2 : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *pushListLabel;

@property (weak, nonatomic) IBOutlet UIButton *testBtnOutlet;

- (IBAction)testBtn:(id)sender;

- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage;

@property (weak, nonatomic) IBOutlet UIImageView *cell2_BGImgView;

@property (weak, nonatomic) IBOutlet UILabel *cell2_label;

@end
