//
//  SMTTaskListTableViewController.h
//  Overdue Task List
//
//  Created by Scott Brady on 9/18/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTAddTaskViewController.h"

@interface SMTTaskListTableViewController : UITableViewController <SMTAddTaskViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *tasks;

@end
