//
//  HSPlayerProfileViewController.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/15/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface HSPlayerProfileViewController : UIViewController

@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) NSManagedObjectContext *moc;

@end
