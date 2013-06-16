//
//  ViewController.h
//  MiddleWeight
//
//  Created by Jeff Worley on 6/5/13.
//  Copyright (c) 2013 Jeff Worley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *weightPickerView;
@property (weak, nonatomic) IBOutlet UITextField *weightEntry;
@property (weak, nonatomic) IBOutlet UILabel *recentWeightEntry;
@property (weak, nonatomic) IBOutlet UILabel *weightHistory;

@property (strong, nonatomic) NSString *dataDictionaryPath;
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@property (strong, nonatomic) NSArray *pickerWeights;

- (IBAction)updateLabel:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end
