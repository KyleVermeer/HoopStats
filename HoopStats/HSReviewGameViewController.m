//
//  HSReviewGameViewController.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/16/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSReviewGameViewController.h"
#import "Team.h"
#import "Player.h"
#import "HSStatLineCell.h"
#import "GameStatLine.h"

#define STAT_LINE_CELL_IDENTIFIER @"StatLineCell"

@interface HSReviewGameViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *teamSelectorControl;
@property (weak, nonatomic) IBOutlet UILabel *leftTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTeamLabel;
@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
@property (weak, nonatomic) IBOutlet UILabel *leftTeamScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTeamScoreLabel;

@property (strong, nonatomic) Team *leftTeam;
@property (strong, nonatomic) Team *rightTeam;
@property (strong, nonatomic) NSArray *leftTeamPlayers;
@property (strong, nonatomic) NSArray *rightTeamPlayers;

@end

@implementation HSReviewGameViewController

-(void)setGame:(Game *)game
{
    _game = game;
    NSArray *teams = [game.teams allObjects];
    self.leftTeam = teams[0];
    self.leftTeamPlayers = [self.leftTeam.players allObjects];
    self.rightTeam = teams[1];
    self.rightTeamPlayers = [self.rightTeam.players allObjects];
}

-(void)setLeftTeamPlayers:(NSArray *)leftTeamPlayers
{
    _leftTeamPlayers = [leftTeamPlayers sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        Player *player1 = obj1;
        Player *player2 = obj2;
        if (player1.jerseyNumber.intValue < player2.jerseyNumber.intValue) {
            return NSOrderedAscending;
        } else if (player1.jerseyNumber.intValue > player2.jerseyNumber.intValue) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
}

-(void)setRightTeamPlayers:(NSArray *)rightTeamPlayers
{
    _rightTeamPlayers = [rightTeamPlayers sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        Player *player1 = obj1;
        Player *player2 = obj2;
        if (player1.jerseyNumber.intValue < player2.jerseyNumber.intValue) {
            return NSOrderedAscending;
        } else if (player1.jerseyNumber.intValue > player2.jerseyNumber.intValue) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.teamSelectorControl addTarget:self action:@selector(teamSelectorValueChanged:) forControlEvents:UIControlEventValueChanged];
	self.leftTeamLabel.text = [self.leftTeam description];
    self.rightTeamLabel.text = [self.rightTeam description];
    [self.teamSelectorControl setTitle:self.leftTeam.teamName forSegmentAtIndex:0];
    [self.teamSelectorControl setTitle:self.rightTeam.teamName forSegmentAtIndex:1];
    [self.statsTableView registerNib:[UINib nibWithNibName:@"HSStatLineCell" bundle:nil] forCellReuseIdentifier:@"StatLineCell"];
    self.titleLabel.text = [self.leftTeam.teamName stringByAppendingString:@"'s Game Stats"];
    [self displayScore];
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.teamSelectorControl.selectedSegmentIndex == 0) {
        return [self.leftTeamPlayers count];
    } else {
        return [self.rightTeamPlayers count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = STAT_LINE_CELL_IDENTIFIER;
    HSStatLineCell *cell = [self.statsTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Player *player = nil;
    if (self.teamSelectorControl.selectedSegmentIndex ==0) {
        player = [self.leftTeamPlayers objectAtIndex:indexPath.row];
    } else {
        player = [self.rightTeamPlayers objectAtIndex:indexPath.row];
    }
    if (cell) {
        [self populateCell:cell ForPlayer:player];
        [cell updateDisplay];
    }
    return cell;
}

-(GameStatLine*)gameStatLineForPlayer:(Player*)player
{
    for (GameStatLine* statLine in [player.gameStatLines allObjects]) {
        if ([statLine.game isEqual:self.game])
            return statLine;
    }
    return nil;
}

-(void)populateCell:(HSStatLineCell*)cell ForPlayer:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    cell.fieldGoalsAttempted = @(statLine.twoPointsAttempted.intValue + statLine.threePointsAttempted.intValue);
    cell.fieldGoalsMade = @(statLine.twoPointsMade.intValue + statLine.threePointsMade.intValue);
    cell.threePointersAttempted = statLine.threePointsAttempted;
    cell.threePointersMade = statLine.threePointsMade;
    cell.freeThrowsAttempted = statLine.onePointAttempted;
    cell.freeThrowsMade = statLine.onePointMade;
    cell.offensiveRebounds = statLine.offensiveRebounds;
    cell.defensiveRebounds = statLine.defensiveRebounds;
    cell.assists = statLine.assists;
    cell.steals = statLine.steals;
    cell.personalFouls = statLine.fouls;
    cell.turnovers = statLine.turnovers;
    cell.gamesPlayed = player.jerseyNumber;
    cell.statLineCellType = HSStatLineCellTypeTotal;
}

-(void)teamSelectorValueChanged:(UISegmentedControl*)sender
{
    [self.statsTableView reloadData];
    Team *currentTeam = sender.selectedSegmentIndex == 0 ? self.leftTeam : self.rightTeam;
    self.titleLabel.text = [currentTeam.teamName stringByAppendingString:@"'s Game Stats"];
}

-(void)displayScore
{
    int leftTeamScore = 0;
    int rightTeamScore = 0;
    for (GameStatLine* statLine in [self.game.gameStatLines allObjects])
    {
        int pointsForPlayer = statLine.twoPointsMade.intValue*2 + statLine.threePointsMade.intValue*3 + statLine.onePointMade.intValue;
        if ([self.leftTeamPlayers containsObject:statLine.player]) {
            leftTeamScore += pointsForPlayer;
        } else if ([self.rightTeamPlayers containsObject:statLine.player]) {
            rightTeamScore += pointsForPlayer;
        } else {
            NSLog(@"Player is on neither team... We might wanna check that out");
        }
    }
    self.leftTeamScoreLabel.text = @(leftTeamScore).stringValue;
    self.rightTeamScoreLabel.text = @(rightTeamScore).stringValue;
}

@end
