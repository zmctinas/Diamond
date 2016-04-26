//
//  PSDropDownMenu.m
//  PSDropDownMenu
//
//  Created by Pan on 15/8/6.
//  Copyright (c) 2015年 Pan. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define ScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)


#import "PSDropDownMenu.h"
#import "PSDropCollectionCell.h"
#import "CityModel.h"

@interface PSDropDownMenu ()<UICollectionViewDelegate,
                             UICollectionViewDataSource,
                             UICollectionViewDelegateFlowLayout,
                            PSDropDownMenuCellDelegate>

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *currentCityLabel;


@end

#define BACKGROUND_COLOR [UIColor colorWithRed:126/255 green:126/255 blue:126/255 alpha:0.3]
@implementation PSDropDownMenu

#pragma mark - init method
- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;
{
    self = [self initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0)];
    if (self) {
        _origin = CGPointMake(frame.origin.x, frame.origin.y + 60);
        _show = NO;
        _height = frame.size.height;
        _dataSource = dataSource;
        //self tapped
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backGroundView];
        [self addSubview:self.collectionView];
        [self addSubview:self.currentCityLabel];
        [self.collectionView reloadData];
        
    }
    return self;
}

#pragma mark - gesture handle
- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    [self hide];
}

#pragma mark - animation method
- (void)showInView:(UIView *)view;
{
    _currentCityLabel.text = [NSString stringWithFormat:@"当前城市:%@",[CityModel priorCity].cityName];
    [self addSubview:self.currentCityLabel];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.frame = CGRectMake(_origin.x, _origin.y, ScreenWidth, ScreenHeight);
    self.collectionView.frame = CGRectMake(0, 0, ScreenWidth, 280);
    self.backGroundView.backgroundColor = BACKGROUND_COLOR;
    self.currentCityLabel.frame = CGRectMake(0, self.collectionView.bounds.size.height - 55, ScreenWidth, 55);
    [UIView commitAnimations];
    
    [view addSubview:self];
    self.show = YES;
}

-(void)hide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.frame = CGRectMake(_origin.x, _origin.y, ScreenWidth, 0);
    self.collectionView.frame = CGRectMake(0, 0, ScreenWidth, 0);
    self.currentCityLabel.frame = CGRectMake(0, 0, ScreenWidth, 0);
    self.backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    [UIView commitAnimations];
    self.show = NO;
    [self.currentCityLabel removeFromSuperview];
}


#pragma mark - table datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PSDropCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PSDropCollectionCell description] forIndexPath:indexPath];
    NSString *name = [_dataSource objectAtIndex:indexPath.item];
    [cell.areaButton setTitle:name forState:UIControlStateNormal];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didTouchItem:)])
    {
        [self.delegate didTouchItem:[self.dataSource objectAtIndex:indexPath.item]];
    }
    [self hide];
}

#pragma mark - PSDropDownMenuCellDelegate
- (void)didTouchCell:(PSDropCollectionCell *)cell
{
    if ([self.delegate respondsToSelector:@selector(didTouchItem:)])
    {
        [self.delegate didTouchItem:[self.dataSource objectAtIndex:cell.indexPath.item]];
    }
    [self hide];
}


- (UIView *)backGroundView
{
    if (!_backGroundView)
    {
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(_origin.x, _origin.y, ScreenWidth, ScreenHeight)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
    }
    return _backGroundView;
}


- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(ScreenWidth / 3, 40);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0) collectionViewLayout:flowLayout];
        [_collectionView registerNib:[UINib nibWithNibName:[PSDropCollectionCell description] bundle:nil] forCellWithReuseIdentifier:[PSDropCollectionCell description]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, self.currentCityLabel.bounds.size.height, 0);
    }
    return _collectionView;
}

- (UILabel *)currentCityLabel
{
    if (!_currentCityLabel)
    {
        _currentCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        _currentCityLabel.textAlignment = NSTextAlignmentCenter;
        _currentCityLabel.textColor = UIColorFromRGB(0x555555);
        _currentCityLabel.text = [NSString stringWithFormat:@"当前城市:%@",[CityModel priorCity].cityName];
        _currentCityLabel.backgroundColor = [UIColor whiteColor];
        _currentCityLabel.layer.borderColor = [UIColorFromRGB(0xe1e1e1) CGColor];
        _currentCityLabel.layer.borderWidth = 0.5;
    }
    return _currentCityLabel;
}
@end
