//
//  ViewController.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/24/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "ViewController.h"
#import "AutoLayout.h"

@interface ViewController ()

@end

@implementation ViewController

-(void) loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupLayout];
}

-(void) setupLayout {
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    UIButton *browseButton = [self createButtonWithTitle:@"Browse"];
    UIButton *bookButton = [self createButtonWithTitle:@"Book"];
    UIButton *lookupButton = [self createButtonWithTitle:@"Look Up"];
    
    browseButton.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.75 alpha:1.0];
    
    NSArray *buttons = [NSArray arrayWithObjects:browseButton, bookButton, lookupButton, nil];
    
    [AutoLayout leadingConstraintFrom:browseButton toView:self.view];
    [AutoLayout trailingConstraintFrom:browseButton toView:self.view];
    
    NSLayoutConstraint *browseButtonheight = [AutoLayout equalHeightConstraintFromView:browseButton toView:self.view withMultiplier:0.33];
    
    // TODO: offset by height of navbar
//    browseButtonheight.constant = navBarHeight;
    
    [browseButton addTarget:self action:@selector(browseButtonSelected) forControlEvents:UIControlEventTouchUpInside];
}

-(void) browseButtonSelected {
    NSLog(@"Browse button was selected.");
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
