//
//  BookViewController.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/25/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "BookViewController.h"

@interface BookViewController ()

@end

@implementation BookViewController

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupBookView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupBookView {
    [self setupBookButton];
    
}

- (void)setupBookButton {
    UIBarButtonItem *bookReservationButton= [[UIBarButtonItem alloc] initWithTitle:@"Book Reservation" style:UIBarButtonItemStyleDone target:self action:@selector(bookReservation)];
    [self.navigationItem setRightBarButtonItem:bookReservationButton];
}

- (void)bookReservation {
    
}

@end
