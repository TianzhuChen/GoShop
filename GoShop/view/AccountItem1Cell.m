//
//  AccountItem1Cell.m
//  GoShop
//
//  Created by iwinad2 on 13-6-27.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "AccountItem1Cell.h"
#import <QuartzCore/QuartzCore.h>

@implementation AccountItem1Cell

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
-(void)awakeFromNib{
    self.bgView.layer.cornerRadius=2;
//    UIGraphicsBeginImageContext(CGSizeMake(100, 100));
//    CGContextRef ref=UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(ref, [UIColor redColor].CGColor);
//    CGContextAddRect(ref, CGRectMake(0, 0, 100, 100));
//    CGContextFillPath(ref);
//    CGContextSetFillColorWithColor(ref, [[UIColor greenColor] colorWithAlphaComponent:0.5].CGColor);
//    CGContextAddEllipseInRect(ref, CGRectMake(0, 0, 40, 40));
//    CGContextFillPath(ref);
//    
//    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
//    CGContextFillPath(ref);
//    
//    UIImageView *imgv=[[UIImageView alloc] initWithImage:img];
//    [self addSubview:imgv];
}
@end
