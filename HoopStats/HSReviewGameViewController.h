//
//  HSReviewGameViewController.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/16/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface HSReviewGameViewController : UIViewController

@property (weak, nonatomic) Game *game;
@property (weak, nonatomic) Team *homeTeam;
@property (weak, nonatomic) Team *awayTeam;

@end
