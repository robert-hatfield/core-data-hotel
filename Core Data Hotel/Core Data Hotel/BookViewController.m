//
//  BookViewController.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/25/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "BookViewController.h"
@import Crashlytics;

#import "AutoLayout.h"
#import "HotelService.h"

@interface BookViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *firstNameField;
@property (strong, nonatomic) UITextField *lastNameField;
@property (strong, nonatomic) UITextField *emailField;

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
    self.firstNameField = [[UITextField alloc] init];
    self.firstNameField.placeholder = @"First name";
    self.lastNameField = [[UITextField alloc] init];
    self.lastNameField.placeholder = @"Last name";
    self.emailField = [[UITextField alloc] init];
    self.emailField.placeholder = @"Email address";
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    NSArray *textFields = [NSArray arrayWithObjects:self.firstNameField, self.lastNameField, self.emailField, nil];
    
    for (UITextField *textField in textFields) {
        [self.view addSubview:textField];
        textField.delegate = self;
        
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.spellCheckingType = UITextSpellCheckingTypeNo;
        [AutoLayout leadingConstraintFrom:textField toView:self.view];
        [AutoLayout trailingConstraintFrom:textField toView:self.view];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkReservationInput) name:UITextFieldTextDidChangeNotification object:nil];
    
    CGFloat topLayoutHeight = CGRectGetHeight(self.navigationController.navigationBar.frame) + 20;
    [AutoLayout topConstraintFrom:self.firstNameField toView:self.view withOffset:topLayoutHeight + 8];
    [AutoLayout topConstraintFrom:self.lastNameField toView:self.firstNameField withOffset: topLayoutHeight + self.firstNameField.bounds.size.height + 8];
    [AutoLayout topConstraintFrom:self.emailField toView:self.lastNameField withOffset:topLayoutHeight + self.lastNameField.bounds.size.height + 8];

}

- (void)setupBookButton {
    UIBarButtonItem *bookReservationButton= [[UIBarButtonItem alloc] initWithTitle:@"Book Reservation" style:UIBarButtonItemStyleDone target:self action:@selector(bookReservation)];
    [self.navigationItem setRightBarButtonItem:bookReservationButton];
    [bookReservationButton setEnabled:NO];
    
}

- (void)checkReservationInput {
    // Ensure text is present for first & last name
    if (self.firstNameField.text.length && self.lastNameField.text.length) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (void)bookReservation {
    BOOL reservationBookedSuccessfully = [HotelService bookReservationForRoom:self.room
                                starting:self.startDate
                               andEnding:self.endDate
                            forFirstName:self.firstNameField.text
                                lastName:self.lastNameField.text
                        withEmailAddress:self.lastNameField.text];
    
    if (reservationBookedSuccessfully) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSLog(@"An error occurred when booking reservation; please check analytics logs.");
    }
}

@end
