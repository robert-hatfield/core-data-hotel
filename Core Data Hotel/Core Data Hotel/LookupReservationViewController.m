//
//  LookupReservationViewController.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/26/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "LookupReservationViewController.h"
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
    [self setupTableView];
    [self setupSearchBar];
    [self setupSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.allReservations = self.fetchedReservations.fetchedObjects;
    self.filteredReservations = self.allReservations;
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredReservations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 2;
    Reservation *currentReservation = [self.filteredReservations objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, Room %u: \n%@ %@", currentReservation.room.hotel.name, currentReservation.room.number, currentReservation.guest.firstName, currentReservation.guest.lastName];
    
    return cell;
}



- (NSFetchedResultsController *)fetchedReservations {
    if (!_fetchedReservations) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSFetchRequest *reservationRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        NSSortDescriptor *hotelDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"room.hotel.name" ascending:YES];
        NSSortDescriptor *numberDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"room.number" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:hotelDescriptor, numberDescriptor, nil];
        
        reservationRequest.sortDescriptors = sortDescriptors;
        
        NSError *reservationError;
        
        _fetchedReservations = [[NSFetchedResultsController alloc] initWithFetchRequest:reservationRequest
                                                            managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"room.hotel.name" cacheName:nil];
        
        [_fetchedReservations performFetch:&reservationError];
    }
    
    return _fetchedReservations;
}

- (void)setupSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupSubviews {
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    UIView *searchBar = self.searchBar;
    UIView *tableView = self.tableView;
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys: searchBar, @"searchBar", tableView, @"tableView", nil];
    CGFloat height = CGRectGetHeight(self.navigationController.navigationBar.frame) + 20;
    NSNumber *topLayoutHeight = [NSNumber numberWithFloat:(height)];
    NSDictionary *metricsDictionary = @{@"topLayoutHeight": topLayoutHeight};
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBar]|" options:0 metrics:nil views:viewsDictionary]];
     [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:viewsDictionary]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topLayoutHeight-[searchBar][tableView]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"search changed");
    if ([searchText isEqual: @""]) {
        self.filteredReservations = self.allReservations;
    } else {
    self.filteredReservations = [self.allReservations filteredArrayUsingPredicate:[self filterByFirstName:@"guest.firstName" andLastName:@"guest.lastName" usingSearchTerms:searchText]];
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
