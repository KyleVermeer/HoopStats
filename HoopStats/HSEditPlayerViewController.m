//
//  HSEditPlayerViewController.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/14/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSEditPlayerViewController.h"

@interface HSEditPlayerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UITextField *playerFirstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *playerLastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *playerNumberTextField;
@property (strong, nonatomic) UIPopoverController *popover;

@property (nonatomic, readwrite) BOOL imageWasChanged;

@end

@implementation HSEditPlayerViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
	if (self.player) {
        self.playerFirstNameTextField.text = self.player.firstName;
        self.playerLastNameTextField.text = self.player.lastName;
        self.playerNumberTextField.text = self.player.jerseyNumber.stringValue;
        if (self.currentPlayerImage) {
            self.playerImageView.image = self.currentPlayerImage;
        }
    }
    self.imageWasChanged = NO;
}
- (IBAction)changePhotoButtonPressed:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

}

-(NSString*)playerFistName
{
    return self.playerFirstNameTextField.text;
}

-(NSString*)playerLastName
{
    return self.playerLastNameTextField.text;
}

-(NSNumber*)playerNumber
{
    NSString *numberString = self.playerNumberTextField.text;
    return @(numberString.intValue);
}

-(UIImage*)newPlayerImage
{
    return self.playerImageView.image;
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.playerImageView.image = image;
    [self.popover dismissPopoverAnimated:YES];
    self.imageWasChanged = YES;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.popover dismissPopoverAnimated:YES];
}


@end
