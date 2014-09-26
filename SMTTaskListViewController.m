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
	* Enhance the UI (add icons)
	* separate arrays for overdue, incomplete, and complete tasks (includes separate table sections in that order)
	* Mark complete in the edit and detail view
 */

#pragma mark - Lazy instantiation of properties
-(NSMutableArray *)completeTasks
{
	if (!_completeTasks)
	{
		_completeTasks = [[NSMutableArray alloc] init];
	}
	return _completeTasks;
}

-(NSMutableArray *)incompleteTasks
{
	if (!_incompleteTasks)
	{
		_incompleteTasks = [[NSMutableArray alloc] init];
	}
	return _incompleteTasks;
}

-(NSMutableArray *)overdueTasks
{
	if (!_overdueTasks)
	{
		_overdueTasks = [[NSMutableArray alloc] init];
	}
	return _overdueTasks;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	// TODO: REmove this. This is just to clear out the defaults during testing
//	NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

	// Set the table view's delegate and datasource properties to self
	self.taskTableView.delegate = self;
	self.taskTableView.dataSource = self;

	// Populate the 3 task arrays from the user defaults
	NSArray *overdueTasks = [[NSUserDefaults standardUserDefaults] arrayForKey:OVERDUETASKS_KEY];
	for (NSDictionary *data in overdueTasks) {
		SMTTask *task = [[SMTTask alloc] initWithData:data];
		[self.overdueTasks addObject:task];
	}

	NSArray *incompleteTasks = [[NSUserDefaults standardUserDefaults] arrayForKey:INCOMPLETETASKS_KEY];
	for (NSDictionary *data in incompleteTasks) {
		SMTTask *task = [[SMTTask alloc] initWithData:data];
		[self.incompleteTasks addObject:task];
	}

	NSArray *completeTasks = [[NSUserDefaults standardUserDefaults] arrayForKey:COMPLETETASKS_KEY];
	for (NSDictionary *data in completeTasks) {
		SMTTask *task = [[SMTTask alloc] initWithData:data];
		[self.completeTasks addObject:task];
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
			int sectionNumber = (int)path.section;
			SMTTask *selectedTask = [self getTaskArrayBySection:sectionNumber][path.row];
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
	NSString *status = [task getStatus];
	NSMutableArray *taskArray = [[NSMutableArray alloc] init];
	NSString *defaultsKey = @"";

	if ([status isEqualToString:@"Complete"])
	{
		taskArray = self.completeTasks;
		defaultsKey = COMPLETETASKS_KEY;
	}
	else if ([status isEqualToString:@"Overdue"])
	{
		taskArray = self.overdueTasks;
		defaultsKey = OVERDUETASKS_KEY;
	}
	else
	{
		taskArray = self.incompleteTasks;
		defaultsKey = INCOMPLETETASKS_KEY;
	}

	[taskArray addObject:task];

	// Will save to NSUserDefaults here
	NSMutableArray *tasksAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:defaultsKey] mutableCopy];

	if (!tasksAsPropertyLists)
	{
		tasksAsPropertyLists = [[NSMutableArray alloc] init];
	}

	[tasksAsPropertyLists addObject:[self taskAsPropertyList:task]];

	[[NSUserDefaults standardUserDefaults] setObject:tasksAsPropertyLists forKey:defaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[self dismissViewControllerAnimated:YES completion:nil];

	[self.taskTableView reloadData];
}

#pragma mark - SMTTaskDetailsViewControllerDelegate
-(void)updateTask:(SMTTask *)task forIndexPath:(NSIndexPath *)indexPath
{
	// Make sure all the tasks are in the proper arrays
	[self updateTaskArrays];

//	NSMutableArray *originalTaskArray = [[NSMutableArray alloc] init];
//	NSMutableArray *newTaskArray = [[NSMutableArray alloc] init];
//	NSString *originalDefaultsKey = @"";
//	NSString *newDefaultsKey = @"";
//	NSString *newStatus = [task getStatus];
//
//	// TODO: create helper function for this functionality to be used here and when updating a status
//	// Get the "original" data
//	if ([task.status isEqualToString:@"Complete"])
//	{
//		originalTaskArray = self.completeTasks;
//		originalDefaultsKey = COMPLETETASKS_KEY;
//	}
//	else if ([task.status isEqualToString:@"Overdue"])
//	{
//		originalTaskArray = self.overdueTasks;
//		originalDefaultsKey = OVERDUETASKS_KEY;
//	}
//	else
//	{
//		originalTaskArray = self.incompleteTasks;
//		originalDefaultsKey = INCOMPLETETASKS_KEY;
//	}
//
//	// Get the "destination" array, etc.
//	if ([newStatus isEqualToString:@"Complete"])
//	{
//		newTaskArray = self.completeTasks;
//		newDefaultsKey = COMPLETETASKS_KEY;
//	}
//	else if ([newStatus isEqualToString:@"Overdue"])
//	{
//		newTaskArray = self.overdueTasks;
//		newDefaultsKey = OVERDUETASKS_KEY;
//	}
//	else
//	{
//		newTaskArray = self.incompleteTasks;
//		newDefaultsKey = INCOMPLETETASKS_KEY;
//	}
//
//	// Save the task's status (now that we don't need the old value
//	task.status = [task getStatus];
//
//	NSLog(@"%@",originalTaskArray);
//	NSLog(@"%@",newTaskArray);
//	// If the two arrays are different, move from the original to the new
//	if (originalTaskArray != newTaskArray)
//	{
//		[originalTaskArray removeObjectAtIndex:indexPath.row];
//		[newTaskArray addObject:task];
//	}
//
//	NSLog(@"%@",originalTaskArray);
//	NSLog(@"%@",newTaskArray);
//	NSLog(@"%@",indexPath);
//	SMTTask *taskToUpdate = originalTaskArray[indexPath.row];
//	taskToUpdate.title = task.title;
//	taskToUpdate.taskDescription = task.taskDescription;
//	taskToUpdate.dueDate = task.dueDate;
//	taskToUpdate.isComplete = task.isComplete;
//	taskToUpdate.status = [taskToUpdate getStatus];

//	[self saveTasks:originalTaskArray forDefaultKey:originalDefaultsKey];
	[self.taskTableView reloadData];
}

// TODO: move to helper functions pragma
-(void) updateTaskArrays
{
	NSMutableArray *fromArray = [[NSMutableArray alloc] init];
	NSMutableArray *toArray = [[NSMutableArray alloc] init];
	NSString *status = @"";

	// loop over the incomplete array
	fromArray = self.incompleteTasks;
	for (SMTTask *task in fromArray)
	{
		status = [task getStatus];
		if ([status isEqualToString:@"Overdue"])
		{
			// Is now overdue
			toArray = self.overdueTasks;
		}
		else if ([status isEqualToString:@"Complete"])
		{
			// Is now complete
			toArray = self.completeTasks;
		}
		else
		{
			// Same array, so go to the next task
			NSLog(@"here2");
			continue;
		}

		// Delete from the original array
		[fromArray removeObject:task];

		// Insert into the new array
		[toArray addObject:task];
	}

	// loop over the overdue array
	fromArray = self.overdueTasks;
	for (SMTTask *task in fromArray)
	{
		status = [task getStatus];
		if ([status isEqualToString:@"Incomplete"])
		{
			// Is now incomplete
			toArray = self.incompleteTasks;
		}
		else if ([status isEqualToString:@"Complete"])
		{
			// Is now complete
			toArray = self.completeTasks;
		}
		else
		{
			// Same array, so go to the next task
			NSLog(@"here");
			continue;
		}
		NSLog(@"%@",fromArray);
		NSLog(@"%@",task.title);
		// Delete from the original array
		[fromArray removeObject:task];

		// Insert into the new array
		[toArray addObject:task];
	}

	// loop over the complete array
	fromArray = self.completeTasks;
	for (SMTTask *task in fromArray)
	{
		status = [task getStatus];
		if ([status isEqualToString:@"Incomplete"])
		{
			// Is now incomplete
			toArray = self.incompleteTasks;
		}
		else if ([status isEqualToString:@"Overdue"])
		{
			// Is now overdue
			toArray = self.overdueTasks;
		}
		else
		{
			// Same array, so go to the next task
			continue;
		}

		// Delete from the original array
		[fromArray removeObject:task];

		// Insert into the new array
		[toArray addObject:task];
	}

	// Now save all 3 arrays
//	[self saveTasks:self.incompleteTasks forDefaultKey:INCOMPLETETASKS_KEY];
//	[self saveTasks:self.completeTasks forDefaultKey:COMPLETETASKS_KEY];
//	[self saveTasks:self.overdueTasks forDefaultKey:OVERDUETASKS_KEY];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	NSMutableArray *taskArray = [self getTaskArrayBySection:(int)section];

	return [taskArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"taskCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

	// Configure the cell...
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

	int sectionNumber = (int)indexPath.section;
	SMTTask *task = [self getTaskArrayBySection:sectionNumber][indexPath.row];
	cell.textLabel.text = task.title;
	cell.detailTextLabel.text = [dateFormatter stringFromDate:task.dueDate];

	[self formatCell:cell forTask:task];

	return cell;
}

#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int sectionNumber = (int)indexPath.section;
	SMTTask *selectedTask = [self getTaskArrayBySection:sectionNumber][indexPath.row];
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
	 int sectionNumber = (int)indexPath.section;
	 NSMutableArray *taskArray = [self getTaskArrayBySection:sectionNumber];
	 NSString *defaultKey = [self getTaskDefaultKey:sectionNumber];

	 if (editingStyle == UITableViewCellEditingStyleDelete)
	 {
		 // Update the stored task data
		 [taskArray removeObjectAtIndex:indexPath.row];
		 [self saveTasks:taskArray forDefaultKey:defaultKey];

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
	 int sectionNumber = (int)fromIndexPath.section;
	 NSMutableArray *taskArray = [self getTaskArrayBySection:sectionNumber];
	 NSString *defaultKey = [self getTaskDefaultKey:sectionNumber];

	 // Put the task currently in the "from" row into a temporary task
	 SMTTask *tempTask = taskArray[fromIndexPath.row];

	 // Put whatever is in the "to" row into the "from" row
	 taskArray[fromIndexPath.row] = taskArray[toIndexPath.row];

	 // Now put the "fromTask" into the "to" row
	 taskArray[toIndexPath.row] = tempTask;

	 // Save the tasks to user defaults
	 [self saveTasks:taskArray forDefaultKey:defaultKey];
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
-(void)formatCell:(UITableViewCell *)cell forTask:(SMTTask *)task
{
	UIColor *overDueBackgroundColor = [UIColor redColor];
	UIColor *overDueTextColor = [UIColor whiteColor];
	UIColor *completeBackgroundColor = [UIColor greenColor];
	UIColor *completeTextColor = [UIColor blackColor];
	UIColor *incompleteBackgroundColor = [UIColor whiteColor];
	UIColor *inccompleteTextColor = [UIColor blackColor];

	NSString *status = [task getStatus];

	// Complete
	if ([status isEqualToString:@"Complete"])
	{
		cell.backgroundColor = completeBackgroundColor;
		cell.textLabel.textColor = completeTextColor;
		cell.detailTextLabel.textColor = completeTextColor;
		cell.imageView.image = [UIImage imageNamed:@"complete_40x40.jpg"];
	}
	// Overdue
	else if ([status isEqualToString:@"Overdue"])
	{
		cell.backgroundColor = overDueBackgroundColor;
		cell.textLabel.textColor = overDueTextColor;
		cell.detailTextLabel.textColor = overDueTextColor;
		cell.imageView.image = [UIImage imageNamed:@"overdue_40x40.jpg"];
	}
	// Incomplete
	else
	{
		cell.backgroundColor = incompleteBackgroundColor;
		cell.textLabel.textColor = inccompleteTextColor;
		cell.detailTextLabel.textColor = inccompleteTextColor;
		cell.imageView.image = [UIImage imageNamed:@"incomplete_40x40.jpg"];
	}
}

-(NSString *)getTaskDefaultKey:(int)sectionNumber
{
	NSString *defaultKey = @"";

	switch (sectionNumber)
	{
		case 0:
			defaultKey = OVERDUETASKS_KEY;
			break;
		case 1:
			defaultKey = INCOMPLETETASKS_KEY;
			break;
		case 2:
			defaultKey = COMPLETETASKS_KEY;
			break;
	}

	return defaultKey;
}

-(NSMutableArray *)getTaskArrayBySection:(int)sectionNumber
{
	NSMutableArray *taskArray = [[NSMutableArray alloc] init];

	switch (sectionNumber)
	{
		case 0:
			taskArray = self.overdueTasks;
			break;
		case 1:
			taskArray = self.incompleteTasks;
			break;
		case 2:
			taskArray = self.completeTasks;
			break;
	}

	return taskArray;
}
// This task will take a tasks object and save it to userDefaults
-(void)saveTasks:(NSMutableArray *)taskArray forDefaultKey:(NSString *)defaultkey
{
	NSMutableArray *newTasksArray = [[NSMutableArray alloc] init];
	for (SMTTask *task in taskArray)
	{
		[newTasksArray addObject:[self taskAsPropertyList:task]];
	}
	[[NSUserDefaults standardUserDefaults] setObject:newTasksArray forKey:defaultkey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSDictionary *)taskAsPropertyList:(SMTTask *)task
{
	NSDictionary *dictionary = @{
								 TASK_TITLE: task.title,
								 TASK_DESCRIPTION: task.taskDescription,
								 TASK_DUE_DATE: task.dueDate,
								 TASK_IS_COMPLETE: @(task.isComplete),
								 TASK_STATUS: task.status
								 };

	return dictionary;
}

-(void)updateTaskCompletion:(SMTTask *)task forIndexPath:(NSIndexPath *)indexPath
{
	// TODO: save tasks with multiple sections/arrays
	// Get the stored tasks arrays (from and to)
	int fromSectionNumber = (int)indexPath.section;
	NSString *fromDefaultKey = [self getTaskDefaultKey:fromSectionNumber];

	NSMutableArray *fromTasks = [self getTaskArrayBySection:fromSectionNumber];
	NSMutableArray *fromSavedTasks = [[NSUserDefaults standardUserDefaults] objectForKey:fromDefaultKey];

	// Update the current task's completion status by flipping the current value
	task.isComplete = !task.isComplete;

	NSString *newStatus = [task getStatus];
	NSLog(@"%@",newStatus);
//	// Update the savedTasks object with the new task
//	savedTasks[indexPath.row] = [self taskAsPropertyList:task];
//
////	[[NSUserDefaults standardUserDefaults] setObject:savedTasks forKey:USER_TASKS_KEY];
//	[[NSUserDefaults standardUserDefaults] synchronize];

	[self.taskTableView reloadData];
}

@end
