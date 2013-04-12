//
//  HSEditTeamViewController.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/14/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSEditTeamViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HSEditTeamViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *teamNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *teamLocationTextField;
@property (weak, nonatomic) UITextField *currentTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

@end

@implementation HSEditTeamViewController

-(NSString*)teamName
{
    return self.teamNameTextField.text;
}

-(NSString*)teamLocation
{
    return self.teamLocationTextField.text;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
	self.teamNameTextField.text = self.team.teamName;
    self.teamLocationTextField.text = self.team.location;
}

-(void)viewDidLayoutSubviews
{
    self.confirmButton.backgroundColor = [UIColor colorWithRed:0.0f green:164.0f/255.0f blue:0.0f alpha:1.0f];

    self.confirmButton.layer.cornerRadius = 10.0f;
    self.dismissButton.backgroundColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
    self.dismissButton.layer.cornerRadius = 10.0f;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentTextField = nil;
}

- (IBAction)doneButtonPressed {
    [self dismissKeyboard];
    self.team.teamName = self.teamNameTextField.text;
    self.team.location = self.teamLocationTextField.text;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed {
    [self dismissKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES]; 
}

@end
