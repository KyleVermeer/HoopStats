//
//  HSStatButton.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/7/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSStatButton.h"

#define STAT_BUTTON_CORNER_RADIUS 5

@interface HSStatButton()

@property (nonatomic, readwrite) HSStatButtonType HSButtonType;

@end

@implementation HSStatButton

-(id)initWithFrame:(CGRect)frame
{
    //To enforce use of designated intializer
    return nil;
}

-(id)initWithFrame:(CGRect)frame type:(HSStatButtonType)buttonType {
    self = [super initWithFrame:frame];
    if (self) {
        self.HSButtonType= buttonType;
        self.backgroundColor = [UIColor clearColor];
        [self configureImages];
    }
    return self;
}


/* Name: configureImages
 * Inputs: None
 * Returns: None
 * Description: Sets the image for the button, this should always be called upon creation of the button.
 */
-(void)configureImages
{
    switch (self.HSButtonType) {
        case HSStatButtonTypeTwoPointMade:
            [self setImage:[UIImage imageNamed:@"twoPointMade.png"] forState:UIControlStateNormal];
            break;
        case HSStatButtonTypeTwoPointMiss:
            [self setImage:[UIImage imageNamed:@"twoPointMiss.png"] forState:UIControlStateNormal];
            break;
        case HSStatButtonTypeThreePointMade:
            [self setImage:[UIImage imageNamed:@"threePointMade.png"] forState:UIControlStateNormal];
            break;
        case HSStatButtonTypeThreePointMiss:
            [self setImage:[UIImage imageNamed:@"threePointMiss.png"] forState:UIControlStateNormal];
            break;
        case HSStatButtonTypeOnePointMade:
            [self setImage:[UIImage imageNamed:@"onePointMade.png"] forState:UIControlStateNormal];
            break;
        case HSStatButtonTypeOnePointMiss:
            [self setImage:[UIImage imageNamed:@"onePointMiss.png"] forState:UIControlStateNormal];
            break;
        case HSStatButtonTypeOffensiveRebound:
            [self setImage:[UIImage imageNamed:@"offensiveRebound.png"] forState:UIControlStateNormal];
            break;
        case HSStatButtonTypeDefensiveRebound:
            [self setImage:[UIImage imageNamed:@"defensiveRebound.png"] forState:UIControlStateNormal];
            break;
        case HSStatButtonTypeSteal:
            [self setImage:[UIImage imageNamed:@"steal.png"] forState:UIControlStateNormal];
            break;
        case HSStatButtonTypeAssist:
            [self setImage:[UIImage imageNamed:@"assist.png"] forState:UIControlStateNormal];
            break;
        case HSStatButtonTurnover:
            [self setImage:[UIImage imageNamed:@"turnOver.png"] forState:UIControlStateNormal];
            break;
        case HSStatButtonFoul:
            [self setImage:[UIImage imageNamed:@"foul.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }

}
@end
