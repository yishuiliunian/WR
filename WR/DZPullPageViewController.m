//
//  DZPullPageViewController.m
//  WR
//
//  Created by stonedong on 14/11/17.
//  Copyright (c) 2014年 stonedong. All rights reserved.
//

#import "DZPullPageViewController.h"
#import "DZPullPageView.h"
#import <DZProgramDefines.h>
@interface DZTestItemView : DZPullPageItemView
DEFINE_PROPERTY_STRONG_READONLY(UILabel*, label);
@end


@implementation DZTestItemView

- (void) item_commonInit
{
    INIT_SELF_SUBVIEW_UILabel(_label);
}
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    _label.frame = self.bounds;
}
@end
@interface DZPullPageViewController () <DZPullPageViewSourceDelegate>
@property (nonatomic, strong, readonly) DZPullPageView* pullPageView;
@end

@implementation DZPullPageViewController

- (void) loadView
{
    DZPullPageView* pageView = [DZPullPageView new];
    self.view = pageView;
    _pullPageView = pageView;
    _pullPageView.sourceDelegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pullPageView reloadData];
}
- (NSUInteger) numberOfItemInPullPageView:(DZPullPageView *)pullView
{
    return 10;
}
- (DZPullPageItemView*) itemViewForPullPageView:(DZPullPageView *)pullView atIndex:(NSInteger)index
{
    DZTestItemView* itemView = [DZTestItemView new];
    if (index%3 == 0) {
        itemView.backgroundColor =[UIColor redColor];
    } else if (index%3 == 1) {
        itemView.backgroundColor = [UIColor greenColor];
    } else if (index%3 == 2) {
        itemView.backgroundColor = [UIColor blueColor];
    }
    itemView.label.text = [@(index) stringValue];
    return itemView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
