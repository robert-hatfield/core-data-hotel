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


@interface LookupReservationViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSFetchedResultsController *fetchedReservations;
@property (strong, nonatomic) NSArray *allReservations;
@property (strong, nonatomic) NSArray *filteredReservations;

@end

@implementation LookupReservationViewController

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.allReservations = self.fetchedReservations.fetchedObjects;
    self.filteredReservations = self.allReservations;
}

- (void)setupViews {
    self.definesPresentationContext = YES;
    self.searchBar = [[UISearchBar alloc] init];
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search for guest";
    
    [AutoLayout leadingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout trailingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout fullScreenConstraintsWithVFLForView:self.tableView];
    
    self.tableView.tableHeaderView = self.searchBar;
    [self.tableView layoutIfNeeded];
    [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [self.searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredReservations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 2;
    Reservation *currentReservation = [self.filteredReservations objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, Room %u: \n%@ %@",
                           currentReservation.room.hotel.name,
                           currentReservation.room.number,
                           currentReservation.guest.firstName,
                           currentReservation.guest.lastName];
    
    return cell;
}

- (NSFetchedResultsController *)fetchedReservations {
    
    if (!_fetchedReservations) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSFetchRequest *reservationRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        NSSortDescriptor *hotelDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"room.hotel.name" ascending:YES];
        NSSortDescriptor *numberDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"room.number" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:hotelDescriptor, numberDescriptor, nil];
        reservationRequest.sortDescriptors = sortDescriptors;

        NSError *reservationError;
        
        _fetchedReservations = [[NSFetchedResultsController alloc] initWithFetchRequest:reservationRequest
                                                                   managedObjectContext:appDelegate.persistentContainer.viewContext
                                                                     sectionNameKeyPath:@"room.hotel.name"
                                                                              cacheName:nil];
        
        [_fetchedReservations performFetch:&reservationError];
        if (reservationError) {
            NSLog(@"%@", reservationError.localizedDescription);
        }
    }
    
    return _fetchedReservations;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self updateResultsWith:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updateResultsWith:searchText];
}

- (void) updateResultsWith:(NSString *)searchText {
    if ([searchText isEqual: @""]) {
        self.filteredReservations = self.allReservations;
    } else {
        self.filteredReservations = [self.allReservations filteredArrayUsingPredicate:[self filterByFirstName:@"guest.firstName"
                                                                                                  andLastName:@"guest.lastName"
                                                                                             usingSearchTerms:searchText]];
    }
    [self.tableView reloadData];
}

-(NSPredicate *)filterByFirstName:(NSString *)firstName
                      andLastName:(NSString *)lastName
                 usingSearchTerms:(NSString *)searchTerms{
    return [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@ || %K CONTAINS[cd] %@"
                              argumentArray:@[firstName, searchTerms, lastName, searchTerms]];
}

@end
