//
//  HSPlayerProfileViewController.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/15/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSPlayerProfileViewController.h"
#import "Team.h"
#import "GameStatLine.h"
#import "HSStatLineCell.h"
#import "HSEditPlayerViewController.h"
#import "HSPhotoManager.h"

@interface HSPlayerProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableViewTotal;
@property (weak, nonatomic) IBOutlet UITableView *tableViewAverage;

@property (nonatomic) NSNumber *fieldGoalsAttempted;
@property (nonatomic) NSNumber *fieldGoalsMade;
@property (nonatomic) NSNumber *threePointsMade;
@property (nonatomic) NSNumber *threePointsAttempted;
@property (nonatomic) NSNumber *freeThrowsMade;
@property (nonatomic) NSNumber *freeThrowsAttempted;
@property (nonatomic) NSNumber *offensiveRebounds;
@property (nonatomic) NSNumber *defensiveRebounds;
@property (nonatomic) NSNumber *assists;
@property (nonatomic) NSNumber *steals;
@property (nonatomic) NSNumber *personalFouls;
@property (nonatomic) NSNumber *turnovers;
@property (nonatomic) NSNumber *gamesPlayed;

@end

@implementation HSPlayerProfileViewController

-(void)setPlayer:(Player *)player
{
    _player = player;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshDisplay];
    [self calculateTotals];
    [self.tableViewTotal registerNib:[UINib nibWithNibName:@"HSStatLineCell" bundle:nil] forCellReuseIdentifier:@"StatLineCell"];
    [self.tableViewAverage registerNib:[UINib nibWithNibName:@"HSStatLineCell" bundle:nil] forCellReuseIdentifier:@"StatLineCell"];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatLineCell";
    HSStatLineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell) {
        if ([tableView isEqual:self.tableViewTotal]) {
            cell.statLineCellType = HSStatLineCellTypeTotal;
        } else {
            cell.statLineCellType = HSStatLineCellTypeAverage;
        }
        [self populateCell:cell];
        [cell updateDisplay];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (IBAction)editButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"editPlayer" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editPlayer"]) {
        HSEditPlayerViewController *editPlayerController = segue.destinationViewController;
        editPlayerController.player = self.player;
        editPlayerController.currentPlayerImage = self.playerImageView.image;
    }
}

-(IBAction)editCancelled:(UIStoryboardSegue*)segue
{
    //Do nothing
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)editAccepted:(UIStoryboardSegue*)segue
{
    //Make changes to team
    HSEditPlayerViewController *editPlayerController = segue.sourceViewController;
    NSString *firstName = editPlayerController.playerFistName;
    NSString *lastName = editPlayerController.playerLastName;
    NSNumber *number = editPlayerController.playerNumber;
    self.player.firstName = firstName;
    self.player.lastName = lastName;
    self.player.jerseyNumber = number;
    if (editPlayerController.imageWasChanged) {
        [self saveImage:editPlayerController.newPlayerImage];
    } else {
        [self refreshDisplay];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.moc save:nil];
}

-(void)refreshDisplay
{
    self.title = [self.player description];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.player.firstName,self.player.lastName];
    self.numberLabel.text = self.player.jerseyNumber.stringValue;
    Team *currentTeam = self.player.team;
    self.teamLabel.text = [NSString stringWithFormat:@"%@ %@",currentTeam.location, currentTeam.teamName];
    HSPhotoManager* photoManager = [HSPhotoManager sharedInstance];
    Player* player = self.player;
    dispatch_queue_t photoQueue = dispatch_queue_create("Photo Retrieval", NULL);
    dispatch_async(photoQueue, ^{
        NSData *imageData= [photoManager dataForPhotoInStorageForPlayer:self.player];
        UIImage *image = nil;
        if (!imageData) {
            // No photo for player
            image= [UIImage imageNamed:@"noImage.jpg"];
        } else {
            // There is a photo for the player
            imageData = [photoManager dataForPhotoInStorageForPlayer:self.player];
            image = [[UIImage alloc] initWithData:imageData];
        }
        //Check to make sure the user is still waiting for the image to download
        if (player == self.player) {
            // Dispatch to main thread to do UIKit work
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    self.playerImageView.image = image;
                    // Maybe adjust size
                    //self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                }
            });
        }
    });
}
                       

-(void)saveImage:(UIImage*)image;
{
    HSPhotoManager* photoManager = [HSPhotoManager sharedInstance];
    dispatch_queue_t photoSaveQueue = dispatch_queue_create("Photo Saving", NULL);
    //[self.spinner startAnimating];
    dispatch_async(photoSaveQueue, ^{
        BOOL successfulSave = [photoManager putPhotoDataInCache:UIImageJPEGRepresentation(image, 1.0f) ForPlayer:self.player];
        if (successfulSave) {
            NSLog(@"Successful Save");
        } else {
            NSLog(@"Unsuccessful Save");
        }
        dispatch_async(dispatch_get_main_queue(),^{
            if (self) {
                [self refreshDisplay];
            }
        });
    });
}

-(void)calculateTotals
{
    int fieldGoalsAttempted = 0;
    int fieldGoalsMade = 0;
    int threePointsMade = 0;
    int threePointsAttempted = 0;
    int freeThrowsMade = 0;
    int freeThrowsAttempted = 0;
    int offensiveRebounds = 0;
    int defensiveRebounds = 0;
    int assists = 0;
    int steals = 0;
    int personalFouls = 0;
    int turnovers = 0;
    int gamesPlayed = [self.player.gameStatLines count];
    for (GameStatLine *statLine in self.player.gameStatLines) {
        fieldGoalsAttempted += statLine.twoPointsAttempted.intValue + statLine.threePointsAttempted.intValue;
        fieldGoalsMade += statLine.twoPointsMade.intValue + statLine.threePointsMade.intValue;
        threePointsMade += statLine.threePointsMade.intValue;
        threePointsAttempted += statLine.threePointsAttempted.intValue;
        freeThrowsMade += statLine.onePointMade.intValue;
        freeThrowsAttempted += statLine.onePointAttempted.intValue;
        offensiveRebounds  += statLine.offensiveRebounds.intValue;
        defensiveRebounds += statLine.defensiveRebounds.intValue;
        assists += statLine.assists.intValue;
        steals += statLine.steals.intValue;
        personalFouls += statLine.fouls.intValue;
        turnovers += statLine.turnovers.intValue;
    }
    self.fieldGoalsAttempted = @(fieldGoalsAttempted);
    self.fieldGoalsMade = @(fieldGoalsMade);
    self.threePointsAttempted = @(threePointsAttempted);
    self.threePointsMade = @(threePointsMade);
    self.freeThrowsAttempted = @(threePointsAttempted);
    self.freeThrowsMade = @(threePointsMade);
    self.offensiveRebounds = @(offensiveRebounds);
    self.defensiveRebounds = @(defensiveRebounds);
    self.assists = @(assists);
    self.steals = @(steals);
    self.personalFouls = @(personalFouls);
    self.turnovers = @(turnovers);
    self.gamesPlayed = @(gamesPlayed);
}

-(void)populateCell:(HSStatLineCell*)cell
{
    cell.fieldGoalsAttempted = self.fieldGoalsAttempted;
    cell.fieldGoalsMade = self.fieldGoalsMade;
    cell.threePointersAttempted = self.threePointsAttempted;
    cell.threePointersMade = self.threePointsMade;
    cell.freeThrowsAttempted = self.freeThrowsAttempted;
    cell.freeThrowsMade = self.freeThrowsMade;
    cell.offensiveRebounds = self.offensiveRebounds;
    cell.defensiveRebounds = self.defensiveRebounds;
    cell.assists = self.assists;
    cell.steals = self.steals;
    cell.personalFouls = self.personalFouls;
    cell.turnovers = self.turnovers;
    cell.gamesPlayed = self.gamesPlayed;
}


@end
