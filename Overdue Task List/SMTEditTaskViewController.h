//
//  SMTEditTaskViewController.h
//  Overdue Task List
//
//  Created by Scott Brady on 9/17/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTTask.h"

@protocol SMTEditTaskViewControllerDelegate <NSObject>

@required

-(void)saveTask:(SMTTask *)task;
-(void)didCancel;
-(void)toggleEditTaskStatus:task;

@end

@interface SMTEditTaskViewController : UIViewController

@property (weak, nonatomic) id <SMTEditTaskViewControllerDelegate> delegate;

@property (strong,nonatomic) SMTTask *task;
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionField;
@property (strong, nonatomic) IBOutlet UIDatePicker *dueDatePicker;
@property (strong, nonatomic) IBOutlet UIButton *taskStatusButton;

- (IBAction)cancelEdit:(UIButton *)sender;
- (IBAction)updateTask:(UIButton *)sender;
- (IBAction)toggleTaskStatus:(UIButton *)sender;

@end
