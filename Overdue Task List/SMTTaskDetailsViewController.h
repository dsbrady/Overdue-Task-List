//
//  SMTTaskDetailsViewController.h
//  Overdue Task List
//
//  Created by Scott Brady on 9/17/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTTask.h"
#import "SMTEditTaskViewController.h"

@protocol SMTTaskDetailsViewControllerDelegate <NSObject>

-(void)updateTask:(SMTTask *)task forIndexPath:(NSIndexPath *)indexPath;

@end

@interface SMTTaskDetailsViewController : UIViewController <SMTEditTaskViewControllerDelegate>

@property (weak, nonatomic) id <SMTTaskDetailsViewControllerDelegate> delegate;

@property (strong, nonatomic) SMTTask *task;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

- (IBAction)goToEditTask:(UIBarButtonItem *)sender;

@end
