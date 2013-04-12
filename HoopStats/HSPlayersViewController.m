//
//  HSPlayersViewController.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/14/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSPlayersViewController.h"
#import "HSEditPlayerViewController.h"
#import "HSPlayerProfileViewController.h"
#import "HSDatabase.h"
#import "HSPlayerCell.h"
#import "Player+Create.h"

@interface HSPlayersViewController ()

@property (weak, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) NSArray *playersArray;

@end

#define PLAYER_CELL_NIB @"HSPlayerCell"
#define PLAYER_CELL_REUSE_IDENTIFIER @"PlayerCell"
#define PLAYER_CELL_SEGUE @"playerSelected"

@implementation HSPlayersViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [[HSDatabase sharedInstance] performWithDocument:^(UIManagedDocument *document) {
        self.moc = document.managedObjectContext;
    }];
    [self.tableView registerNib:[UINib nibWithNibName:PLAYER_CELL_NIB bundle:nil] forCellReuseIdentifier:PLAYER_CELL_REUSE_IDENTIFIER];
}

-(void)setTeam:(Team *)team
{
    _team = team;
    // Sort players by number
    self.playersArray = [[team.players allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Player *player1 = (Player*)obj1;
        Player *player2 = (Player*)obj2;
        if (player1.jerseyNumber.intValue < player2.jerseyNumber.intValue) {
            return NSOrderedAscending;
        } else if (player1.jerseyNumber.intValue == player2.jerseyNumber.intValue) {
            return NSOrderedSame;
        } else return NSOrderedDescending;
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.playersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = PLAYER_CELL_REUSE_IDENTIFIER;
    HSPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Player *player = [self.playersArray objectAtIndex:indexPath.row];
    if (cell) {
        cell.numberLabel.text = player.jerseyNumber.stringValue;
        cell.nameLabel.text = player.fullName;
    }
    
    return cell;
}

- (IBAction)addButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"addPlayer" sender:self];
}

-(IBAction)addCancelled:(UIStoryboardSegue*)segue
{
    //Do nothing
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)addAccepted:(UIStoryboardSegue*)segue
{
    //Make changes to team
    HSEditPlayerViewController *editPlayerController = segue.sourceViewController;
    NSString *firstName = editPlayerController.playerFistName;
    NSString *lastName = editPlayerController.playerLastName;
    NSNumber *number = editPlayerController.playerNumber;
    Player *newPlayer = [Player playerWithFirstName:firstName lastName:lastName number:number inManagedObjectContext:self.moc];
    [self.team addPlayersObject:newPlayer];
    //Refresh playersData
    self.playersArray = [self.team.players allObjects];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:PLAYER_CELL_SEGUE sender:[tableView cellForRowAtIndexPath:indexPath]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"playerSelected"]) {
        HSPlayerProfileViewController *playerProfileController = segue.destinationViewController;
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            Player *player = [self.playersArray objectAtIndex:indexPath.row];
            playerProfileController.player = player;
            playerProfileController.moc= self.moc;
        }
    }
}

@end
