//
//  ViewController.h
//  DYproto
//
//  Created by David Yoshikawa on 6/16/13.
//  Copyright (c) 2013 medolarksoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIPickerView *weightPicker;

// Holds data from 'data.plist' (weights, etc).
@property (strong, nonatomic) NSString *dataDictionaryPath;
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@property (strong, nonatomic) NSNumber *minWeight;
@property (strong, nonatomic) NSNumber *maxWeight;
//@property (strong, nonatomic) Boolean *weightInTenths;
@property (strong, nonatomic) NSMutableArray *weights;
@property (strong, nonatomic) NSMutableArray *weightPickerChoices;

// Holds calculated data.
//@property (strong, nonatomic) NSInteger *numWeightsOnPicker;

-(void)updateLabel:(int)row;

@end
