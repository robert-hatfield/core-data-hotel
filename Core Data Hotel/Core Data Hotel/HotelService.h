//
//  HotelService.h
//  Core Data Hotel
//
//  Created by Robert Hatfield on 5/1/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

@interface HotelService : NSObject

+ (BOOL)bookReservationForRoom:(Room *)room starting:(NSDate *)startDate andEnding:(NSDate *)endDate forFirstName:(NSString *)firstName lastName:(NSString *)lastName withEmailAddress:(NSString *)email;

@end
