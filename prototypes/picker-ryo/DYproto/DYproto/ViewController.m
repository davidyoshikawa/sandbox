//
//  ViewController.m
//  DYproto
//
//  Created by David Yoshikawa on 6/16/13.
//  Copyright (c) 2013 medolarksoftware. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateLabel:(id)sender {
    // Update label ('update' button touched).
    [_label setText:[_textField text]];
    
    // Dismiss keyboard ('update' button touched).
    [_textField resignFirstResponder];
}

- (IBAction)dismissKeyboard:(id)sender {
    // Dismiss keyboard ('hidden' button touched).
    [_textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Update label ('return' button touched as UITextFieldDelegate).
    [self updateLabel:textField];
    
    return YES;
}

@end
