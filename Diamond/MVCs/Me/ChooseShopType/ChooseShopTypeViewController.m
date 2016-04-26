//
//  ChooseShopTypeViewController.m
//  Diamond
//
//  Created by Pan on 15/8/10.
//  Copyright (c) 2015年 Pan. All rights reserved.
//


#import "ChooseShopTypeViewController.h"
#import "ChooseShopTypeCollectionCell.h"


#define CHOOSE_COUNT_LIMIT 3
#define NUMBER_OF_PERROW 4


@interface ChooseShopTypeViewController ()<UICollectionViewDelegate,
                                           UICollectionViewDataSource,
                                           UICollectionViewDelegateFlowLayout,
                                           ChooseShopTypeCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)touchSubmitButton:(UIBarButtonItem *)sender;

@end

@implementation ChooseShopTypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.allowsMultipleSelection = YES;
    [self addLeftBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    if ([self.selectedItems count]) {
        for (NSNumber *index in self.selectedItems) {
            NSUInteger indexes[] = {0,(index.intValue - 1)};
            NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:2];
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseShopTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ChooseShopTypeCollectionCell description] forIndexPath:indexPath];
    cell.type = indexPath.item + 1;
    cell.delegate = self;
    return cell;
}

//处理选中Cell的情况
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedIndexPaths = [collectionView indexPathsForSelectedItems];
    if ([selectedIndexPaths count] >= CHOOSE_COUNT_LIMIT)
    {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH / NUMBER_OF_PERROW, 64);
}

//处理点击到Cell上的按钮的情况
#pragma mark - ChooseShopTypeCellDelegate
- (void)ChooseShopType:(ChooseShopTypeCollectionCell *)cell didTouchIconButton:(UIButton *)button
{
    if (cell.isSelected)
    {
        [self.collectionView deselectItemAtIndexPath:[self.collectionView indexPathForCell:cell] animated:NO];
    }
    else
    {
        NSArray *selectedIndexPaths = [self.collectionView indexPathsForSelectedItems];
        if ([selectedIndexPaths count] >= CHOOSE_COUNT_LIMIT)
        {
            return;
        }
        [self.collectionView selectItemAtIndexPath:[self.collectionView indexPathForCell:cell] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (IBAction)touchSubmitButton:(UIBarButtonItem *)sender {
    if (![self.collectionView.indexPathsForSelectedItems count])
    {
        [self showtips:@"请至少选择一种类型..."];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didShopTypeSelected:text:)])
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSMutableString *text = [[NSMutableString alloc] init];
        for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems)
        {
            ChooseShopTypeCollectionCell *cell = (ChooseShopTypeCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            [array addObject:@(cell.type)];
            [text appendString:[Util shopTitleWithType:cell.type]];
            [text appendString:@" "];
        }
        [self.delegate didShopTypeSelected:array text:text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
