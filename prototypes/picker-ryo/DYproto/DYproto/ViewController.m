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
NSString * const kFavThingsDateFormat         = @"dd MMM hh:mm a";
NSString * const kMinWeightKey                = @"minWeight";
NSString * const kMaxWeightKey                = @"maxWeight";
NSString * const kWeightInTenthsKey           = @"weightInTenths";
NSString * const kWeightsKey                  = @"weights";
int        const kNumColsWeightPicker         = 1;

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
     * Initialize the picker values (num = (max-min) * 10 if by tenths).
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
     * Update the label for default row in picker.
     * -- TODO: eventually make this default to the latest entry in history (and make picker match).
     */
    [self updateLabel:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateLabel:(int)row {
    // Update label ('picker' choice made).
    [_label setText:[[NSString alloc] initWithFormat:@"The scale reads %@ lbs.", [_weightPickerChoices objectAtIndex:row]]];
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
        case 0:
            numRows = [_weightPickerChoices count];
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
    [self updateLabel:row];
}

// Returns width of the column (component related to kNumColsWeightPicker starting at zero).
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    float colWidth = 0;
    
    switch (component) {
        case 0:
            colWidth = 100;
            break;
        default:
            break;
    }

    return colWidth;
}

@end
