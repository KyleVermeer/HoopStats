//
//  HSSelectOpposingTeamViewController.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/14/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSSelectOpposingTeamViewController.h"
#import "HSDatabase.h"

@interface HSSelectOpposingTeamViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *allTeamsArray;
@property (weak, nonatomic) NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic ,readwrite) Team *selectedTeam;

@end

@implementation HSSelectOpposingTeamViewController

-(void)setMoc:(NSManagedObjectContext *)moc
{
    self.allTeamsArray = [Team allTeamsInManagedObjectContext:moc];
}

-(void)setAllTeamsArray:(NSArray *)allTeamsArray
{
    NSMutableArray *array = [allTeamsArray mutableCopy];
    [array removeObject:self.originalTeam];
    _allTeamsArray = [NSArray arrayWithArray:array]; //Remove current team
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[HSDatabase sharedInstance] performWithDocument:^(UIManagedDocument *document) {
        self.moc = document.managedObjectContext;
    }];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Team Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if( [self.allTeamsArray[indexPath.row] isKindOfClass:[Team class]] ) {
        Team* team = self.allTeamsArray[indexPath.row];
        if ([team.location length] == 0) {
            cell.textLabel.text = team.teamName;
        } else {
            cell.textLabel.text = [[team.location stringByAppendingString:@" "] stringByAppendingString:team.teamName];
        }
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allTeamsArray count];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        self.selectedTeam = self.allTeamsArray[indexPath.row];
    }
}

@end
