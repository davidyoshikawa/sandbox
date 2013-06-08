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

@synthesize weightEntry, runningWeightRecord, weightList;


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
    weightList = [[NSArray alloc] initWithObjects:@"150",@"151",@"152",@"153",@"154", @"155", nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeLabel:(id)sender {
    NSString *message = [[NSString alloc] initWithFormat:@"Your weight is %@ pounds.", [weightEntry text]];
    NSString *path = @"runningWeightRecord.txt";
    [message writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    [runningWeightRecord setText:message];
    [weightEntry resignFirstResponder];
}

- (IBAction)dismissKeyboard:(id)sender {
    
    [weightEntry resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [weightEntry resignFirstResponder];
    return YES;
}

@end
