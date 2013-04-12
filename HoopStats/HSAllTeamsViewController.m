//
//  HSAllTeamsViewController.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/12/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSAllTeamsViewController.h"
#import "HSDatabase.h"
#import "Team+Create.h"
#import "HSTeamViewController.h"

@interface HSAllTeamsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation HSAllTeamsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl beginRefreshing];
    [[HSDatabase sharedInstance] performWithDocument:^(UIManagedDocument *document) {
        self.moc = document.managedObjectContext;
        [self.refreshControl endRefreshing];
    }];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

-(void)setMoc:(NSManagedObjectContext *)moc
{
    _moc = moc;
    if (moc) {
        // Set self.fetchedResultsController
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"teamName" ascending:YES];
        request.sortDescriptors = @[sortDescriptor];
        request.predicate = nil; // All teams
        NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
        self.fetchedResultsController = fetchedResultsController;
    } else {
        self.fetchedResultsController = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Team Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if( [[self.fetchedResultsController objectAtIndexPath:indexPath] isKindOfClass:[Team class]] ) {
        Team* team = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if ([team.location length] == 0) {
            cell.textLabel.text = team.teamName;
        } else {
            cell.textLabel.text = [[team.location stringByAppendingString:@" "] stringByAppendingString:team.teamName];
        }
    }
    return cell;
}

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender {
    [Team teamWithName:@"New Team" location:@"" inManagedObjectContext:self.moc];
    [self.moc save:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"teamSelected"]) {
        UITableViewCell *cell = [sender isKindOfClass:[UITableViewCell class]] ? sender : nil;
        NSIndexPath *index = [self.tableView indexPathForCell:cell];
        Team* team = [self.fetchedResultsController objectAtIndexPath:index];
        HSTeamViewController *teamViewController = segue.destinationViewController;
        teamViewController.team = team;
        teamViewController.moc = self.moc;
    }
}

-(void)refresh
{
    [self.refreshControl endRefreshing];
}

@end
