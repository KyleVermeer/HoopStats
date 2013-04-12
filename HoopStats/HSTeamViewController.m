//
//  HSTeamViewController.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/12/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSTeamViewController.h"
#import "HSGameViewController.h"
#import "HSEditTeamViewController.h"
#import "HSSelectOpposingTeamViewController.h"
#import "HSPlayersViewController.h"
#import "HSGameListViewController.h"
#import "Game+Create.h"
#import "HSSelectOpposingTeamViewController.h"

#define SHOW_PLAYERS_SEGUE @"showPlayers"
#define CREATE_NEW_GAME_SEGUE @"createNewGame"
#define EDIT_TEAM_SEGUE @"editTeam"
#define SELECT_OPPOSING_TEAM_SEGUE @"selectOpposingTeam"
#define SHOW_GAMES_SEGUE @"showGames"

@interface HSTeamViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *playersImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gamesImageView;
@property (weak, nonatomic) IBOutlet UIImageView *makeGameImageView;

@property (strong, nonatomic) Team *opposingTeam;

@end

@implementation HSTeamViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self updateTitle];
	[self.playersImageView setImage:[UIImage imageNamed:@"playerImage.png"]];
    [self.gamesImageView setImage:[UIImage imageNamed:@"gameImage.png"]];
    [self.makeGameImageView setImage:[UIImage imageNamed:@"createGameImage.png"]];
    
    //Add Gesture Recognizers
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playersButtonTapped)];
    [self.playersImageView addGestureRecognizer:gestureRecognizer];
    UITapGestureRecognizer *gamesButtonTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gamesButtonTapped)];
    [self.gamesImageView addGestureRecognizer:gamesButtonTapped];
    UITapGestureRecognizer *createGameTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createGameButtonTapped)];
    [self.makeGameImageView addGestureRecognizer:createGameTapped];
}

-(void)playersButtonTapped
{
    [self performSegueWithIdentifier:SHOW_PLAYERS_SEGUE sender:self];
}

-(void)createGameButtonTapped
{
    [self performSegueWithIdentifier:SELECT_OPPOSING_TEAM_SEGUE sender:nil];
}

-(void)gamesButtonTapped
{
    [self performSegueWithIdentifier:SHOW_GAMES_SEGUE sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:CREATE_NEW_GAME_SEGUE]) {
        HSGameViewController *gameController = segue.destinationViewController;
        Game *game = [Game gameWithTeam:self.team againstOpponent:self.opposingTeam inManagedObjectContext:self.moc];
        gameController.game = game;
        gameController.homeTeam = self.team;
        gameController.awayTeam = self.opposingTeam;
        gameController.moc = self.moc;
    } else if ([segue.identifier isEqualToString:EDIT_TEAM_SEGUE]) {
        HSEditTeamViewController *editTeamController = segue.destinationViewController;
        editTeamController.team = self.team;
    } else if ([segue.identifier isEqualToString:SHOW_PLAYERS_SEGUE]) {
        HSPlayersViewController *playersViewController = segue.destinationViewController;
        playersViewController.team = self.team;
    } else if ([segue.identifier isEqualToString:SHOW_GAMES_SEGUE]) {
        HSGameListViewController *gameListController = segue.destinationViewController;
        gameListController.team = self.team;
    } else if ([segue.identifier isEqualToString:SELECT_OPPOSING_TEAM_SEGUE]) {
        HSSelectOpposingTeamViewController *opposingTeamController = segue.destinationViewController;
        opposingTeamController.originalTeam = self.team;
    }
}

#pragma mark Modal View Controller Unwinds

-(IBAction)editCancelled:(UIStoryboardSegue*)segue
{
    //Do nothing
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)editAccepted:(UIStoryboardSegue*)segue
{
    //Make changes to team
    HSEditTeamViewController *modalController = segue.sourceViewController;
    self.team.teamName = modalController.teamName;
    self.team.location = modalController.teamLocation;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updateTitle];
}

-(IBAction)opposingTeamSelected:(UIStoryboardSegue*)segue
{
    HSSelectOpposingTeamViewController *modalController = segue.sourceViewController;
    self.opposingTeam = modalController.selectedTeam;
    [self dismissViewControllerAnimated:YES completion:^{
       [self performSegueWithIdentifier:CREATE_NEW_GAME_SEGUE sender:self];
    }];
}

-(void)updateTitle
{
    if ([self.team.location length] == 0) {
        self.title = self.team.teamName;
    } else {
        self.title = [[self.team.location stringByAppendingString:@" "] stringByAppendingString:self.team.teamName];
    }
}


@end
