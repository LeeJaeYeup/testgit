//
//  Tab3_Cell_1.h
//  DynamicBUSAN_F
//
//  Created by JaeYeup Lee on 2014. 9. 15..
//  Copyright (c) 2014년 skoinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Sub_Cell_1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cell1_label;
@property (weak, nonatomic) IBOutlet UIImageView *cell1_allowImgView;
@property (weak, nonatomic) IBOutlet UIImageView *cell1_BGImgView;

- (void)changeArrowWithUp:(BOOL)up;

@end
