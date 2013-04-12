//
//  HSGameViewController.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/7/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSGameViewController.h"
#import "HSAddStatViewController.h"
#import "Game+Create.h"
#import "Player.h"
#import "GameStatLine+Create.h"
#import "HSPhotoManager.h"
#import "HSReviewGameViewController.h"

#define NUM_RECENT_HIGHLIGHTS 3

@interface HSGameViewController () <UITableViewDelegate, UITableViewDataSource, AddStatDelegate>

@property (strong, nonatomic) UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UITableView *RecentHighlightsTableView;
@property (strong, nonatomic) NSArray* recentHighlights;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamLabel;
@property (strong, nonatomic) NSArray *homeTeamPlayers;
@property (strong, nonatomic) NSArray *awayTeamPlayers;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamScoreLabel;

@property (weak, nonatomic) IBOutlet UIButton *homeTeamButton1;
@property (weak, nonatomic) IBOutlet UIButton *homeTeamButton2;
@property (weak, nonatomic) IBOutlet UIButton *homeTeamButton3;
@property (weak, nonatomic) IBOutlet UIButton *homeTeamButton4;
@property (weak, nonatomic) IBOutlet UIButton *homeTeamButton5;

@property (weak, nonatomic) IBOutlet UIButton *awayTeamButton1;
@property (weak, nonatomic) IBOutlet UIButton *awayTeamButton2;
@property (weak, nonatomic) IBOutlet UIButton *awayTeamButton3;
@property (weak, nonatomic) IBOutlet UIButton *awayTeamButton4;
@property (weak, nonatomic) IBOutlet UIButton *awayTeamButton5;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *homeTeamButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *awayTeamButtons;

@end

@implementation HSGameViewController



-(void)viewDidLoad
{
    self.recentHighlights = @[@"3pt made - 32 Spurs",@"Foul - 45 Timberwolves", @"Steal - 33 Spurs"];
    self.homeTeamLabel.text = self.homeTeam.teamName;
    self.awayTeamLabel.text = self.awayTeam.teamName;
    self.title = [NSString stringWithFormat:@"%@ vs %@",self.homeTeam.teamName,self.awayTeam.teamName];
    [self setUpPlayers];
    [self setUpButtons];
    [self displayScore];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSError *error = [[NSError alloc] init];
    [self.moc save:&error];
}

- (IBAction)playerButtonPushed:(UIButton *)sender
{
    Player* player = nil;
    if ([self.homeTeamButtons containsObject:sender]) {
        player = [self playerForNumber:sender.titleLabel.text.integerValue fromPlayers:self.homeTeamPlayers];
    } else if ([self.awayTeamButtons containsObject:sender]) {
        player = [self playerForNumber:sender.titleLabel.text.integerValue fromPlayers:self.awayTeamPlayers];
    } else {
        NSLog(@"Button is for neither home nor away");
    }
    HSAddStatViewController *statPopoverController = [[HSAddStatViewController alloc] initWithPlayer:player];
    statPopoverController.addStatDelegate = self;
    if (self.popover) {
        [self.popover dismissPopoverAnimated:NO];
        self.popover = nil;
    }
    self.popover = [[UIPopoverController alloc] initWithContentViewController:statPopoverController];
    self.popover.popoverContentSize = CGSizeMake(440.0, 340.0);
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight animated:YES];
}

# pragma mark UITableViewDataSource

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Recent Highlight Cell"];
    cell.textLabel.text = self.recentHighlights[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return NUM_RECENT_HIGHLIGHTS;
}

-(Player*)playerForNumber:(NSUInteger)number fromPlayers:(NSArray*)players
{
    for (Player* player in players) {
        if (player.jerseyNumber.integerValue == number) {
            return player;
        }
    }
    return nil;
}

#pragma mark AddStateDelegate

-(void)twoPointMade:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    statLine.twoPointsAttempted= @(statLine.twoPointsAttempted.integerValue+1);
    statLine.twoPointsMade= @(statLine.twoPointsMade.integerValue+1);
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [self displayScore];
}
-(void)twoPointMissed:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    statLine.twoPointsAttempted= @(statLine.twoPointsAttempted.integerValue+1);
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}
-(void)threePointMade:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    statLine.threePointsAttempted= @(statLine.threePointsAttempted.integerValue+1);
    statLine.threePointsMade= @(statLine.threePointsMade.integerValue+1);
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [self displayScore];
}
-(void)threePointMissed:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    statLine.threePointsAttempted= @(statLine.threePointsAttempted.integerValue+1);
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}
-(void)onePointMade:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    statLine.onePointAttempted= @(statLine.onePointAttempted.integerValue+1);
    statLine.onePointMade= @(statLine.onePointMade.integerValue+1);
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [self displayScore];
}
-(void)onePointMissed:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    statLine.onePointAttempted= @(statLine.onePointAttempted.integerValue+1);
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}
-(void)steal:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    statLine.steals= @(statLine.steals.integerValue+1);
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}
-(void)assist:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    statLine.assists= @(statLine.assists.integerValue+1);
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}
-(void)offensiveRebound:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    statLine.offensiveRebounds= @(statLine.offensiveRebounds.integerValue+1);
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}
-(void)defensiveRebound:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    statLine.defensiveRebounds= @(statLine.defensiveRebounds.integerValue+1);
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}
-(void)turnover:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    statLine.turnovers= @(statLine.turnovers.integerValue+1);
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}
-(void)foul:(Player*)player
{
    GameStatLine *statLine = [self gameStatLineForPlayer:player];
    statLine.fouls= @(statLine.fouls.integerValue+1);
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

-(GameStatLine*)gameStatLineForPlayer:(Player*)player
{
    for (GameStatLine *statLine in self.game.gameStatLines) {
        if ([player isEqual:statLine.player]) {
            return statLine;
        }
    }
    return nil;
}

-(void)setUpPlayers
{
    self.homeTeamPlayers = [[self.homeTeam.players allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Player *firstPlayer = (Player*)obj1;
        Player *secondPlayer = (Player*)obj2;
        if (firstPlayer.jerseyNumber.intValue > secondPlayer.jerseyNumber.intValue) {
            return NSOrderedDescending;
        } else if (firstPlayer.jerseyNumber.intValue < secondPlayer.jerseyNumber.intValue) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    
    self.awayTeamPlayers = [[self.awayTeam.players allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Player *firstPlayer = (Player*)obj1;
        Player *secondPlayer = (Player*)obj2;
        if (firstPlayer.jerseyNumber.intValue > secondPlayer.jerseyNumber.intValue) {
            return NSOrderedDescending;
        } else if (firstPlayer.jerseyNumber.intValue < secondPlayer.jerseyNumber.intValue) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];    
}

-(void)setUpButtons
{
    // Home Team Button
    [self.homeTeamButton1 setTitle:[[((Player*)[self.homeTeamPlayers objectAtIndex:0]) jerseyNumber] stringValue] forState:UIControlStateNormal];
    [self setUpButton:self.homeTeamButton1 forPlayer:[self.homeTeamPlayers objectAtIndex:0]];
    
    [self.homeTeamButton2 setTitle:[[((Player*)[self.homeTeamPlayers objectAtIndex:1]) jerseyNumber] stringValue] forState:UIControlStateNormal];
    [self setUpButton:self.homeTeamButton2 forPlayer:[self.homeTeamPlayers objectAtIndex:1]];
    
    [self.homeTeamButton3 setTitle:[[((Player*)[self.homeTeamPlayers objectAtIndex:2]) jerseyNumber] stringValue] forState:UIControlStateNormal];
    [self setUpButton:self.homeTeamButton3 forPlayer:[self.homeTeamPlayers objectAtIndex:2]];
    
    [self.homeTeamButton4 setTitle:[[((Player*)[self.homeTeamPlayers objectAtIndex:3]) jerseyNumber] stringValue] forState:UIControlStateNormal];
    [self setUpButton:self.homeTeamButton4 forPlayer:[self.homeTeamPlayers objectAtIndex:3]];
    
    [self.homeTeamButton5 setTitle:[[((Player*)[self.homeTeamPlayers objectAtIndex:4]) jerseyNumber] stringValue] forState:UIControlStateNormal];
    [self setUpButton:self.homeTeamButton5 forPlayer:[self.homeTeamPlayers objectAtIndex:4]];
    
    // Away Team Buttons
    [self.awayTeamButton1 setTitle:[[((Player*)[self.awayTeamPlayers objectAtIndex:0]) jerseyNumber] stringValue] forState:UIControlStateNormal];
    [self setUpButton:self.awayTeamButton1 forPlayer:[self.awayTeamPlayers objectAtIndex:0]];
    
    [self.awayTeamButton2 setTitle:[[((Player*)[self.awayTeamPlayers objectAtIndex:1]) jerseyNumber] stringValue] forState:UIControlStateNormal];
    [self setUpButton:self.awayTeamButton2 forPlayer:[self.awayTeamPlayers objectAtIndex:1]];
    
    [self.awayTeamButton3 setTitle:[[((Player*)[self.awayTeamPlayers objectAtIndex:2]) jerseyNumber] stringValue] forState:UIControlStateNormal];
    [self setUpButton:self.awayTeamButton3 forPlayer:[self.awayTeamPlayers objectAtIndex:2]];
    
    [self.awayTeamButton4 setTitle:[[((Player*)[self.awayTeamPlayers objectAtIndex:3]) jerseyNumber] stringValue] forState:UIControlStateNormal];
    [self setUpButton:self.awayTeamButton4 forPlayer:[self.awayTeamPlayers objectAtIndex:3]];
    
    [self.awayTeamButton5 setTitle:[[((Player*)[self.awayTeamPlayers objectAtIndex:4]) jerseyNumber] stringValue] forState:UIControlStateNormal];
    [self setUpButton:self.awayTeamButton5 forPlayer:[self.awayTeamPlayers objectAtIndex:4]];
}

-(void)displayScore
{
    int homeTeamScore = 0;
    int awayTeamScore = 0;
    for (GameStatLine* statLine in [self.game.gameStatLines allObjects])
    {
        int pointsForPlayer = statLine.twoPointsMade.intValue*2 + statLine.threePointsMade.intValue*3 + statLine.onePointMade.intValue;
        if ([self.homeTeamPlayers containsObject:statLine.player]) {
            homeTeamScore += pointsForPlayer;
        } else if ([self.awayTeamPlayers containsObject:statLine.player]) {
            awayTeamScore += pointsForPlayer;
        } else {
            NSLog(@"Player is on neither team... We might wanna check that out");
        }
    }
    self.homeTeamScoreLabel.text = @(homeTeamScore).stringValue;
    self.awayTeamScoreLabel.text = @(awayTeamScore).stringValue;
}

-(void)setUpButton:(UIButton*)button forPlayer:(Player*)player
{
    HSPhotoManager* photoManager = [HSPhotoManager sharedInstance];
    dispatch_queue_t photoQueue = dispatch_queue_create("Photo Retrieval", NULL);
    dispatch_async(photoQueue, ^{
        NSData *imageData= [photoManager dataForPhotoInStorageForPlayer:player];
        UIImage *image = nil;
        if (!imageData) {
            // No photo for player, do nothing
        } else {
            // There is a photo for the player
            image = [[UIImage alloc] initWithData:imageData];
            //Check to make sure the user is still waiting for the image to download
            if (button) {
                // Dispatch to main thread to do UIKit work
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        [button setImage:image forState:UIControlStateNormal];
                        // Maybe adjust size
                        //self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                    }
                });
            }
        }
    });
}

- (IBAction)gameOverviewButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"gameOverviewSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"gameOverviewSegue"]) {
        HSReviewGameViewController* gameOverviewController = segue.destinationViewController;
        gameOverviewController.game = self.game;
    }
}


@end
