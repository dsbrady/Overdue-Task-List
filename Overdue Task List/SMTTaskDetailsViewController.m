//
//  SMTTaskDetailsViewController.m
//  Overdue Task List
//
//  Created by Scott Brady on 9/17/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import "SMTTaskDetailsViewController.h"

@interface SMTTaskDetailsViewController ()

@end

@implementation SMTTaskDetailsViewController

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
	self.titleLabel.text = self.task.title;
	self.descriptionLabel.text = self.task.taskDescription;

	// Format and display the date
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	self.dueDateLabel.text = [dateFormatter stringFromDate:self.task.dueDate];

	if (self.task.isComplete)
	{
		self.statusLabel.text = @"Complete";
	}
	else if ([self.task.dueDate compare:[NSDate date]] == NSOrderedAscending)
	{
		self.statusLabel.text = @"Overdue";
	}
	else
	{
		self.statusLabel.text = @"Incomplete";
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didCancel
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	if ([sender isKindOfClass:[SMTTask class]]) {
		if ([segue.destinationViewController isKindOfClass:[SMTEditTaskViewController class]])
		{
			SMTEditTaskViewController *editTaskVC = segue.destinationViewController;
			editTaskVC.task = sender;
			editTaskVC.delegate = self;
		}
	}
 }

- (IBAction)goToEditTask:(UIBarButtonItem *)sender {
	[self performSegueWithIdentifier:@"toEditTask" sender:self.task];
}

#pragma mark - SMTEditTaskViewControllerDelegate
-(void)saveTask:(SMTTask *)task
{
	// Update this view's task and refresh the data (but we won't update the status until after the arrays have been saved in the delegate
	self.task.title = task.title;
	self.task.taskDescription = task.taskDescription;
	self.task.dueDate = task.dueDate;
	self.task.isComplete = task.isComplete;

	[self viewDidLoad];

	// Now save the data
	[self.delegate updateTask:self.task forIndexPath:self.selectedIndexPath];
	[self.navigationController popViewControllerAnimated:YES];
}
@end
