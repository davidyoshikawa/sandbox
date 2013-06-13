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
    NSBundle *vcBundle = [NSBundle bundleForClass:[self class]];
    if ((_dataDictionaryPath = [vcBundle pathForResource:@"data" ofType:@"plist"]))  {
        _dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:_dataDictionaryPath];
    }
    
    // Test for data from the plist.
    NSString *testField = [_dataDictionary objectForKey:@"testField"];
    if (![@"cool" isEqualToString:testField]) {
        UIAlertView *testFieldAlert = [[UIAlertView alloc]
                                       initWithTitle:@"data.plist"
                                       message:@"Failed to find the 'testField' in our plist"
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

    /**
     * Updating the label(s) to demonstrate use of plist as a
     * persistance mechanism.
     *
     * - Get label text from the text field (through submit).
     * - Get date from the picker (and format).
     * - Create a nice string to display and store.
     * - Get text from the plist (show before updating).
     * - Save new text into the plist for view on next update.
     */
    NSString *labelText = [_textField text];

    // Add date from picker to the label text (in GMT).
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM hh:mm a"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *dateString = [dateFormat stringFromDate:[_datePicker date]];
    NSString *datedLabel = [[NSString alloc] initWithFormat:@"%@ '%@'", dateString, labelText];
    
    // Show upper (new) label directly from submitted text.
    [_label setText:[[NSString alloc] initWithFormat:@"New: %@", datedLabel]];
    
    // Update lower (old) label directly from plist.
    [_labelFromPlist setText:[[NSString alloc] initWithFormat:@"Old: %@", [_dataDictionary objectForKey:@"labelText"]]];
    
    // Persist the label text to the dictionary.
    [_dataDictionary setObject:datedLabel forKey:@"labelText"];
    [_dataDictionary writeToFile: _dataDictionaryPath atomically:YES];
    NSLog(@"Wrote: %@", [_dataDictionary objectForKey:@"labelText"]);

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
