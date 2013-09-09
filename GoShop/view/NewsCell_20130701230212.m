//
//  NewsCell.m
//  GoShop
//
//  Created by iwinad2 on 13-6-26.
//  Copyright (c) 2013年 CTZ. All rights reserved.
//

#import "NewsCell.h"
#import "Theme.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@implementation NewsCell

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
    self.bgView.backgroundColor=[Theme getColorWithRed:0 green:212 blue:236 alpha:1]; //[UIColor whiteColor];//[Theme getRandomColor];
    self.bgView.layer.cornerRadius=2;
    self.bgView.layer.shouldRasterize=YES;
//    self.contentView.alpha=0;
}
-(void)showImage:(NSString *)url{
    [self.headerImage setImageWithURL:[NSURL URLWithString:url]];
}
-(void)showAnimation{
//    CGAffineTransform transformScale = CGAffineTransformMakeScale(1.5, 1.5);
//    CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(self.cellZoomXOffset.floatValue, self.cellZoomYOffset.floatValue);
    
//    cell.contentView.transform = CGAffineTransformConcat(transformScale, transformTranslate);
//    self.contentView.transform=transformScale;
//    self.contentView.layer.shouldRasterize=YES;
//    [UIView animateWithDuration:0.9 animations:^(void){
//        self.contentView.alpha=1;
//        self.contentView.transform=CGAffineTransformIdentity;
//    }];
}

@end
