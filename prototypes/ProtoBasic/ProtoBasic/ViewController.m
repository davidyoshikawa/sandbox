//
//  ViewController.m
//  ProtoBasic
//
//  Created by David Yoshikawa on 6/9/13.
//  Copyright (c) 2013 david. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateLabel:(id)sender {
    NSString *labelText = [[NSString alloc] initWithFormat:@"Hi %@", [_textField text]];
    [_label setText:labelText];
    
    // Dismiss the keyboard (on 'submit' button touch)
    [_textField resignFirstResponder];
}

- (IBAction)dismissKeyboard:(id)sender {
    // Dismiss the keyboard (on off-target touch via custom button in background)
    [_textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Dismiss the keyboard (on 'return' button touch - as delegate behavior) - NOTE: electing to use method-specific parameter
    [textField resignFirstResponder];
    
    // Update label (on 'return' button touch - with delegate reported parameter)
    [self updateLabel:textField];
    
    return YES;
}

@end
