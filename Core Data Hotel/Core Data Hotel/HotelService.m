//
//  HotelService.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 5/1/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "HotelService.h"
@import Crashlytics;

#import "AppDelegate.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"
#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"
#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"

@implementation HotelService

+ (BOOL)bookReservationForRoom:(Room *)room starting:(NSDate *)startDate andEnding:(NSDate *)endDate forFirstName:(NSString *)firstName lastName:(NSString *)lastName withEmailAddress:(NSString *)email {
    
    NSLog(@"Reservation requested for room %u at %@...", room.number, room.hotel.name);
    NSLog(@"Name: %@ %@", firstName, lastName);
    NSLog(@"Email: %@", email);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Guest *newGuest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
    newGuest.firstName = firstName;
    newGuest.lastName = lastName;
    newGuest.email = email;
    
    Reservation *newReservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
    newReservation.room = room;
    newReservation.startDate = startDate;
    newReservation.endDate = endDate;
    newReservation.guest = newGuest;
    
    NSError *saveError;
    [appDelegate.persistentContainer.viewContext save:&saveError];
    if (saveError) {
        
        NSLog(@"An error occurred when saving reservation to Core Data.");
        
        NSDictionary *attributesDictionary = @{@"Save Error" : saveError.localizedDescription};
        [Answers logCustomEventWithName:@"BookViewController - Save Error" customAttributes:attributesDictionary];
        return NO;
        
    } else {
        
        NSLog(@"New reservation successfully saved to Core Data.");
        NSDictionary *attributesDictionary = @{@"Hotel" : room.hotel.name};
        [Answers logCustomEventWithName:@"Reservation booked" customAttributes:attributesDictionary];
        return YES;
        
    }

}

@end
