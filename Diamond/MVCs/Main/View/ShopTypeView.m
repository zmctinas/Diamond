//
//  ShopTypeView.m
//  Diamond
//
//  Created by Pan on 15/7/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopTypeView.h"
#import "ShopTypeCollectionCell.h"
#import "Util.h"
@interface ShopTypeView()

@property (nonatomic, strong) NSArray *imageNames;

@end

@implementation ShopTypeView

- (void)awakeFromNib
{
    self.delegate = self;
    self.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageNames count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ShopTypeCollectionCell description] forIndexPath:indexPath];
    NSString *imageName = [self.imageNames objectAtIndex:[self typeForIndexPath:indexPath]];
    [cell.iconView setImage:[UIImage imageNamed:imageName]];
    [cell.typeNameLabel setText:[Util shopTitleWithType:[self typeForIndexPath:indexPath]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.pageDelegate respondsToSelector:@selector(didTouchType:)])
    {
        [self.pageDelegate didTouchType:[self typeForIndexPath:indexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 8 || indexPath.item == 0)
    {
        [self.pageDelegate didMoveToPage:(indexPath.item % 7)];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width/4, self.frame.size.height/2);
}


#pragma mark - Private

- (NSInteger)typeForIndexPath:(NSIndexPath *)indexPath
{
    //由于横向的CollectionView是竖向排序indexPath的
    //而客户要求的type是横向排indexPath的。所以需要进行矩阵变换
    //TODO:原谅我数学没学好，以下算法可以优化
    BOOL isOdd = indexPath.item % 2;
    if (isOdd)
    {
        NSInteger remainder = indexPath.item % 8;
        NSInteger type = 0;
        if (remainder == 1)
        {
            type = indexPath.item + 3;
        }
        else if (remainder == 3)
        {
            type = indexPath.item + 2;
        }
        else if (remainder == 5)
        {
            type = indexPath.item + 1;
        }
        else if (remainder == 7)
        {
            type = indexPath.item;
        }
        return type;
    }
    else
    {
        if (!indexPath.item % 8)
        {
            return indexPath.item;
        }
        else
        {
            NSInteger remainder = indexPath.item % 8;
            NSInteger page = indexPath.item / 8;
            NSInteger number = (remainder / 2) + (8 * page);
            return number;
        }
    }
    return 0;
}


#pragma mark - Getter and Setter

- (NSArray *)imageNames
{
    if (!_imageNames)
    {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i < 16; i++)
        {
            NSString *imageName = [NSString stringWithFormat:@"typeimage%ld",(long)i];
            [arr addObject:imageName];
        }
        _imageNames = [NSArray arrayWithArray:arr];
    }
    return _imageNames;
}
@end
