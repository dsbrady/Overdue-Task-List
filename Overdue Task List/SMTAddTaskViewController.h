//
//  SMTAddTaskViewController.h
//  Overdue Task List
//
//  Created by Scott Brady on 9/17/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTTask.h"

@protocol SMTAddTaskViewControllerDelegate <NSObject>

@required

-(void)addTask:(SMTTask *)task;
-(void)didCancel;

@end

@interface SMTAddTaskViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) id <SMTAddTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionField;
@property (strong, nonatomic) IBOutlet UIDatePicker *dueDatePicker;

- (IBAction)cancelAdd:(UIButton *)sender;
- (IBAction)addTask:(UIButton *)sender;

@end
