//
//  SMTTaskListViewController.m
//  Overdue Task List
//
//  Created by Scott Brady on 9/17/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import "SMTTaskListViewController.h"
//#import "SMTTask.h"
//#import "SMTTaskDetailsViewController.h"

@interface SMTTaskListViewController ()

@end

@implementation SMTTaskListViewController

/*
	TODOs:
	* separate arrays for complete and incomplete tasks (includes a separate table section)
	* why does the cell background not change if a task is complete when you click on it to mark it incomplete?
 */

#pragma mark - Lazy instantiation of properties
-(NSMutableArray *)tasks
{
	if (!_tasks)
	{
		_tasks = [[NSMutableArray alloc] init];
	}
	return _tasks;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	// Set the table view's delegate and datasource properties to self
	self.taskTableView.delegate = self;
	self.taskTableView.dataSource = self;

	// Populate the tasks from the user defaults
	NSArray *userTasks = [[NSUserDefaults standardUserDefaults] arrayForKey:USER_TASKS_KEY];

	for (NSDictionary *data in userTasks) {
		SMTTask *task = [[SMTTask alloc] initWithData:data];
		[self.tasks addObject:task];
	}

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// Before going to the addTask view, set the delegate for the view controller to be this, so that it can call methods in this file
	if([segue.destinationViewController isKindOfClass:[SMTAddTaskViewController class]])
	{
		SMTAddTaskViewController *addTaskVC = segue.destinationViewController;
		addTaskVC.delegate = self;
	}
	// Go to the task details view
	else if ([sender isKindOfClass:[NSIndexPath class]])
	{
		if ([segue.destinationViewController isKindOfClass:[SMTTaskDetailsViewController class]])
		{
			SMTTaskDetailsViewController *taskDetailsVC = segue.destinationViewController;
			NSIndexPath *path = sender;
			SMTTask *selectedTask = self.tasks[path.row];
			taskDetailsVC.task = selectedTask;
			taskDetailsVC.selectedIndexPath = path;
			taskDetailsVC.delegate = self;
		}
	}
	
}

#pragma mark - SMTAddTaskViewControllerDelegate

-(void)didCancel
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addTask:(SMTTask *)task
{
	[self.tasks addObject:task];

	// Will save to NSUserDefaults here
	NSMutableArray *tasksAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:USER_TASKS_KEY] mutableCopy];

	if (!tasksAsPropertyLists)
	{
		tasksAsPropertyLists = [[NSMutableArray alloc] init];
	}

	[tasksAsPropertyLists addObject:[self taskAsPropertyList:task]];

	[[NSUserDefaults standardUserDefaults] setObject:tasksAsPropertyLists forKey:USER_TASKS_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[self dismissViewControllerAnimated:YES completion:nil];

	[self.taskTableView reloadData];
}

#pragma mark - SMTTaskDetailsViewControllerDelegate
-(void)updateTask:(SMTTask *)task forIndexPath:(NSIndexPath *)indexPath
{
	SMTTask *taskToUpdate = self.tasks[indexPath.row];
	taskToUpdate.title = task.title;
	taskToUpdate.taskDescription = task.taskDescription;
	taskToUpdate.dueDate = task.dueDate;
	taskToUpdate.isComplete = task.isComplete;

	[self saveTasks];
	[self.taskTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"taskCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

	UIColor *overDueBackgroundColor = [UIColor redColor];
	UIColor *overDueTextColor = [UIColor whiteColor];
	UIColor *completeBackgroundColor = [UIColor greenColor];
	UIColor *completeTextColor = [UIColor blackColor];

	// Configure the cell...
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

	SMTTask *task = self.tasks[indexPath.row];
	cell.textLabel.text = task.title;
	cell.detailTextLabel.text = [dateFormatter stringFromDate:task.dueDate];

	if (task.isComplete)
	{
		cell.backgroundColor = completeBackgroundColor;
		cell.textLabel.textColor = completeTextColor;
		cell.detailTextLabel.textColor = completeTextColor;
	}
	// Mark as overdue if the due date is before the current date
	else if ([task.dueDate compare:[NSDate date]] == NSOrderedAscending)
	{
		cell.backgroundColor = overDueBackgroundColor;
		cell.textLabel.textColor = overDueTextColor;
		cell.detailTextLabel.textColor = overDueTextColor;
	}

	return cell;
}

#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SMTTask *selectedTask = self.tasks[indexPath.row];
	[self updateTaskCompletion:selectedTask forIndexPath:indexPath];

}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self performSegueWithIdentifier:@"toTaskInfoView" sender:indexPath];
}

 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }

 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
	 if (editingStyle == UITableViewCellEditingStyleDelete)
	 {
		 // Update the stored task data
		 [self.tasks removeObjectAtIndex:indexPath.row];
		 [self saveTasks];

		 // Delete the row from the data source
		 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	 }
	 else if (editingStyle == UITableViewCellEditingStyleInsert)
	 {
		 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	 }
 }

 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
	 // Put the task currently in the "from" row into a temporary task
	 SMTTask *fromTask = self.tasks[fromIndexPath.row];

	 // Put whatever is in the "to" row into the "from" row
	 self.tasks[fromIndexPath.row] = self.tasks[toIndexPath.row];

	 // Now put the "fromTask" into the "to" row
	 self.tasks[toIndexPath.row] = fromTask;

	 // Save thet tasks to user defaults
	 [self saveTasks];
 }

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
	 // Return NO if you do not want the item to be re-orderable.
	 return YES;
 }


- (IBAction)goToAddTask:(UIBarButtonItem *)sender
{
	[self performSegueWithIdentifier:@"toAddTaskView" sender:nil];

}

- (IBAction)showReorderView:(UIBarButtonItem *)sender
{
	if(self.taskTableView.editing)
	{
		sender.title = @"Reorder";
		[self.taskTableView setEditing:NO animated:YES];
	}
	else
	{
		sender.title = @"Done";
		[self.taskTableView setEditing:YES animated:YES];
	}
}

#pragma mark - Helper methods
-(NSDictionary *)taskAsPropertyList:(SMTTask *)task
{
	NSDictionary *dictionary = @{
								 TASK_TITLE: task.title,
								 TASK_DESCRIPTION: task.taskDescription,
								 TASK_DUE_DATE: task.dueDate,
								 TASK_IS_COMPLETE: @(task.isComplete)
								 };

	return dictionary;
}

-(void)updateTaskCompletion:(SMTTask *)task forIndexPath:(NSIndexPath *)indexPath
{
	// Get the stored tasks array
	NSMutableArray *savedTasks = [[NSMutableArray alloc] init];
	savedTasks = [[NSUserDefaults standardUserDefaults] objectForKey:USER_TASKS_KEY];

	// Update the current task's completion status by flipping the current value
	NSLog(@"%@",@(task.isComplete));
	task.isComplete = !task.isComplete;
	NSLog(@"%@",@(task.isComplete));

	// Update the savedTasks object with the new task
	savedTasks[indexPath.row] = [self taskAsPropertyList:task];

	[[NSUserDefaults standardUserDefaults] setObject:savedTasks forKey:USER_TASKS_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[self.taskTableView reloadData];
}

// This task will take the current self.tasks object and save it to userDefaults
-(void)saveTasks
{
	NSMutableArray *newTasksArray = [[NSMutableArray alloc] init];
	for (SMTTask *task in self.tasks)
	{
		[newTasksArray addObject:[self taskAsPropertyList:task]];
	}
	[[NSUserDefaults standardUserDefaults] setObject:newTasksArray forKey:USER_TASKS_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
