//
//  AutoLayoutTest.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/26/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AutoLayout.h"

@interface AutoLayoutTest : XCTestCase

@property(strong, nonatomic) UIViewController *testController;
@property(strong, nonatomic) UIView *testView1;
@property(strong, nonatomic) UIView *testView2;

@end

@implementation AutoLayoutTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.testController = [[UIViewController alloc] init];
    self.testView1 = [[UIView alloc] init];
    self.testView2 = [[UIView alloc] init];
    [self.testController.view addSubview:self.testView1];
    [self.testController.view addSubview:self.testView2];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.testController = nil;
    self.testView1 = nil;
    self.testView2 = nil;
    
    [super tearDown];
}

- (void)testGenericConstraintFromToViewWithAttribute {
    
    id constraint = [AutoLayout genericConstraintFrom:self.testView1 toView:self.testView2 withAttribute:NSLayoutAttributeTop];
    NSLog(@"%@", (NSLayoutConstraint *)constraint);
    
    XCTAssert([constraint isKindOfClass:[NSLayoutConstraint class]], @"constraint is not an instance of NSLayoutConstraint.");
    
    XCTAssertTrue([(NSLayoutConstraint *)constraint isActive], @"constraint was not activated.");
}

- (void)testFullScreenConstraintsWithVFLForView {
    id constraints = [AutoLayout fullScreenConstraintsWithVFLForView:self.testView1];
    
    XCTAssert([constraints isKindOfClass:[NSArray class]], @"Result was not an instance of NSArray.");
    
    NSArray *constraintsArray = (NSArray*)constraints;
    XCTAssert(constraintsArray.count == 4, @"array does not have four constraints");
    
    for (id constraint in constraints) {
        XCTAssert([constraint isKindOfClass:[NSLayoutConstraint class]], @"Element of array is not an NSLayoutConstraint");
        
        XCTAssertTrue([(NSLayoutConstraint *)constraint isActive], @"constraint was not activated.");
    }

}

- (void)testLeadingConstraintFromViewToView {
    id constraint = [AutoLayout leadingConstraintFrom:self.testView1 toView:self.testView2];
    
    XCTAssertTrue([constraint isKindOfClass:[NSLayoutConstraint class]], @"Result was not an instance of NSLayoutConstraint");
    
    NSLayoutConstraint *typecastConstraint = (NSLayoutConstraint*)constraint;
    
    XCTAssertTrue((typecastConstraint.firstAttribute == NSLayoutAttributeLeading && typecastConstraint.secondAttribute == NSLayoutAttributeLeading), @"Constraint attribute was not set to leading.");
}

- (void)testTrailingConstraintFromToView {
    id constraint = [AutoLayout trailingConstraintFrom:self.testView1 toView:self.testView2];
    
    XCTAssertTrue([constraint isKindOfClass:[NSLayoutConstraint class]], @"Result was not an instance of NSLayoutConstraint");
    
    NSLayoutConstraint *typecastConstraint = (NSLayoutConstraint*)constraint;
    
    XCTAssertTrue((typecastConstraint.firstAttribute == NSLayoutAttributeTrailing && typecastConstraint.secondAttribute == NSLayoutAttributeTrailing), @"Constraint attribute was not set to trailing.");
}

- (void)testTopConstraintFromToViewWithOffset {
    CGFloat testCGFloat = 10.0;
    id constraint = [AutoLayout topConstraintFrom:self.testView1
                                           toView:self.testView2
                                       withOffset:testCGFloat];
    
    XCTAssertTrue([constraint isKindOfClass:[NSLayoutConstraint class]], @"Result was not an instance of NSLayoutConstraint.");
    
    NSLayoutConstraint *typecastConstraint = (NSLayoutConstraint*)constraint;
    
    XCTAssertTrue((typecastConstraint.constant == testCGFloat), @"Constant on output was not equal to input.");
}

@end
