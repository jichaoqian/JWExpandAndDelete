//
//  JWExpandAndDeleteVC.m
//  ExpandAndDelete
//
//  Created by TUOGE on 2018/6/21.
//  Copyright © 2018年 iotogether. All rights reserved.
//

#import "JWExpandAndDeleteVC.h"

#import "JWOriginCell.h"
#import "JWExpandCell.h"

@interface JWExpandAndDeleteVC () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (assign, nonatomic) BOOL isExpand; //是否展开
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;//展开的cell的下标

@property (nonatomic, assign) NSInteger CellCount; // 原生cell数量
@property (nonatomic, assign) NSInteger ExpandCount; // 展开cell数量

@end

@implementation JWExpandAndDeleteVC

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JWOriginCell class] forCellReuseIdentifier:@"JWOriginCell"];
        [_tableView registerClass:[JWExpandCell class] forCellReuseIdentifier:@"JWExpandCell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _CellCount = 15;
    _ExpandCount = 3;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (self.isExpand && self.selectedIndexPath.row < indexPath.row && indexPath.row <= self.selectedIndexPath.row + _ExpandCount) {   // Expand cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"JWExpandCell" forIndexPath:indexPath];
        cell.textLabel.text = @"    bbbb";
    } else {    // Normal cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"JWOriginCell" forIndexPath:indexPath];
        cell.textLabel.text = @"aaa";
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isExpand) {
        return _CellCount + _ExpandCount;
    }
    return _CellCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.selectedIndexPath) {
        _ExpandCount = 3;
        self.isExpand = YES;
        self.selectedIndexPath = indexPath;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[self indexPathsForExpandRow:indexPath.row] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    } else {
        if (self.isExpand) {
            if (self.selectedIndexPath == indexPath) {
                self.isExpand = NO;
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow:indexPath.row] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.selectedIndexPath = nil;
            } else if (self.selectedIndexPath.row < indexPath.row && indexPath.row <= self.selectedIndexPath.row + _ExpandCount) {
                NSLog(@">>>%ld",(long)indexPath.row);
            } else {
                self.isExpand = NO;
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow:self.selectedIndexPath.row] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.selectedIndexPath = nil;
            }
        }
    }
}

#pragma mark - other
// 隐藏
- (NSArray *)indexPathsForExpandRow:(NSInteger)row {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 1; i <= _ExpandCount; i++) {
        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:row + i inSection:0];
        [indexPaths addObject:idxPth];
    }
    return [indexPaths copy];
}
// 删除
- (NSArray *)indexPathsForExpandRow2:(NSInteger)row countNum:(NSInteger)countNum {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < countNum+1; i++) {
        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:row + i inSection:0];
        [indexPaths addObject:idxPth];
    }
    return [indexPaths copy];
}

#pragma mark - 添加删除
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"delete:>>>%ld", indexPath.row);
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (!self.selectedIndexPath) { // 如果没有展开的话，也要删除其下面的所有数据
            weakSelf.CellCount -= 1;
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        } else { // 如果是选中展开了这个的话，要删除所有都下面的子类
            if (self.isExpand) {
                if (self.selectedIndexPath == indexPath) {
                    weakSelf.CellCount -= 1;
                    NSInteger countNum = weakSelf.ExpandCount;
                    weakSelf.ExpandCount = 0;
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow2:indexPath.row countNum:countNum] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                    self.isExpand = NO;
                    self.selectedIndexPath = nil;
                } else if (self.selectedIndexPath.row < indexPath.row && indexPath.row <= self.selectedIndexPath.row + weakSelf.ExpandCount) { // 如果删除的是展开的
                    NSLog(@">>>%ld",(long)indexPath.row);
                    weakSelf.ExpandCount -= 1;
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                    if (weakSelf.ExpandCount == 0) {
                        self.selectedIndexPath = nil;
                        self.isExpand = NO;
                    }
                } else {
                    weakSelf.CellCount -= 1;
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                }
            }
        }
    }];
    return @[delete];
}

@end

