//
//  RoomsViewController.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/24/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "RoomsViewController.h"
#import "AppDelegate.h"

#import "Room+CoreDataProperties.h"
#import "Room+CoreDataClass.h"


@interface RoomsViewController () <UITableViewDataSource>

@property (strong, nonatomic) NSArray *roomsInHotel;
@property (strong, nonatomic) UITableView *roomTableView;

@end

@implementation RoomsViewController

-(void)loadView {
    [super loadView];
    
    // Add tableView as subview and apply constraints
    self.roomTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.roomTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.roomTableView.dataSource = self;
    [self.roomTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"roomCell"];
    self.roomsInHotel = [[self.hotel rooms] allObjects];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self roomsInHotel].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"roomCell" forIndexPath:indexPath];
    int index = (int)indexPath.row;
    Room *room = [self.roomsInHotel objectAtIndex:index];
    
    cell.textLabel.text = [[NSNumber numberWithUnsignedInteger:room.number] stringValue];
    return cell;
}


@end
