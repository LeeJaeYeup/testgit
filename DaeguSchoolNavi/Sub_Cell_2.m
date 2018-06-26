//
//  Tab3_Cell_2.m
//  DynamicBUSAN_F
//
//  Created by JaeYeup Lee on 2014. 9. 15..
//  Copyright (c) 2014년 skoinfo. All rights reserved.
//

#import "Sub_Cell_2.h"

@implementation Sub_Cell_2

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

- (IBAction)testBtn:(id)sender {

//    self.treeNode.isExpanded = !self.treeNode.isExpanded;
    [self setSelected:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ProjectTreeNodeButtonClicked" object:self];
}

- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage
{
    [self.testBtnOutlet setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
}

@end
