//
//  SMTTaskListViewController.h
//  Overdue Task List
//
//  Created by Scott Brady on 9/17/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTAddTaskViewController.h"
#import "SMTTaskDetailsViewController.h"

@interface SMTTaskListViewController : UIViewController <SMTAddTaskViewControllerDelegate,SMTTaskDetailsViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *overdueTasks;
@property (strong, nonatomic) NSMutableArray *incompleteTasks;
@property (strong, nonatomic) NSMutableArray *completeTasks;

@property (strong, nonatomic) IBOutlet UITableView *taskTableView;

- (IBAction)goToAddTask:(UIBarButtonItem *)sender;
- (IBAction)showReorderView:(UIBarButtonItem *)sender;

@end
