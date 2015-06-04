//
//  UIView+AutoLayout.m
//  zhaopin
//
//  Created by xincc on 11/5/14.
//  Copyright (c) 2015 __my_company. All rights reserved.
//
#import "UIView+AutoLayout.h"

ALMargin ALMarginMake(CGFloat l,CGFloat r, CGFloat t, CGFloat b){
    ALMargin  res ;
    res.LeftMargin = l;
    res.RightMargin = r;
    res.TopMargin = t;
    res.BottomMargin = b;
    return res;
};

ALMargin ALMarginMakeLeft(CGFloat l) {
    return ALMarginMake(l, 0.f, 0.f, 0.f);
}
ALMargin  ALMarginMakeRight(CGFloat r) {
    return ALMarginMake(0.f, r, 0.f, 0.f);
}
ALMargin  ALMarginMakeTop(CGFloat t) {
    return ALMarginMake(0.f, 0.f, t, 0.f);
}
ALMargin  ALMarginMakeBottom(CGFloat b) {
    return ALMarginMake(0.f, 0.f, 0.f, b);
}
ALMargin  ALMarginZero(){
    return ALMarginMake(0.f, 0.f, 0.f, 0.f);
}

@implementation UIView (AutoLayout)


#pragma mark -
#pragma mark - Tools


UIKIT_STATIC_INLINE void cleanRemoveFromSuperview(UIView * view ) {
    
    view.translatesAutoresizingMaskIntoConstraints = NO;

    if(!view || !view.superview) return;
    
    [view layoutIfNeeded];
    
    //clear superview's constrants related self
    NSMutableArray * constraints_to_remove = [NSMutableArray new];
    UIView * superview = view.superview;
    
    for( NSLayoutConstraint * constraint in superview.constraints) {
        if( constraint.firstItem == view || constraint.secondItem == view ) {
            [constraints_to_remove addObject:constraint];
        }
    }
    [superview removeConstraints:constraints_to_remove];
    
    //clear self's constrants
    [view removeFromSuperview];
}

- (void)removeView:(UIView*)view{
    
    cleanRemoveFromSuperview(view);
    if ([self.subviews containsObject:view]) {
        [view removeFromSuperview];
    }
}

- (void)addConstraintToView:(UIView*)view withMargin:(ALMargin)margin
{
    NSDictionary * dic = @{@"view":view};
    NSDictionary * metrics = @{
                               @"left":     @(margin.LeftMargin),
                               @"right":    @(margin.RightMargin),
                               @"top":      @(margin.TopMargin),
                               @"bottom":   @(margin.BottomMargin)
                               };
    
    NSString * formatH = @"|-left-[view]-right-|";
    NSString * formatV = @"V:|-top-[view]-bottom-|";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatH options:0 metrics:metrics views:dic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatV options:0 metrics:metrics views:dic]];
}


#pragma mark -
#pragma mark - Fill Layout

- (void)addSubview:(UIView*)view fillByMargin:(ALMargin)margin
{
    [self removeView:view];
    [self addSubview:view];
    [self addConstraintToView:view withMargin:margin];
}
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index fillByMargin:(ALMargin)margin
{
    [self removeView:view];
    [self insertSubview:view atIndex:index];
    [self addConstraintToView:view withMargin:margin];
}

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview fillByMargin:(ALMargin)margin
{
    [self removeView:view];
    [self insertSubview:view aboveSubview:siblingSubview];
    [self addConstraintToView:view withMargin:margin];
}
- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview fillByMargin:(ALMargin)margin
{
    [self removeView:view];
    [self insertSubview:view belowSubview:siblingSubview];
    [self addConstraintToView:view withMargin:margin];
}


#pragma mark -
#pragma mark - Flow Layout


- (void)addSubviews:(NSArray*)views flowLayoutDirection:(ALLayoutDirection)direction fillByMargin:(ALMargin )margin
{
    if (![views.firstObject isKindOfClass:UIView.class]) {
        NSLog(@"CCAutoLayout error: items should be kind of UIView object and can not be nil");
        return;
    }
    NSMutableDictionary * items = [NSMutableDictionary dictionary];
    NSMutableString * formartH = [NSMutableString stringWithFormat:@""];
    NSMutableString * formartV = [NSMutableString stringWithFormat:@""];
    
    //get layout data
    NSMutableArray * orderedKey = [NSMutableArray arrayWithCapacity:views.count];
    for (NSUInteger i = 0; i < views.count; i++) {
        UIView * value = views[i];
        cleanRemoveFromSuperview(value);
        [self addSubview:value];
        NSString * key = [NSString stringWithFormat:@"%@%zd",@"view",i];
        [items setValue:value forKey:key];
        [orderedKey addObject:key];
    }
    
    NSDictionary * metrics = @{
                               @"left":     @(margin.LeftMargin),
                               @"right":    @(margin.RightMargin),
                               @"top":      @(margin.TopMargin),
                               @"bottom":   @(margin.BottomMargin)
                               };
    
    //config VFL
    
    if (direction == ALLayoutDirectionHorizontal) {
        //Horizontal flow layout
        
        //`leading`,`top`,`bottom` space to super view for first view
        [formartH appendFormat:@"|-left-[%@]",orderedKey.firstObject];
        formartV = [NSMutableString stringWithFormat:@"V:|-top-[%@]-bottom-|",orderedKey.firstObject];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formartV options:0 metrics:metrics views:items]];
        
        //`top`,`buttom` space to super view for each subview except first view
        for (int i = 1; i < orderedKey.count ; i++) {
            [formartH appendFormat:@"[%@(==%@)]",orderedKey[i],orderedKey[i-1]];
            formartV = [NSMutableString stringWithFormat:@"V:|-top-[%@]-bottom-|",orderedKey[i]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formartV options:0 metrics:metrics views:items]];
        }
        
        //`trailing` space to superview for last view
        [formartH appendString:@"-right-|"];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formartH options:0 metrics:metrics views:items]];
        
    } else if (direction == ALLayoutDirectionVertical){
        //Vertical flow layout
        
        //`top`,`leading`,`trailing` space to superview for first view
        [formartV appendFormat:@"V:|-top-[%@]",orderedKey.firstObject];
        formartH = [NSMutableString stringWithFormat:@"|-left-[%@]-right-|",orderedKey.firstObject];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formartH options:0 metrics:metrics views:items]];
        
        //leading & trailing space to superview for each subview except first view
        for (int i = 1; i < orderedKey.count ; i++) {
            [formartV appendFormat:@"[%@(==%@)]",orderedKey[i],orderedKey[i-1]];
            formartH = [NSMutableString stringWithFormat:@"|-left-[%@]-right-|",orderedKey[i]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formartH options:0 metrics:metrics views:items]];
        }
        
        //`bottom` space to superview for last view
        [formartV appendString:@"-bottom-|"];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formartV options:0 metrics:metrics views:items]];
    } else {
        
    }
    
}
@end
