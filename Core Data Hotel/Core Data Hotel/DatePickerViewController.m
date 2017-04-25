//
//  DatePickerViewController.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/25/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "DatePickerViewController.h"
#import "AvailabilityViewController.h"
#import "AutoLayout.h"

@interface DatePickerViewController ()

@property (strong, nonatomic) UIDatePicker *startDate;
@property (strong, nonatomic) UIDatePicker *endDate;
@property (strong, nonatomic) NSCalendar *calendar;

@end

@implementation DatePickerViewController

-(void)loadView {
    [super loadView];
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

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
    NSDate *startDate = self.startDate.date;
    NSDate *endDate = self.endDate.date;

    AvailabilityViewController *availabilityVC = [[AvailabilityViewController alloc] init];
    availabilityVC.startDate = startDate;
    availabilityVC.endDate = endDate;
    [self.navigationController pushViewController:availabilityVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)updateEndDate {
    self.endDate.minimumDate = [self.calendar dateByAddingUnit:NSCalendarUnitDay
                                                  value:1
                                                 toDate:self.startDate.date
                                                options:NSCalendarMatchFirst];
}

- (void)setupDatePickers {
    self.startDate = [[UIDatePicker alloc] init];
    self.endDate = [[UIDatePicker alloc] init];
    
    NSArray *datePickers = [NSArray arrayWithObjects:self.startDate, self.endDate, nil];
    
    for (UIDatePicker *picker in datePickers) {
        picker.datePickerMode = UIDatePickerModeDate;
        picker.minimumDate = [NSDate date];
        [self.view addSubview:picker];
        picker.translatesAutoresizingMaskIntoConstraints = NO;
        [AutoLayout leadingConstraintFrom:picker toView:self.view];
        [AutoLayout trailingConstraintFrom:picker toView:self.view];
    }
    
    [self updateEndDate];
    [self.startDate addTarget:self action:@selector(updateEndDate) forControlEvents:UIControlEventValueChanged];
    CGFloat topLayoutHeight = CGRectGetHeight(self.navigationController.navigationBar.frame) + 20;
    [AutoLayout topConstraintFrom:self.startDate toView:self.view withOffset:topLayoutHeight];
    [AutoLayout topConstraintFrom:self.endDate toView:self.view withOffset:self.startDate.frame.size.height];
}

@end
