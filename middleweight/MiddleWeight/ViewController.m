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

@synthesize weightEntry, recentWeightEntry, weightList, dataDictionaryPath, dataDictionary;


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    return [weightList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component; {
    return [weightList objectAtIndex:row];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Get reference to this view controller's bundle.
    NSBundle *vcBundle = [NSBundle bundleForClass:[self class]];
    //Get (with the bundle) the path to the plist.
    if ((dataDictionaryPath = [vcBundle pathForResource:@"data" ofType:@"plist"])) {
        
        //Initialize the dictionary with the data in the plist.
        dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:dataDictionaryPath];
        
    }
    
    //Test for data from the plist.
    NSString *testField = [dataDictionary objectForKey:@"weight1"];
    if (![@"199" isEqualToString:testField]) {
        
        UIAlertView *testFieldAlert = [[UIAlertView alloc] initWithTitle:@"data.plist"
            message:@"Failed to find the 'testField' in the plist" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [testFieldAlert show];
        
    }
    
    //Populate the weightHistory label from the pfile. - Still working on a better representation of the data.
    [_weightHistory setText:[dataDictionary descriptionInStringsFileFormat]];
    
    weightList = [[NSArray alloc] initWithObjects:@"150",@"151",@"152",@"153",@"154", @"155", nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateLabel:(id)sender {
    
    //Create and format (recent) label display message.
    NSString *message = [[NSString alloc] initWithFormat:@"Your weight is %@ pounds.", [weightEntry text]];
    
    //Change the (recent) label to match current input.
    [recentWeightEntry setText:message];
    
    //Update the (history) label directly from plist.
    [_weightHistory setText:[[NSString alloc] initWithFormat:@"Old: %@", [dataDictionary objectForKey:@"weight4"]]];
    
    //Persist the label text to the dictionary.
    [dataDictionary setObject:message forKey:@"weight4"];
    [dataDictionary writeToFile:dataDictionaryPath atomically:YES];
    NSLog(@"Wrote: %@", [dataDictionary objectForKey:@"weight4"]);
    
    //Dismiss the keyboard (on 'submit' button touch)
    [weightEntry resignFirstResponder];
}

- (IBAction)dismissKeyboard:(id)sender {
    
    //Dismiss the keyboard (on off-target touch via custom button in background)
    [weightEntry resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //Dismiss the keyboard (on 'return' button touch - as delegate behavior)
    [weightEntry resignFirstResponder];
    
    //Update label (on 'return' button touch - with delegate reported parameter)
    [self updateLabel:weightEntry];
    
    return YES;
}

@end
