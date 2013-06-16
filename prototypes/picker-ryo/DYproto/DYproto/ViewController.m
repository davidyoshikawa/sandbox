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

    NSLog(@"Initialized:"
          "\n  '%@' (%@)"
          "\n  '%@' (%@)"
          "\n  '%@' (%d)"
          "\n  '%@' (%d items)",
          kMinWeightKey, _minWeight,
          kMaxWeightKey, _maxWeight,
          kWeightInTenthsKey, _weightInTenths ,
          kWeightsKey, (!_weights ? 0 : [_weights count]));
    
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

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    // TODO: fix this so we have a starting date in plist and populate with dates until present (then add call back by date).
    NSString *dateString = [dateFormatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0]];
    [_datePickerChoices addObject:[[NSString alloc] initWithString:dateString]];
    
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

// Returns the title of each row in the picker.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_weightPickerChoices objectAtIndex:row];
}

// (Reuse) Returns the title of each row in the picker.
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    return [_weightPickerChoices objectAtIndex:row];
//}

// Acts on picker row selection.
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
        default:
            break;
    }

    return colWidth;
}

@end
