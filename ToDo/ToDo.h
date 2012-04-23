//
//  ToDo.h
//  ToDo
//
//  Created by damian on 14/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDo : NSObject 

@property (nonatomic, retain) NSString *toDo;
@property (nonatomic, retain) NSString *toDoDescription;
@property (nonatomic, assign) NSInteger toDoPriority;
@property (nonatomic, assign) NSInteger toDoCompletedInd;
@property (nonatomic, assign) NSInteger todoID;

@end
