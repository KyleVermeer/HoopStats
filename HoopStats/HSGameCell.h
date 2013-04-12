//
//  HSGameCell.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/28/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSGameCell : UITableViewCell

#define GAME_CELL_NIB @"HSGameCell"
#define GAME_CELL_IDENTIFIER @"GameCell"

@property (strong, nonatomic) IBOutlet UILabel *homeTeamLabel;
@property (strong, nonatomic) IBOutlet UILabel *awayTeamLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
