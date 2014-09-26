//
//  SMTAddTaskViewController.m
//  Overdue Task List
//
//  Created by Scott Brady on 9/17/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import "SMTAddTaskViewController.h"

@interface SMTAddTaskViewController ()

@end

@implementation SMTAddTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.descriptionField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelAdd:(UIButton *)sender {
	[self.delegate didCancel];
}

- (IBAction)addTask:(UIButton *)sender {
	SMTTask *newTask = [self returnNewTask];
	[self.delegate addTask:newTask];
}

-(SMTTask *)returnNewTask
{
	SMTTask *addedTask = [[SMTTask alloc] init];

	addedTask.title = self.titleField.text;
	addedTask.taskDescription = self.descriptionField.text;
	addedTask.dueDate = self.dueDatePicker.date;
	addedTask.isComplete = NO;
// TODO: remove
//	addedTask.status = [addedTask getStatus];

	return addedTask;
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if ([text isEqualToString:@"\n"])
	{
		[self.descriptionField resignFirstResponder];
		return NO;
	}
	else
	{
		return YES;
	}
}


@end
