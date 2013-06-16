//
//  ViewController.h
//  DYproto
//
//  Created by David Yoshikawa on 6/16/13.
//  Copyright (c) 2013 medolarksoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *historyView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

// Holds data from 'data.plist'.
@property (strong, nonatomic) NSString *dataDictionaryPath;
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@property (strong, nonatomic) NSMutableArray *favThings;

- (IBAction)updateLabel:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end
