//
//  withDrawlRecodeViewController.m
//  Diamond
//
//  Created by daimangkeji on 16/4/26.
//  Copyright © 2016年 Pan. All rights reserved.
//

#import "withDrawlRecodeViewController.h"
#import "withDralModel.h"
#import "recordListTableViewCell.h"
@interface withDrawlRecodeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)withDralModel* model;
@property(strong,nonatomic)UIBarButtonItem* leftItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation withDrawlRecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现记录";
    self.model.pages = @1;
    
    [self registercell];
    [self addNotifications];
    
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.model getRecord];
    
    if (_isRootPush) {
        self.navigationItem.leftBarButtonItem = self.leftItem;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

-(void)registercell
{
    UINib* nib = [UINib nibWithNibName:@"recordListTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"recordcell"];
}

-(void)addNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recevieNotification:) name:EXTRACT_MONEY_LIST object:nil];
}

-(void)recevieNotification:(NSNotification*)info
{
    if ([info.name isEqualToString:EXTRACT_MONEY_LIST]) {
        [_tableView reloadData];
    }
}

-(void)backBtn:(UIButton*)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - getter

-(UIBarButtonItem*)leftItem
{
    
    if (_leftItem == nil) {
        
        UIButton* btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 0, 40, 40);
        [btn setImage:[UIImage imageNamed:@"top_btn_fanhui.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        _leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _leftItem;
}

-(withDralModel*)model
{
    if (!_model) {
        _model = [[withDralModel alloc]init];
    }
    return _model;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    recordListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"recordcell" forIndexPath:indexPath];
    cell.entity = self.model.dataSource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

@end
