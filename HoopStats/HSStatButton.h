//
//  HSStatButton.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/7/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HSStatButtonTypeTwoPointMade,
    HSStatButtonTypeTwoPointMiss,
    HSStatButtonTypeThreePointMade,
    HSStatButtonTypeThreePointMiss,
    HSStatButtonTypeOnePointMade,
    HSStatButtonTypeOnePointMiss,
    HSStatButtonTypeOffensiveRebound,
    HSStatButtonTypeDefensiveRebound,
    HSStatButtonTypeSteal,
    HSStatButtonTypeAssist,
    HSStatButtonTurnover,
    HSStatButtonFoul
} HSStatButtonType;

@interface HSStatButton : UIButton

// Set during initialization
@property (nonatomic, readonly) HSStatButtonType HSButtonType;

// Designated initializer
-(id)initWithFrame:(CGRect)frame type:(HSStatButtonType)buttonType;

@end
