//
//  ViewController.m
//  ProtoFileIO
//
//  Created by David Yoshikawa on 6/13/13.
//  Copyright (c) 2013 david. All rights reserved.
//

#import "ViewController.h"

// Constants used to identify plist-related data.
NSString * const kDataPlistName           = @"data";
NSString * const kDataPlistType           = @"plist";
NSString * const kFavThingsDateFormat     = @"dd MMM hh:mm a";
NSString * const kFavThingsKey            = @"favThings";
NSString * const kTestFieldKey            = @"testField";
NSString * const kTestFieldValue          = @"cool";

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
    if ((_dataDictionaryPath = [vcBundle pathForResource:kDataPlistName ofType:kDataPlistType]))  {
        _dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:_dataDictionaryPath];
    }
    
    // Test for data from the plist.
    NSString *testField = [_dataDictionary objectForKey:kTestFieldKey];
    if (![kTestFieldValue isEqualToString:testField]) {
        UIAlertView *testFieldAlert = [[UIAlertView alloc]
                                       initWithTitle:[[NSString alloc] initWithFormat:@"%@.%@", kDataPlistName, kDataPlistType]
                                       message:@"Failed to find the 'testField' in our plist"
                                       delegate:nil
                                       cancelButtonTitle:@"Okay"
                                       otherButtonTitles:nil];
        [testFieldAlert show];
    }
    
    NSLog(@"Found: %@", testField);
    
    // Initialize and show current history (from plist).
    _favThings = [_dataDictionary objectForKey:kFavThingsKey];
    NSLog(@"Favorite things (%d favThings) loaded from data dictionary.", (!_favThings ? 0 : [_favThings count]));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateLabel:(id)sender {

    /**
     * Updating the label(s) to demonstrate use of plist as a persistance mechanism.
     *
     * - Get submitted text from the text field.
     * - Get date from the picker (and format).
     * - Create a nice string to display and store.
     * - Get text from the plist (show history before updating).
     * - Save new text into the plist (in array) for view on next update.
     */
    NSString *submittedText = [_textField text];

    // Add date from picker to the submitted text (default local settings unless you uncomment GMT formatting below).
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kFavThingsDateFormat];
    // GMT // [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *dateString = [dateFormatter stringFromDate:[_datePicker date]];
    NSString *datedLabel = [[NSString alloc] initWithFormat:@"%@ '%@'", dateString, submittedText];
    
    // Show submitted text (upper label).
    [_label setText:[[NSString alloc] initWithFormat:@"New: %@", datedLabel]];
    
    // Show history of text (lower label) gathered from the plist.
    NSString *favThingsForDisplay = [_favThings componentsJoinedByString:@"\n"];
    [_textView setText:favThingsForDisplay];
    
    // Persist the label text to the dictionary (newest entries at the front).
    [_favThings insertObject:datedLabel atIndex:0];
    [_dataDictionary setObject:_favThings forKey:kFavThingsKey];
    [_dataDictionary writeToFile: _dataDictionaryPath atomically:YES];

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
