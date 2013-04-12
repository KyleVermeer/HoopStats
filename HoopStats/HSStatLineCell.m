//
//  HSStatLineCell.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/15/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSStatLineCell.h"
#import "GameStatLine.h"

@interface HSStatLineCell()

@property (strong, nonatomic) IBOutlet UILabel *GPLabel;
@property (weak, nonatomic) IBOutlet UILabel *FGAFGMLabel;
@property (weak, nonatomic) IBOutlet UILabel *FGPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *ThreePAThreePMLabel;
@property (weak, nonatomic) IBOutlet UILabel *ThreePercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *FTAFTMLabel;
@property (weak, nonatomic) IBOutlet UILabel *FTPLabel;
@property (weak, nonatomic) IBOutlet UILabel *ORLabel;
@property (weak, nonatomic) IBOutlet UILabel *DRLabel;
@property (weak, nonatomic) IBOutlet UILabel *REBLabel;
@property (weak, nonatomic) IBOutlet UILabel *ASTLabel;
@property (weak, nonatomic) IBOutlet UILabel *STLLabel;
@property (weak, nonatomic) IBOutlet UILabel *PFLabel;
@property (weak, nonatomic) IBOutlet UILabel *TOLabel;
@property (weak, nonatomic) IBOutlet UILabel *PTSLabel;

@end

@implementation HSStatLineCell

-(void)updateDisplay
{
    if (self.statLineCellType == HSStatLineCellTypeTotal) {
        [self displayTotals];
    } else if (self.statLineCellType == HSStatLineCellTypeAverage) {
        [self displayAverages];
    }
}

-(void)displayTotals
{
    int twoPointersMade = self.fieldGoalsMade.intValue - self.threePointersMade.intValue;
    self.PTSLabel.text = [NSString stringWithFormat:@"%d",self.freeThrowsMade.intValue + twoPointersMade*2 + self.threePointersMade.intValue*3];
    self.GPLabel.text = [NSString stringWithFormat:@"%d", self.gamesPlayed.intValue];
    self.FGAFGMLabel.text = [NSString stringWithFormat:@"%d-%d", self.fieldGoalsMade.intValue,self.fieldGoalsAttempted.intValue];
    self.FGPercentLabel.text = [NSString stringWithFormat:@"%.1f%%",100.0f*self.fieldGoalsMade.floatValue/MAX(self.fieldGoalsAttempted.intValue,1)];
    self.ThreePAThreePMLabel.text = [NSString stringWithFormat:@"%d-%d", self.threePointersMade.intValue,self.threePointersAttempted.intValue];
    self.ThreePercentLabel.text = [NSString stringWithFormat:@"%.1f%%",100.0f*self.threePointersMade.floatValue/MAX(self.threePointersAttempted.intValue,1)];
    self.FTAFTMLabel.text = [NSString stringWithFormat:@"%d-%d", self.freeThrowsMade.intValue, self.freeThrowsAttempted.intValue];
    self.FTPLabel.text = [NSString stringWithFormat:@"%.1f%%", 100.0f *self.freeThrowsMade.floatValue/MAX(self.freeThrowsAttempted.intValue,1)];
    self.ORLabel.text = [NSString stringWithFormat:@"%d",self.offensiveRebounds.intValue];
    self.DRLabel.text = [NSString stringWithFormat:@"%d",self.defensiveRebounds.intValue];
    self.REBLabel.text = [NSString stringWithFormat:@"%d",self.offensiveRebounds.intValue + self.defensiveRebounds.intValue];
    self.ASTLabel.text = [NSString stringWithFormat:@"%d",self.assists.intValue];
    self.STLLabel.text = [NSString stringWithFormat:@"%d",self.steals.intValue];
    self.PFLabel.text = [NSString stringWithFormat:@"%d",self.personalFouls.intValue];
    self.TOLabel.text = [NSString stringWithFormat:@"%d",self.turnovers.intValue];
}

-(void)displayAverages
{
    int gamesPlayedValue = self.gamesPlayed.intValue;
    int twoPointersMade = self.fieldGoalsMade.intValue - self.threePointersMade.intValue;
    int totalCareerPoints = self.freeThrowsMade.intValue + twoPointersMade*2 + self.threePointersMade.intValue*3;
    self.PTSLabel.text = [NSString stringWithFormat:@"%.1f",totalCareerPoints/self.gamesPlayed.floatValue];
    self.GPLabel.text = [NSString stringWithFormat:@"%d", self.gamesPlayed.intValue];
    self.FGAFGMLabel.text = [NSString stringWithFormat:@"%.1f-%.1f", self.fieldGoalsMade.floatValue/gamesPlayedValue,self.fieldGoalsAttempted.floatValue/gamesPlayedValue];
    self.FGPercentLabel.text = [NSString stringWithFormat:@"%.1f%%",100.0f*self.fieldGoalsMade.floatValue/MAX(self.fieldGoalsAttempted.intValue,1)];
    self.ThreePAThreePMLabel.text = [NSString stringWithFormat:@"%.1f-%.1f", self.threePointersMade.floatValue/gamesPlayedValue,self.threePointersAttempted.floatValue/gamesPlayedValue];
    self.ThreePercentLabel.text = [NSString stringWithFormat:@"%.1f%%",100.0f*self.threePointersMade.floatValue/MAX(self.threePointersAttempted.intValue,1)];
    self.FTAFTMLabel.text = [NSString stringWithFormat:@"%.1f-%.1f", self.freeThrowsMade.floatValue/gamesPlayedValue, self.freeThrowsAttempted.floatValue/gamesPlayedValue];
    self.FTPLabel.text = [NSString stringWithFormat:@"%.1f%%", 100.0f *self.freeThrowsMade.floatValue/MAX(self.freeThrowsAttempted.intValue,1)];
    self.ORLabel.text = [NSString stringWithFormat:@"%.1f",self.offensiveRebounds.floatValue/gamesPlayedValue];
    self.DRLabel.text = [NSString stringWithFormat:@"%.1f",self.defensiveRebounds.floatValue/gamesPlayedValue];
    self.REBLabel.text = [NSString stringWithFormat:@"%.1f",(self.offensiveRebounds.floatValue + self.defensiveRebounds.floatValue)/gamesPlayedValue];
    self.ASTLabel.text = [NSString stringWithFormat:@"%.1f",self.assists.floatValue/gamesPlayedValue];
    self.STLLabel.text = [NSString stringWithFormat:@"%.1f",self.steals.floatValue/gamesPlayedValue];
    self.PFLabel.text = [NSString stringWithFormat:@"%.1f",self.personalFouls.floatValue/gamesPlayedValue];
    self.TOLabel.text = [NSString stringWithFormat:@"%.1f",self.turnovers.floatValue/gamesPlayedValue];
}

@end
