//
//  HotelsViewController.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/24/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "HotelsViewController.h"
#import "AppDelegate.h"

#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"

@interface HotelsViewController () <UITableViewDataSource>

@property (strong, nonatomic) NSArray *allHotels;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation HotelsViewController

-(void)loadView {
    [super loadView];
    
    // Add tableView as subview and apply constraints
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

-(NSArray *)allHotels {
    if (!_allHotels) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
        
        NSError *fetchError;
        NSArray *hotels = [context executeFetchRequest:request error:&fetchError];
        
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    int index = (int)indexPath.row;
    Hotel *hotel = [[self allHotels ] objectAtIndex:index];
    cell.textLabel.text = hotel.name;
    
    return cell;
}



@end
