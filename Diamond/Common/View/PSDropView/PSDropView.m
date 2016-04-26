//
//  PSDropView.m
//  PSDropdownView
//
//  Created by Pan on 15/7/17.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSDropView.h"
#import "PSDropDownCell.h"
#import "Macros.h"

static const CGFloat rowHeight = 40;
static const CGFloat defaultWidth = 44;
static const CGFloat minWidth = 120;

@interface PSDropView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic) NSUInteger unReadCount;
@end

@implementation PSDropView

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.frame = CGRectMake(0, 64, 100, 0);
        self.layer.masksToBounds = NO;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColorFromRGB(LINE_GRAY) CGColor];
//        self.layer.cornerRadius = 8;
//        self.layer.shadowOffset = CGSizeMake(-3, 3);
//        self.layer.shadowRadius = 3;
//        self.layer.shadowOpacity = 0.5;
        
        self.dataSource = items;

    }
    return self;
}

#pragma mark - Public Method

- (void)showInView:(UIView *)view senderIdentifier:(PSDropViewSenderIdentifier)identifier noticeCount:(NSUInteger)count sender:(id)sender;
{
    self.unReadCount = count;
    UIView *aView;
    switch (identifier)
    {
        case LeftBarButtonItem:
            aView = [[UIView alloc]initWithFrame:CGRectMake(8, 44, 44, 28)];
            break;
            case RightBarButtonItem:
            aView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - defaultWidth - 8, 44, 44, 28)];
            break;
        default:
            aView = sender;
            break;
    }
    CGFloat width = MAX(aView.frame.size.width, minWidth);
    CGFloat height = aView.frame.size.height;
    CGFloat x = aView.center.x - (width/2);
    CGFloat y = aView.frame.origin.y;
    
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    BOOL beyondScreenRight =  (ScreenWidth - x - width < 8);
    BOOL beyondScreenLeft = (x < 0);

    if (beyondScreenRight)
    {
        x =  ScreenWidth - width - 8;
    }
    else if (beyondScreenLeft)
    {
        x = 8;
    }

    self.frame = CGRectMake(x, y + height, width, 0);
    self.tableView.frame = CGRectMake(0, 0,width, 0);
    [self.tableView reloadData];
    
    self.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.frame = CGRectMake(x, y + height, width, [self.dataSource count] * rowHeight);
    self.tableView.frame = CGRectMake(0, 0, width, [self.dataSource count] * rowHeight);
    [UIView commitAnimations];

    [view addSubview:self];
    [self addSubview:self.tableView];
    self.show = YES;
}


- (void)hide:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
        self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 0);
        [UIView commitAnimations];
        [self performSelector:@selector(makeSelfHidden) withObject:nil afterDelay:0.3];
    }
    else
    {
        [self makeSelfHidden];
    }
    self.show = NO;
}

- (void)makeSelfHidden
{
    self.hidden = YES;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSDropDownCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PSDropItem *item = [self.dataSource objectAtIndex:indexPath.row];
    cell.iconView.image = item.icon;
    cell.titleLabel.text = item.text;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 2 && self.unReadCount != 0)
    {
        cell.unReadLabel.text = [NSString stringWithFormat:@"%ld",self.unReadCount];
        cell.unReadLabel.hidden = NO;
    }
    else
    {
        cell.unReadLabel.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hide:NO];
    //破坏封装性的脏代码，为了显示未添加的好友申请数量
    if (indexPath.row == 2)
    {
        self.unReadCount = 0;
    }
    [self.delegate dropView:self didSelectRowAtIndexPath:indexPath];
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 3;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.separatorColor = UIColorFromRGB(LIGHT_GRAY);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = rowHeight;
        [_tableView registerNib:[UINib nibWithNibName:[PSDropDownCell description] bundle:nil] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}

- (NSArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}



@end


@interface PSDropItem ()

@property (nonatomic, strong, readwrite) UIImage *icon;
@property (nonatomic, strong, readwrite) NSString *text;

@end

@implementation PSDropItem

+ (instancetype)dropItemWithIcon:(UIImage *)icon text:(NSString *)text
{
    PSDropItem *item = [[PSDropItem alloc]init];
    if (item)
    {
        item.icon = icon;
        item.text = text;
    }
    return item;
}

@end
