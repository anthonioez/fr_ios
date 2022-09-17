//
//  MapItem.m
//  FRiOS
//
//  Created by Anthonio Ez on 11/4/15.
//  Copyright (c) 2015 Anthonio Ez. All rights reserved.
//

#import "MapItem.h"

@implementation MapItem

-(id) init
{
    self = [super init];
    if (self)
    {
        self.title = nil;
        self.desc = nil;
        self.latitude = 0;
        self.longitude = 0;
    }
    return(self);
}
@end
