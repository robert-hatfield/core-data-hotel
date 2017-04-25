//
//  AutoLayout.h
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/24/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

@import UIKit;

@interface AutoLayout : NSObject

+(NSLayoutConstraint *)genericConstraintFrom:(UIView *)view
                                      toView:(UIView *)superView
                               withAttribute:(NSLayoutAttribute)attribute
                               andMultiplier:(CGFloat)multiplier;

+(NSLayoutConstraint *)genericConstraintFrom:(UIView *)view
                                      toView:(UIView *)superView
                               withAttribute:(NSLayoutAttribute)attribute;

+(NSArray *)fullScreenConstraintsWithVFLForView:(UIView *)view;

+(NSLayoutConstraint *)equalHeightConstraintFromView:(UIView *)view
                                              toView:(UIView *)otherView
                                      withMultiplier:(CGFloat)multiplier;

+(NSLayoutConstraint *)leadingConstraintFrom:(UIView *)view
                                      toView:(UIView *)otherView;

+(NSLayoutConstraint *)trailingConstraintFrom:(UIView *)view
                                       toView:(UIView *)otherView;

+(NSLayoutConstraint *)topConstraintFrom:(UIView *)view
                                  toView:(UIView *)otherView;

+ (NSLayoutConstraint *)height:(CGFloat)height forView:(UIView *)view;

+ (NSLayoutConstraint *)width:(CGFloat)width forView:(UIView *)view;

+ (NSLayoutConstraint *)topConstraintFrom:(UIView *)view toView:(UIView *)otherView withOffset:(CGFloat)offset;
@end
