//
//  AutoLayout.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/24/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "AutoLayout.h"

@implementation AutoLayout

+(NSArray *)fullScreenConstraintsWithVFLForView:(UIView *)view {
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    NSDictionary *viewDictionary = @{@"view": view};
    
    NSArray *horizontalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|[view]|"
                                      options:0
                                      metrics:nil
                                      views:viewDictionary];
    
    NSArray *verticalConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|[view]|"
                                      options:0
                                      metrics:nil
                                      views:viewDictionary];
    
    [constraints addObjectsFromArray:horizontalConstraints];
    [constraints addObjectsFromArray:verticalConstraints];
    [NSLayoutConstraint activateConstraints:constraints];
    
    return constraints.copy;
}

+(NSLayoutConstraint *)genericConstraintFrom:(UIView *)view
                                      toView:(UIView *)superView
                               withAttribute:(NSLayoutAttribute)attribute
                               andMultiplier:(CGFloat)multiplier {
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:attribute
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:superView
                                      attribute:attribute
                                      multiplier:multiplier
                                      constant:0.0];
    constraint.active = YES;
    return constraint;
}

+(NSLayoutConstraint *)genericConstraintFrom:(UIView *)view
                                      toView:(UIView *)superView
                               withAttribute:(NSLayoutAttribute)attribute {
    
    return [AutoLayout genericConstraintFrom:view toView:superView withAttribute:attribute andMultiplier:1.0];
}

+(NSLayoutConstraint *)equalHeightConstraintFromView:(UIView *)view
                                              toView:(UIView *)otherView
                                      withMultiplier:(CGFloat)multiplier {
    
    NSLayoutConstraint *heightConstraint = [AutoLayout
                                            genericConstraintFrom:view
                                            toView:otherView
                                            withAttribute:NSLayoutAttributeHeight
                                            andMultiplier:multiplier];
    return heightConstraint;
}

+(NSLayoutConstraint *)equalWidthConstraintFromView:(UIView *)view
                                             toView:(UIView *)otherView
                                     withMultiplier:(CGFloat)multiplier {
    
    NSLayoutConstraint *widthConstraint = [AutoLayout genericConstraintFrom:view
                                                                     toView:otherView
                                                              withAttribute:NSLayoutAttributeWidth
                                                              andMultiplier:multiplier];
    return widthConstraint;
}

+(NSLayoutConstraint *)leadingConstraintFrom:(UIView *)view
                                      toView:(UIView *)otherView{
    
    return [AutoLayout genericConstraintFrom:view toView:otherView withAttribute:NSLayoutAttributeLeading];
    
}

+(NSLayoutConstraint *)trailingConstraintFrom:(UIView *)view
                                       toView:(UIView *)otherView{
    return [AutoLayout genericConstraintFrom:view toView:otherView withAttribute:NSLayoutAttributeTrailing];
}

+(NSLayoutConstraint *)topConstraintFrom:(UIView *)view
                                  toView:(UIView *)otherView{
    return [AutoLayout genericConstraintFrom:view
                                      toView:otherView
                               withAttribute:NSLayoutAttributeTop];
}

+ (NSLayoutConstraint *)height:(CGFloat)height forView:(UIView *)view {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
    constraint.active = YES;
    return constraint;
}
+ (NSLayoutConstraint *)width:(CGFloat)width forView:(UIView *)view {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    constraint.active = YES;
    return constraint;
}

+ (NSLayoutConstraint *)topConstraintFrom:(UIView *)view toView:(UIView *)otherView withOffset:(CGFloat)offset {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeTop multiplier:1.0 constant:offset];
    constraint.active = YES;
    return constraint;
}


@end
