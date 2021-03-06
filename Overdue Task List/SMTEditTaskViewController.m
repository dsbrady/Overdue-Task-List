//
//  SMTEditTaskViewController.m
//  Overdue Task List
//
//  Created by Scott Brady on 9/17/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import "SMTEditTaskViewController.h"

@interface SMTEditTaskViewController ()

@end

@implementation SMTEditTaskViewController

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
	self.titleField.text = self.task.title;
	self.descriptionField.text = self.task.taskDescription;
	self.dueDatePicker.date = self.task.dueDate;

	if (self.task.isComplete)
	{
		[self.taskStatusButton setTitle:@"Mark Incomplete" forState:UIControlStateNormal];
	}
	else if ([self.task.dueDate compare:[NSDate date]] == NSOrderedAscending)
	{
		[self.taskStatusButton setTitle:@"Mark Complete" forState:UIControlStateNormal];
	}
	else
	{
		[self.taskStatusButton setTitle:@"Mark Complete" forState:UIControlStateNormal];
	}
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

- (IBAction)cancelEdit:(UIButton *)sender
{
	[self.delegate didCancel];
}

- (IBAction)updateTask:(UIButton *)sender
{
	// We won't update the status property until after we've used the current value in the delegate
	self.task.title = self.titleField.text;
	self.task.taskDescription = self.descriptionField.text;
	self.task.dueDate = self.dueDatePicker.date;
	[self.delegate saveTask:self.task];
}

- (IBAction)toggleTaskStatus:(UIButton *)sender
{
	[self.delegate toggleEditTaskStatus:self.task];
	[self.navigationController popViewControllerAnimated:YES];
}
@end
