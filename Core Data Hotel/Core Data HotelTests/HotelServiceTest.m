//
//  HotelServiceTest.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 5/1/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HotelService.h"

@interface HotelServiceTest : XCTestCase

@end

@implementation HotelServiceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testBookReservationForRoomStartingAndEndingForFirstNameLastNameWithEmailAddress {
    [HotelService bookReservationForRoom:<#(id)#>
                                starting:<#(NSDate *)#>
                               andEnding:<#(NSDate *)#>
                            forFirstName:<#(NSString *)#>
                                lastName:<#(NSString *)#>
                        withEmailAddress:<#(NSString *)#>];
}

- (void)testGetResultsControllerWithEndDate{
    [HotelService getResultsControllerWithEndDate:<#(NSDate *)#>];
}

@end
