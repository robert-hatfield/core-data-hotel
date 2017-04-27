//
//  LookupReservationViewController.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/26/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "LookupReservationViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"
#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"
#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"


@interface LookupReservationViewController () <UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *reservations;

@end

@implementation LookupReservationViewController

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [AutoLayout fullScreenConstraintsWithVFLForView:self.tableView];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.reservations.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.reservations.sections.count == 0) {
        return 0;
    } else {
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.reservations.sections objectAtIndex:section];
        return sectionInfo.numberOfObjects;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Reservation *currentReservation = [self.reservations objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Room %u: %@ %@", currentReservation.room.number, currentReservation.guest.firstName, currentReservation.guest.lastName];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.reservations.sections objectAtIndex:section];
    
    return sectionInfo.name;
}

- (NSFetchedResultsController *)reservations {
    if (!_reservations) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSFetchRequest *reservationRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        NSSortDescriptor *hotelDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"room.hotel.name" ascending:YES];
        NSSortDescriptor *numberDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"room.number" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:hotelDescriptor, numberDescriptor, nil];
        
        reservationRequest.sortDescriptors = sortDescriptors;
        
        NSError *reservationError;
        
        _reservations = [[NSFetchedResultsController alloc] initWithFetchRequest:reservationRequest
                                                            managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"room.hotel.name" cacheName:nil];
        
        [_reservations performFetch:&reservationError];
    }
    
    return _reservations;
}

@end
