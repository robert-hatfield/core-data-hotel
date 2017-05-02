//
//  ViewController.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/24/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

@import Crashlytics;

#import "ViewController.h"
#import "AutoLayout.h"
#import "HotelsViewController.h"
#import "DatePickerViewController.h"
#import "LookupReservationViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void) loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupLayout];
}

-(void) setupLayout {
    
    CGFloat topLayoutHeight = CGRectGetHeight(self.navigationController.navigationBar.frame) + 20;
    CGFloat buttonHeight = (self.view.bounds.size.height - topLayoutHeight) / 3;

    UIButton *browseButton = [self createButtonWithTitle:@"Browse"];
    UIButton *bookButton = [self createButtonWithTitle:@"Book"];
    UIButton *lookupButton = [self createButtonWithTitle:@"Look Up"];
    
    browseButton.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.75 alpha:1.0];
    bookButton.backgroundColor = [UIColor redColor];
    lookupButton.backgroundColor = [UIColor grayColor];
    NSArray *buttons = [NSArray arrayWithObjects:browseButton, bookButton, lookupButton, nil];
    
    for (UIButton *button in buttons) {
        [AutoLayout height:buttonHeight forView:button];

        [AutoLayout leadingConstraintFrom:button toView:self.view];
        [AutoLayout trailingConstraintFrom:button toView:self.view];
    }
    [AutoLayout topConstraintFrom:browseButton toView:self.view withOffset:topLayoutHeight];
    [AutoLayout topConstraintFrom:bookButton toView:self.view withOffset:buttonHeight + topLayoutHeight];
    [AutoLayout topConstraintFrom:lookupButton toView:self.view withOffset:buttonHeight * 2 + topLayoutHeight];
    
    
    // Set up button actions
    [browseButton addTarget:self action:@selector(browseButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [bookButton addTarget:self action:@selector(bookButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    [lookupButton addTarget:self action:@selector(lookupButtonSelected) forControlEvents:UIControlEventTouchUpInside];
}

-(void) browseButtonSelected {
    [Answers logCustomEventWithName:@"ViewController - Browse button selected" customAttributes:nil];
    HotelsViewController *hotelsVC = [[HotelsViewController alloc] init];
    [self.navigationController pushViewController:hotelsVC animated:YES];
}

-(void) bookButtonSelected {
    [Answers logCustomEventWithName:@"ViewController - Book button selected" customAttributes:nil];
    DatePickerViewController *datePickerVC = [[DatePickerViewController alloc] init];
    [self.navigationController pushViewController:datePickerVC animated:YES];
}

-(void) lookupButtonSelected {
    [Answers logCustomEventWithName:@"ViewController - Lookup button selected" customAttributes:nil];
    LookupReservationViewController *lookupVC = [[LookupReservationViewController alloc] init];
    [self.navigationController pushViewController:lookupVC animated:YES];
}

-(UIButton *) createButtonWithTitle:(NSString *) title {
    UIButton *button = [[UIButton alloc] init];
    
    [button setTitle:title forState:normal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:button];
    
    return button;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
