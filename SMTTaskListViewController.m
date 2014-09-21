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
	NSArray *userTasks = [[NSUserDefaults standardUserDefaults] arrayForKey:USER_TASKS_KEY];

	for (NSDictionary *data in userTasks) {
		SMTTask *task = [[SMTTask alloc] initWithData:data];
		[self.tasks addObject:task];
	}

//	self.tableView.delegate = self;
//	self.tableView.dataSource = self;
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
	NSLog(@"%@",segue.destinationViewController);

	if([segue.destinationViewController isKindOfClass:[SMTAddTaskViewController class]])
	{
		SMTAddTaskViewController *addTaskVC = segue.destinationViewController;
		addTaskVC.delegate = self;
	}
	
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)goToAddTask:(UIBarButtonItem *)sender {
}
@end
