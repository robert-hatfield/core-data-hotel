//
//  AvailabilityViewController.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/25/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "AvailabilityViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"
#import "BookViewController.h"
#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"

@interface AvailabilityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *availableRooms;

@end

@implementation AvailabilityViewController

- (NSFetchedResultsController *)availableRooms {
    if (!_availableRooms) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSFetchRequest *reservationRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        reservationRequest.predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", self.endDate, [NSDate date]];
        
        NSError *reservationError;
        NSArray *results = [appDelegate.persistentContainer.viewContext executeFetchRequest:reservationRequest error:&reservationError];
        
        NSMutableArray *unavailableRooms = [[NSMutableArray alloc] init];
        
        for (Reservation *reservation in results) {
            [unavailableRooms addObject:reservation.room];
        }
        
        
        NSFetchRequest *roomRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
        roomRequest.predicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", unavailableRooms];

        // Create sort descriptors. The first descriptor will be used for creating sections in the table view.
        NSSortDescriptor *hotelDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hotel.name" ascending:YES];
        NSSortDescriptor *numberDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:hotelDescriptor, numberDescriptor, nil];
        
        roomRequest.sortDescriptors = sortDescriptors;
        
        NSError *roomError;
        
        // Assign NSFetchedResultsController to _availableRooms
        _availableRooms = [[NSFetchedResultsController alloc] initWithFetchRequest:roomRequest
                                                              managedObjectContext:appDelegate.persistentContainer.viewContext
                                                                sectionNameKeyPath:@"hotel.name" cacheName:nil];
        
        [_availableRooms performFetch:&roomError];
    }
    
    return _availableRooms;
}

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [AutoLayout fullScreenConstraintsWithVFLForView:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.availableRooms sections] objectAtIndex:section];
    return sectionInfo.numberOfObjects;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Room *currentRoom = [self.availableRooms objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %i", currentRoom.hotel.name, currentRoom.number];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookViewController *bookVC = [[BookViewController alloc] init];
    
    bookVC.room = [[self availableRooms] objectAtIndexPath:indexPath];

    bookVC.startDate = self.startDate;
    bookVC.endDate = self.endDate;
    
    [self.navigationController pushViewController:bookVC animated:YES];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.availableRooms.sections.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.availableRooms.sections objectAtIndex:section];
    
    return sectionInfo.name;
}

@end
