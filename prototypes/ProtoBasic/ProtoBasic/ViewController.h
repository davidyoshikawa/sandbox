//
//  ViewController.h
//  ProtoBasic
//
//  Created by David Yoshikawa on 6/9/13.
//  Copyright (c) 2013 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (IBAction)updateLabel:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end
