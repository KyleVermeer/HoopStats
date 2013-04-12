//
//  HSGameListViewController.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/16/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSGameListViewController.h"
#import "Game+Create.h"
#import "HSReviewGameViewController.h"
#import "HSGameCell.h"

#define GAME_SELECTED_SEGUE @"gameSelected"

@interface HSGameListViewController ()

@property (strong, nonatomic) NSArray *gamesArray;

@end

@implementation HSGameListViewController

-(void)setTeam:(Team *)team
{
    _team = team;
    // Sort games array by date
    self.gamesArray = [[team.games allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Game *game1 = (Game*)obj1;
        Game *game2 = (Game*)obj2;
        // Hack to allow earlier games to be displayed first
        // NSComparisonResults are enums from -1 to 1.
        return [game1.date compare:game2.date]*-1;
    }];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:GAME_CELL_NIB bundle:nil] forCellReuseIdentifier:GAME_CELL_IDENTIFIER];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.gamesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = GAME_CELL_IDENTIFIER;
    HSGameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Game *game = [self.gamesArray objectAtIndex:indexPath.row];
    if (cell) {
        NSArray *teams = [game.teams allObjects];
        Team *firstTeam = teams[0];
        Team *secondTeam = teams[1];
        cell.homeTeamLabel.text = [firstTeam description];
        cell.awayTeamLabel.text = [secondTeam description];
        cell.timeLabel.text = [game.date description];
    }
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:GAME_SELECTED_SEGUE]) {
        HSReviewGameViewController *gameReviewController = segue.destinationViewController;
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            gameReviewController.game = [self.gamesArray objectAtIndex:indexPath.row];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:GAME_SELECTED_SEGUE sender:[tableView cellForRowAtIndexPath:indexPath]];
}

@end
