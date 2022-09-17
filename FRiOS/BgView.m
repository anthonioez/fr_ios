//
//  BgView.m
//  FRiOS
//
//  Created by Anthonio Ez on 11/4/15.
//  Copyright (c) 2015 Anthonio Ez. All rights reserved.
//

#import "BgView.h"

@implementation BgView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetRGBFillColor(context, 44/255.0, 36/255.0, 142/255.0, 1.0);   //this is the transparent color
    CGContextFillRect(context, rect);
}

@end
