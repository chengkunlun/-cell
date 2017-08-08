//
//  XYViewController.m
//  XYRearrangeCell
//
//  Created by mofeini on 16/11/8.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYViewController.h"
#import "XYRearrangeView.h"
#import "XYPlanItem.h"
#import "XYCollectionViewCell.h"

@interface XYViewController () <UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *plans;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@end

@implementation XYViewController
static NSString * const reuseIdentifier = @"Cell";

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = [UIScreen mainScreen].bounds.size.width / 2 - 5;
        CGFloat itemH = 100;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _flowLayout = flowLayout;
    }
    return _flowLayout;
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionView *collectionView = [UICollectionView xy_collectionViewLayout:self.flowLayout originalDataBlock:^NSArray *{
            return self.plans;
        } callBlckNewDataBlock:^(NSArray *newData) {
            [self.plans removeAllObjects];
            [self.plans addObjectsFromArray:newData];
        }];
        
        collectionView.dataSource = self;
        self.collectionView = collectionView;
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}
- (NSMutableArray *)plans {
    if (_plans == nil) {
        _plans = [NSMutableArray array];
    }
    return _plans;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XYCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self makeCollectionViewConstr];
    self.collectionView.backgroundColor = xColorWithRGB(200, 200, 200);
    self.collectionView.rollingColor = [UIColor blueColor];
    self.collectionView.autoRollCellSpeed = 10;
    
    [self setupPlans];
    
    self.navigationItem.title = @"CollectionView";
    

}



- (void)makeCollectionViewConstr {
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:0 views:views]];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // 判断是不是嵌套数组
    if ([collectionView xy_nestedArrayCheck:self.plans]) {
        return self.plans.count;
    }
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 判断是不是嵌套数组
    if ([collectionView xy_nestedArrayCheck:self.plans]) {
        NSArray *array = self.plans[section];
        return array.count;
    }
    return self.plans.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    XYPlanItem *item = nil;
    
    // 检测是不是嵌套数组
    if ([collectionView xy_nestedArrayCheck:self.plans]) {
        item = self.plans[indexPath.section][indexPath.item];
    } else {
        item = self.plans[indexPath.row];
    }
    
    cell.planItem = item;
    cell.backgroundColor = xRandomColor;
    
    return cell;
}


#pragma mark - 非嵌套数组的数据
- (void)setupPlans {
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]
                                                       pathForResource:@"plans.plist"
                                                       ofType:nil]];
    
    for (id obj in array) {
        XYPlanItem *item = [XYPlanItem planItemWithDict:obj];
        [self.plans addObject:item];
    }
    
}

@end
