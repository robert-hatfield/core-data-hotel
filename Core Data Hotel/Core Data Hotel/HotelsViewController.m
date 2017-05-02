//
//  HotelsViewController.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/24/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "HotelsViewController.h"
#import "CoreDataStack.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"
#import "RoomsViewController.h"

@interface HotelsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *allHotels;
@property (strong, nonatomic) UITableView *hotelTableView;

@end

@implementation HotelsViewController

-(void)loadView {
    [super loadView];
    
    // Add tableView as subview and apply constraints
    self.hotelTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
    [self.view addSubview:self.hotelTableView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.hotelTableView.dataSource = self;
    self.hotelTableView.delegate = self;
    [self.hotelTableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cell"];
    
}

-(NSArray *)allHotels {
    if (!_allHotels) {        
        NSManagedObjectContext *context = [[[CoreDataStack shared] persistentContainer] viewContext];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
        
        NSError *fetchError;
        NSArray *hotels = [context executeFetchRequest:request
                                                 error:&fetchError];
        
        if (fetchError) {
            NSLog(@"An error occurred while fetching hotels from Core Data.");
        }
        
        _allHotels = hotels;
    }
    
    return _allHotels;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self allHotels].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    int index = (int)indexPath.row;
    Hotel *hotel = [[self allHotels] objectAtIndex:index];
    cell.textLabel.text = hotel.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomsViewController *roomsVC = [[RoomsViewController alloc] init];
    
    roomsVC.hotel = [[self allHotels] objectAtIndex:(int) indexPath.row];
    
    [self.navigationController pushViewController:roomsVC animated:YES];

}

@end
