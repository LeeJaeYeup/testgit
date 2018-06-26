//
//  Tab3_Cell_1.m
//  DynamicBUSAN_F
//
//  Created by JaeYeup Lee on 2014. 9. 15..
//  Copyright (c) 2014년 skoinfo. All rights reserved.
//

#import "Sub_Cell_1.h"

@implementation Sub_Cell_1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.cell1_allowImgView.image = [UIImage imageNamed:@"arrow_up"];
    }else
    {
        self.cell1_allowImgView.image = [UIImage imageNamed:@"arrow_down"];
    }
}

@end
