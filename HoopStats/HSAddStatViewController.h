//
//  HSAddStatViewController.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/7/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@protocol AddStatDelegate <NSObject>

-(void)twoPointMade:(Player*)player;
-(void)twoPointMissed:(Player*)player;
-(void)threePointMade:(Player*)player;
-(void)threePointMissed:(Player*)player;
-(void)onePointMade:(Player*)player;
-(void)onePointMissed:(Player*)player;
-(void)steal:(Player*)player;
-(void)assist:(Player*)player;
-(void)offensiveRebound:(Player*)player;
-(void)defensiveRebound:(Player*)player;
-(void)turnover:(Player*)player;
-(void)foul:(Player*)player;

@end

@interface HSAddStatViewController : UIViewController

@property (strong, nonatomic) id<AddStatDelegate> addStatDelegate;

-(id)initWithPlayer:(Player*)player;

@end
