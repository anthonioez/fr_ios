//
//  FeedViewCell.h
//  FRiOS
//
//  Created by Anthonio Ez on 8/9/15.
//  Copyright (c) 2015 FRiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
