//
//  DZPullPageView.h
//  WR
//
//  Created by stonedong on 14/11/17.
//  Copyright (c) 2014年 stonedong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DZPullPageView;

@interface DZPullPageItemView : UIView

@end

@protocol DZPullPageViewSourceDelegate <NSObject>

- (NSUInteger) numberOfItemInPullPageView:(DZPullPageView*)pullView;
- (DZPullPageItemView*) itemViewForPullPageView:(DZPullPageView*)pullView  atIndex:(NSInteger)index;

@end
@interface DZPullPageView : UIView
@property (nonatomic, weak) id<DZPullPageViewSourceDelegate> sourceDelegate;

- (void) reloadData;
@end
