//
//  CoreDataStack.h
//  Core Data Hotel
//
//  Created by Robert Hatfield on 5/1/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

+(instancetype)shared;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end
