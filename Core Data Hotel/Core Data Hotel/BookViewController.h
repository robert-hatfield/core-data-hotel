//
//  BookViewController.h
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/25/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"

@interface BookViewController : UIViewController

@property (strong, nonatomic) Room *room;
@property(strong, nonatomic) NSDate *startDate;
@property(strong, nonatomic) NSDate *endDate;

@end
