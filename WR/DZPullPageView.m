//
//  DZPullPageView.m
//  WR
//
//  Created by stonedong on 14/11/17.
//  Copyright (c) 2014年 stonedong. All rights reserved.
//

#import "DZPullPageView.h"

@interface DZPullPageItemView ()
@property (nonatomic, assign) NSInteger index;
@end
@implementation DZPullPageItemView


@end

@interface DZPullPageView  ()
{
    CGPoint _lastPoint;
    CGPoint _currentPoint;
    BOOL _isChanging;
    
    NSUInteger _numberOfItems;
    NSUInteger _currentIndex;
    
    CGPoint _startPoint;
    
}
@end


@implementation DZPullPageView

- (void) page_commonInit
{
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:pan];
    
    _isChanging = NO;
    _lastPoint = CGPointZero;
}


- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    [self page_commonInit];
    return self;
}

- (DZPullPageItemView*) __pullPageItemViewAtIndex:(NSInteger)index
{
    NSArray* allSubviews = [self.subviews copy];
    for (UIView* aView in allSubviews) {
        if ([aView isKindOfClass:[DZPullPageItemView class]]) {
            DZPullPageItemView* item = (DZPullPageItemView*)aView;
            if (item.index == index) {
                return item;
            }
        }
    }
    return nil;
}
- (DZPullPageItemView*) currentPageItem
{
    if (_currentIndex >= _numberOfItems) {
        return nil;
    }
    DZPullPageItemView* item = [self __pullPageItemViewAtIndex:_currentIndex];
    if (item) {
        return item;
    }
    item = [self.sourceDelegate itemViewForPullPageView:self atIndex:_currentIndex];
    item.index = _currentIndex;
    return item;
}

- (DZPullPageItemView*) topPageItem
{
    if (_currentIndex < 1) {
        return nil;
    }
    DZPullPageItemView* item = [self __pullPageItemViewAtIndex:_currentIndex - 1];
    if (item) {
        return item;
    }
    item = [self.sourceDelegate itemViewForPullPageView:self atIndex:_currentIndex - 1];
    item.index = _currentIndex -1;
    return item;
}

- (DZPullPageItemView*) bottomPageItem
{
    if (_currentIndex + 1 >= _numberOfItems) {
        return nil;
    }
    DZPullPageItemView* item = [self __pullPageItemViewAtIndex:_currentIndex+1];
    if (item) {
        return item;
    }
    item = [self.sourceDelegate itemViewForPullPageView:self atIndex:_currentIndex+1];
    item.index = _currentIndex + 1;
    return item;
}
- (void) handlePanGesture:(UIPanGestureRecognizer*)pRcgz
{
    switch (pRcgz.state) {
        case UIGestureRecognizerStateBegan:
            _isChanging = YES;
            _lastPoint = [pRcgz locationInView:self];
            _startPoint = _lastPoint;
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [pRcgz locationInView:self];
            _currentPoint = point;
            [self layoutSubviews ];
            
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            _isChanging = NO;
            CGFloat offset = _currentPoint.y - _startPoint.y;
            if (offset > 160) {
                _currentIndex -= 1;
            } else if (offset < -160) {
                _currentIndex += 1;
            }
            _lastPoint = CGPointZero;
            _startPoint = CGPointZero;
            
            [self setNeedsLayout];
            break;
        }
        default:
            break;
    }
}

#define TopItemDefaultRect CGRectOffset(self.bounds, 0, - CGRectGetHeight(self.bounds))

#define BottomItemDefaultRect CGRectOffset(self.bounds, 0, CGRectGetHeight(self.bounds))

- (void) layoutSubviews
{
    if (_isChanging) {
     
        CGFloat offset = _currentPoint.y - _startPoint.y;
        if (offset > 0) {
            DZPullPageItemView* topItem = [self topPageItem];
            if (topItem) {
                topItem.frame = CGRectOffset(TopItemDefaultRect, 0, offset);
                DZPullPageItemView* currentItem = [self currentPageItem];
                [self addSubview:currentItem];
                [self addSubview:topItem];
                currentItem.transform = CGAffineTransformMakeScale(0.8, 0.8);
               
            }
        } else {
            
            DZPullPageItemView* bottomItemView = [self bottomPageItem];
            if (bottomItemView) {
                DZPullPageItemView* currentItem = [self currentPageItem];
                
                [self insertSubview:bottomItemView belowSubview:currentItem];
                
                currentItem.frame = CGRectOffset(self.bounds, 0, offset);
                bottomItemView.frame = CGRectOffset(BottomItemDefaultRect, 0, offset);
                
                bottomItemView.transform =  CGAffineTransformMakeScale(0.8, 0.8);
            }
        }
        
        _lastPoint = _currentPoint;
    } else {
        DZPullPageItemView* currentItemView = [self currentPageItem];
        [self addSubview:currentItemView];
        currentItemView.frame = self.bounds;
        
        NSArray* allSubviews = [self.subviews copy];
        for (UIView* each  in allSubviews) {
            if (each == currentItemView) {
                continue;
            }
            [each removeFromSuperview];
        }
    }
}

- (void) reloadData
{
    NSAssert(self.sourceDelegate, @"没有设置sourceDelegate");
    NSAssert([self.sourceDelegate respondsToSelector:@selector(numberOfItemInPullPageView:)], @"sourceDelegate 没有实现numberOfItemInPullPageView");
     NSAssert([self.sourceDelegate respondsToSelector:@selector(itemViewForPullPageView:atIndex:)], @"sourceDelegate 没有实现itemViewForPullPageView:atIndex:");
    
    _numberOfItems = [self.sourceDelegate numberOfItemInPullPageView:self];
    _currentIndex = 0;
    [self setNeedsLayout];
}
@end
