//
//  DatePickerViewController.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/25/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "DatePickerViewController.h"
#import "AvailabilityViewController.h"

@interface DatePickerViewController ()

@property (strong, nonatomic) UIDatePicker *endDate;

@end

@implementation DatePickerViewController

-(void)loadView {
    [super loadView];
    [self setupDatePickers];
    [self setupDoneButton];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

-(void)setupDoneButton {
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(doneButtonPressed)];
    
    [self.navigationItem setRightBarButtonItem:doneButton];
}

-(void)doneButtonPressed {
    NSDate *endDate = self.endDate.date;
    
    if ([[NSDate date] timeIntervalSinceReferenceDate] > [endDate timeIntervalSinceReferenceDate]) {
        NSLog(@"This date is in the past!");
        self.endDate.date = [NSDate date];
        return;
    }
    
    AvailabilityViewController *availabilityVC = [[AvailabilityViewController alloc] init];
    [self.navigationController pushViewController:availabilityVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupDatePickers {
    self.endDate = [[UIDatePicker alloc] init];
    self.endDate.datePickerMode = UIDatePickerModeDate;
    
    // change this to use constraints instead of frames for lab assignment
    self.endDate.frame = CGRectMake(0, 84.0, self.view.frame.size.width, 200.0);
    [self.view addSubview:self.endDate];
}

@end
