//
//  ViewController.m
//  DYproto
//
//  Created by David Yoshikawa on 6/16/13.
//  Copyright (c) 2013 medolarksoftware. All rights reserved.
//

#import "ViewController.h"

// Constants used to identify plist-related data.
NSString * const kDataPlistName               = @"data";
NSString * const kDataPlistType               = @"plist";
NSString * const kDateFormat                  = @"dd MMM yyyy";
NSString * const kMinWeightKey                = @"minWeight";
NSString * const kMaxWeightKey                = @"maxWeight";
NSString * const kWeightInTenthsKey           = @"weightInTenths";
NSString * const kWeightsKey                  = @"weights";
NSString * const kDatesKey                    = @"dates";
NSString * const kStartDateKey                = @"startDate";
int        const kNumColsWeightPicker         = 2;
int        const kWeightPickerComponent       = 0;
int        const kDatePickerComponent         = 1;
int        const kWeightComponentWidth        = 100;
int        const kDateComponentWidth          = 150;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    /**
     * Initialize data dictionary with data from plist.
     */
    NSBundle *vcBundle = [NSBundle bundleForClass:[self class]];
    if ((_dataDictionaryPath = [vcBundle pathForResource:kDataPlistName ofType:kDataPlistType]))  {
        _dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:_dataDictionaryPath];
    }

    // Log data from initialization.
    _minWeight = [_dataDictionary objectForKey:kMinWeightKey];
    _maxWeight = [_dataDictionary objectForKey:kMaxWeightKey];
    _weightInTenths = [[_dataDictionary objectForKey:kWeightInTenthsKey] boolValue];
    _weights = [_dataDictionary objectForKey:kWeightsKey];
    _dates = [_dataDictionary objectForKey:kDatesKey];
    _startDate = [_dataDictionary objectForKey:kStartDateKey];

    NSLog(@"Initialized:"
          "\n  '%@' (%@)"
          "\n  '%@' (%@)"
          "\n  '%@' (%d)"
          "\n  '%@' (%d items)"
          "\n  '%@' (%@)"
          "\n  '%@' (%d items)",
          kMinWeightKey, _minWeight,
          kMaxWeightKey, _maxWeight,
          kWeightInTenthsKey, _weightInTenths,
          kWeightsKey, (!_weights ? 0 : [_weights count]),
          kStartDateKey, _startDate,
          kDatesKey, (!_dates ? 0 : [_dates count]));
    
    /**
     * Initialize the picker values.
     * -- Weights (num = (max-min) * 10 if by tenths)
     */
    _weightPickerChoices = [[NSMutableArray alloc] init];

    for (int i=[_minWeight intValue]; i<=[_maxWeight intValue]; i++) {
        [_weightPickerChoices addObject:[[NSString alloc] initWithFormat:@"%d", i]];
        
        if (_weightInTenths) {
            for (int j=1; j<10; j++) {
                [_weightPickerChoices addObject:[[NSString alloc] initWithFormat:@"%d.%d", i, j]];
            }
        }
    }

    NSLog(@"Weight picker populated from %@ to %@ %@.", _minWeight, _maxWeight, (_weightInTenths ? @"(by tenths)" : @""));

    /**
     * Initialize the picker values.
     * -- Dates (start date to now by days)
     */
    _datePickerChoices = [[NSMutableArray alloc] init];

    // Determine how many days passed from start date to today.
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger units = NSDayCalendarUnit;
    NSDate *today = [NSDate date];
    NSDateComponents *components = [gregorian components:units fromDate:_startDate toDate:today options:0];
    NSInteger days = [components day];
    
    // Loop through days to fill picker choices.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];

    NSLog(@"Calculated %ld days since %@", (long)days, [dateFormatter stringFromDate:_startDate]);

    NSString *dateString = @"";
    components = [[NSDateComponents alloc]init];
    for(int i=0; i<=days; i++) {
        // Get dates from start date to today.
        int daysToAdd = i - days;
        NSLog(@"Adding %d days to start date.", daysToAdd);
        [components setDay:daysToAdd];
        NSDate *pastDate = [gregorian dateByAddingComponents:components toDate:today options:0];

        // Format and add date to the picker choices.
        dateString = [dateFormatter stringFromDate:pastDate];
        [_datePickerChoices addObject:[[NSString alloc] initWithFormat:@"%@", dateString]];
    }

    /**
     * Update the label for default row in picker.
     * -- TODO: eventually make this default to the latest entry in history (and make picker match).
     */
    [self updateLabelForWeight:0 andDate:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateLabelForWeight:(int)weightRow andDate:(int)dateRow {
    // Update label ('picker' choice made).
    [_label setText:[[NSString alloc] initWithFormat:@"%@ lbs on %@.", [_weightPickerChoices objectAtIndex:weightRow], [_datePickerChoices objectAtIndex:dateRow]]];
    
    // Change color for fun.
    //_label.textColor = [UIColor colorWithRed:0.0f/255.0f green: 0.0f/255.0f blue:255.0f/255.0f alpha:255.0f/255.0f];
}

/** ***** UIPickerViewDataSource ***** */

// Returns the # of columns (components) in picker.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return kNumColsWeightPicker;
}

// Returns the # of rows in each column (component).
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    int numRows = 0;
    
    switch (component) {
        case kWeightPickerComponent:
            numRows = [_weightPickerChoices count];
            break;
        case kDatePickerComponent:
            numRows = [_datePickerChoices count];
            break;
        default:
            break;
    }

    return numRows;
}

/** ***** UIPickerViewDelegate ***** */

// Returns the view (carrying a UILabel vs NSString) of each row in the picker.
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {

    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame;
        
        switch (component) {
            case kWeightPickerComponent:
                frame = CGRectMake(0.0, 0.0, 80, 35);
                break;
            case kDatePickerComponent:
                frame = CGRectMake(0.0, 0.0, 120, 35);
                break;
            default:
                break;
        }

        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:19]];
    }

    NSString *pickerTitle = @"";
    BOOL isWeightPickerComponent = NO;
    
    switch (component) {
        case kWeightPickerComponent:
            isWeightPickerComponent = YES;
            pickerTitle = [_weightPickerChoices objectAtIndex:row];
            break;
        case kDatePickerComponent:
            pickerTitle = [_datePickerChoices objectAtIndex:row];
            break;
        default:
            break;
    }
    
    [pickerLabel setText:pickerTitle];

    // Set the weight color to 'red' if it does not have a decimal point (else 'black').
    [pickerLabel setTextColor:(isWeightPickerComponent && [pickerTitle rangeOfString:@"."].location == NSNotFound) ? [UIColor redColor] : [UIColor blackColor]];
    
    return pickerLabel;
}

// Returns the title of each row in the picker.
//- (NSString *)pickerView:(UIPickerView *)pickerView
//             titleForRow:(NSInteger)row
//            forComponent:(NSInteger)component {
//    NSString *pickerTitle = @"";
//
//    switch (component) {
//        case kWeightPickerComponent:
//            pickerTitle = [_weightPickerChoices objectAtIndex:row];
//            break;
//        case kDatePickerComponent:
//            pickerTitle = [_datePickerChoices objectAtIndex:row];
//            // NSLog(@"Found date picker (title) of %@", pickerTitle);
//            break;
//        default:
//            break;
//    }
//
//    return pickerTitle;
//}

// (Reuse) Returns the title of each row in the picker.
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    return [_weightPickerChoices objectAtIndex:row];
//}

// Perform these tasks when the picker stops on a value.
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    int weightRow = [pickerView selectedRowInComponent:kWeightPickerComponent];
    int dateRow = [pickerView selectedRowInComponent:kDatePickerComponent];

    [self updateLabelForWeight:weightRow andDate:dateRow];
}

// Returns width of the column (component related to kNumColsWeightPicker starting at zero).
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    float colWidth = 0;
    
    switch (component) {
        case kWeightPickerComponent:
            colWidth = 100;
            break;
        case kDatePickerComponent:
            colWidth = 150;
            break;
        default:
            break;
    }

    return colWidth;
}

@end
