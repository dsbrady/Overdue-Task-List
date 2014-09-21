//
//  SMTEditTaskViewController.h
//  Overdue Task List
//
//  Created by Scott Brady on 9/17/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMTEditTaskViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextView *taskDescriptionField;
@property (strong, nonatomic) IBOutlet UIDatePicker *dueDatePicker;

- (IBAction)cancelEdit:(UIButton *)sender;
- (IBAction)updateTask:(UIButton *)sender;

@end
