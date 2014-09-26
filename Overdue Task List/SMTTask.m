//
//  SMTTask.m
//  Overdue Task List
//
//  Created by Scott Brady on 9/18/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import "SMTTask.h"

@implementation SMTTask

-(id)initWithData:(NSDictionary *)data
{
	self = [super init];

	self.title = data[TASK_TITLE];
	self.taskDescription = data[TASK_DESCRIPTION];
	self.dueDate = data[TASK_DUE_DATE];
	self.isComplete = [data[TASK_IS_COMPLETE] boolValue];
	self.status = [self getStatus];

	return self;
}

// We want this status to persist, so we won't set the private property
-(NSString *)getStatus
{
	NSString *status = @"Incomplete";

	if (self.isComplete)
	{
		status = @"Complete";
	}
	// Mark as overdue if the due date is before the current date
	else if ([self.dueDate compare:[NSDate date]] == NSOrderedAscending)
	{
		status = @"Overdue";
	}

	return status;
}
@end
