//
//  FeedItem.m
//  FRiOS
//
//  Created by Anthonio Ez on 11/4/15.
//  Copyright (c) 2015 Anthonio Ez. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem

-(id) init
{
    self = [super init];
    if (self)
    {
        self.title = nil;
        self.content = nil;
    }
    return(self);
}
@end
