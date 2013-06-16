//
//  ViewController.m
//  MiddleWeight
//
//  Created by Jeff Worley on 6/5/13.
//  Copyright (c) 2013 Jeff Worley. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Get reference to this view controller's bundle.
    NSBundle *vcBundle = [NSBundle bundleForClass:[self class]];
    // Get (with the bundle) the path to the plist.
    if ((_dataDictionaryPath = [vcBundle pathForResource:@"data" ofType:@"plist"])) {
        
        // Initialize the dictionary with the data in the plist.
        _dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:_dataDictionaryPath];
    }
    
    // Populate the weightHistory label from the pfile.
    // TODO: Still working on a better representation of the data.
    [_weightHistory setText:[_dataDictionary descriptionInStringsFileFormat]];
    
    _pickerWeights = [[NSArray alloc] initWithObjects:@"150",@"151",@"152",@"153",@"154", @"155", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateLabel:(id)sender {
    
    // Create and format (recent) label display message.
    NSString *message = [[NSString alloc] initWithFormat:@"Weight (new): %@ lbs", [_weightEntry text]];
    [_recentWeightEntry setText:message];
    
    // Update the (history) label directly from plist.
    [_weightHistory setText:[[NSString alloc] initWithFormat:@"Weight (old): %@ lbs", [_dataDictionary objectForKey:@"weight"]]];
    
    // Persist the submitted weight to the dictionary.
    [_dataDictionary setObject:[_weightEntry text] forKey:@"weight"];
    [_dataDictionary writeToFile:_dataDictionaryPath atomically:YES];
    NSLog(@"Wrote: %@", [_dataDictionary objectForKey:@"weight"]);
    
    // Dismiss the keyboard (on 'submit' button touch)
    [_weightEntry resignFirstResponder];
}

- (IBAction)dismissKeyboard:(id)sender {
    
    // Dismiss the keyboard (on off-target touch via custom button in background)
    [_weightEntry resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Dismiss the keyboard (on 'return' button touch - as delegate behavior)
    [textField resignFirstResponder];
    
    // Update label (on 'return' button touch - with delegate reported parameter)
    [self updateLabel:textField];
    
    return YES;
}

/** *********** Methods supporting the weight picker *********** */

// Returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}

// Returns the # of rows in each component.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    return [_pickerWeights count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component; {
    return [_pickerWeights objectAtIndex:row];
}

@end
