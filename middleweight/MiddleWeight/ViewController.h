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

@property (nonatomic, strong) NSArray *weightList;

@property (weak, nonatomic) IBOutlet UITextField *weightEntry;

@property (weak, nonatomic) IBOutlet UILabel *runningWeightRecord;

- (IBAction)changeLabel:(id)sender;

- (IBAction)dismissKeyboard:(id)sender;

@end
