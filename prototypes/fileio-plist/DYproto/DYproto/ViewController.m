//
//  ViewController.m
//  DYproto
//
//  Created by David Yoshikawa on 6/16/13.
//  Copyright (c) 2013 medolarksoftware. All rights reserved.
//

#import "ViewController.h"

// Constants used to identify plist-related data.
NSString * const kDataPlistName           = @"data";
NSString * const kDataPlistType           = @"plist";
NSString * const kFavThingsDateFormat     = @"dd MMM hh:mm a";
NSString * const kFavThingsKey            = @"favthings";

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

    // Initialize and show current history (from plist).
    _favThings = [_dataDictionary objectForKey:kFavThingsKey];
    NSLog(@"Initialized '%@' with %d items.", kFavThingsKey, (!_favThings ? 0 : [_favThings count]));
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
     * - Update label with submitted text.
     * - Get date from the picker (and format).
     *   -- Create a nice string to display.
     * - Store submitted text and date (as message).
     * - Update history view with plist data.
     */
    NSString *submittedText = [_textField text];

    // Update label ('update' button touched).
    [_label setText:[[NSString alloc] initWithFormat:@"Adding '%@'", submittedText]];
    
    // Add date from picker to the submitted text.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kFavThingsDateFormat];
    NSString *dateString = [dateFormatter stringFromDate:[_datePicker date]];
    NSString *datedLabel = [[NSString alloc] initWithFormat:@"%@ '%@'", dateString, submittedText];
    
    // Persist the label text to the dictionary (newest entries at the front).
    [_favThings insertObject:datedLabel atIndex:0];
    [_dataDictionary setObject:_favThings forKey:kFavThingsKey];
    [_dataDictionary writeToFile: _dataDictionaryPath atomically:YES];
    
    // Update history view gathered from the plist.
    NSString *favThingsForDisplay = [_favThings componentsJoinedByString:@"\n"];
    [_historyView setText:favThingsForDisplay];
    
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
