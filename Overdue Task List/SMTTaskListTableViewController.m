//
//  SMTTaskListTableViewController.m
//  Overdue Task List
//
//  Created by Scott Brady on 9/18/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import "SMTTaskListTableViewController.h"
#import "SMTTask.h"
#import "SMTTaskDetailsViewController.h"

@interface SMTTaskListTableViewController ()

@end

@implementation SMTTaskListTableViewController

/*
	TODOs:
	* separate arrays for complete and incomplete tasks (includes a separate table section)
	* reordering tasks
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


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	NSArray *userTasks = [[NSUserDefaults standardUserDefaults] arrayForKey:USER_TASKS_KEY];

	for (NSDictionary *data in userTasks) {
		SMTTask *task = [[SMTTask alloc] initWithData:data];
		[self.tasks addObject:task];
	}

	self.tableView.delegate = self;
	self.tableView.dataSource = self;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSLog(@"%@",segue.destinationViewController);

	if([segue.destinationViewController isKindOfClass:[SMTAddTaskViewController class]])
	{
		SMTAddTaskViewController *addTaskVC = segue.destinationViewController;
		addTaskVC.delegate = self;
	}

	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
}

#pragma mark - SMTAddTaskViewControllerDelegate

-(void)didCancel
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addTask:(SMTTask *)task
{
	[self.tasks addObject:task];
	NSLog(@"%@",self.tasks);

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

	[self.tableView reloadData];
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

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"here");
	[self performSegueWithIdentifier:@"toTaskInfoView" sender:indexPath];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
