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

	return self;
}

@end
