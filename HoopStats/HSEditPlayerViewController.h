//
//  HSEditPlayerViewController.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/14/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface HSEditPlayerViewController : UIViewController

@property (strong, nonatomic) Player *player;
@property (nonatomic, readonly) NSString *playerFistName;
@property (nonatomic, readonly) NSString *playerLastName;
@property (nonatomic, readonly) NSNumber * playerNumber;
@property (strong, nonatomic) UIImage *currentPlayerImage;
@property (nonatomic, readonly) UIImage *newPlayerImage;
@property (nonatomic, readonly) BOOL imageWasChanged;

@end
