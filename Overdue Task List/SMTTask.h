//
//  SMTTask.h
//  Overdue Task List
//
//  Created by Scott Brady on 9/18/14.
//  Copyright (c) 2014 Spider Monkey Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMTTask : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *taskDescription;
@property (strong, nonatomic) NSDate *dueDate;
@property (nonatomic) BOOL isComplete;

// This will be a derived property based on isComplete and dueDate
@property (strong, nonatomic) NSString *status;

-(id) initWithData:(NSDictionary *)data;

-(NSString *)getStatus;
@end
