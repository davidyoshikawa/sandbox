//
//  ViewController.m
//  ProtoFileIO
//
//  Created by David Yoshikawa on 6/13/13.
//  Copyright (c) 2013 david. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    /**
     * Assign contents of 'data.plist' to a mutable dictionary (for use in persisting entries from the UI).
     *
     * - Create (through Xcode) a new plist ('data.plist')
     *   -- Create by right-clicking top level and adding new plist file to group and target of ProtoFileIO.
     *   -- Populate with data as desired (through Xcode).
     * - Get reference to this view controller's bundle.
     * - Get (with the bundle) the path to our plist.
     * - Initialize our dictionary from the plist.
     */
    NSString *path;
    
    NSBundle *vcBundle = [NSBundle bundleForClass:[self class]];
    if ((path = [vcBundle pathForResource:@"data" ofType:@"plist"]))  {
        _dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    
    // Test for data from the plist.
    NSString *testField = [_dataDictionary objectForKey:@"testfield"];
    if (![@"cool" isEqualToString:testField]) {
        UIAlertView *testFieldAlert = [[UIAlertView alloc]
                                       initWithTitle:@"data.plist"
                                       message:@"Failed to find the 'testfield' in our plist"
                                       delegate:nil
                                       cancelButtonTitle:@"Okay"
                                       otherButtonTitles:nil];
        [testFieldAlert show];
    }
    
    NSLog(@"Found: %@", [_dataDictionary objectForKey:@"testfield"]);
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
