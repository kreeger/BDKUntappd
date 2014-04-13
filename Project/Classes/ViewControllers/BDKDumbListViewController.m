//
//  BDKUntappd // BDKBeersViewController.m
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKDumbListViewController.h"

#import "UIViewController+BDKUntappd.h"

#import "BDKTableViewCell.h"

#import <BDKUntappd/BDKUntappd.h>

@interface BDKDumbListViewController ()

@property (strong, nonatomic) NSArray *objects;

- (void)refreshControlPulled:(UIRefreshControl *)control;

@end

@implementation BDKDumbListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _objects = [NSArray array];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView registerClass:[BDKTableViewCell class] forCellReuseIdentifier:BDKTableViewCellID];
    [self.refreshControl addTarget:self action:@selector(refreshControlPulled:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.refreshControl beginRefreshing];
    [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Private methods

- (void)refreshControlPulled:(UIRefreshControl *)control {
    self.refreshBlock(^(NSArray *results){
        self.objects = results;
        [self.tableView reloadData];
        [control endRefreshing];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BDKTableViewCellID forIndexPath:indexPath];
    self.cellDisplayBlock(self.objects[indexPath.row], cell);
    return cell;
}

@end
