//
//  HSStatLineCell.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/15/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

typedef enum {
    HSStatLineCellTypeTotal,
    HSStatLineCellTypeAverage
} HSStatLineCellType;

@interface HSStatLineCell : UITableViewCell

@property (nonatomic) HSStatLineCellType statLineCellType;

/* For displaying on player page */
@property (strong, nonatomic) NSNumber *gamesPlayed;

/* For displaying on game page */
@property (strong, nonatomic) NSNumber *playerNumber;

/* For all displays */
@property (strong, nonatomic) NSNumber *fieldGoalsAttempted;
@property (strong, nonatomic) NSNumber *fieldGoalsMade;
@property (strong, nonatomic) NSNumber *threePointersAttempted;
@property (strong, nonatomic) NSNumber *threePointersMade;
@property (strong, nonatomic) NSNumber *freeThrowsAttempted;
@property (strong, nonatomic) NSNumber *freeThrowsMade;
@property (strong, nonatomic) NSNumber *offensiveRebounds;
@property (strong, nonatomic) NSNumber *defensiveRebounds;
@property (strong, nonatomic) NSNumber *assists;
@property (strong, nonatomic) NSNumber *steals;
@property (strong, nonatomic) NSNumber *personalFouls;
@property (strong, nonatomic) NSNumber *turnovers;


-(void)updateDisplay;

@end
