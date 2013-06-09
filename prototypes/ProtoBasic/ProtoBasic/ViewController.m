//
//  ViewController.m
//  ProtoBasic
//
//  Created by David Yoshikawa on 6/9/13.
//  Copyright (c) 2013 david. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateLabel:(id)sender {
    NSString *labelText = [[NSString alloc] initWithFormat:@"Hi %@", [_textField text]];
    [_label setText:labelText];
}

@end
