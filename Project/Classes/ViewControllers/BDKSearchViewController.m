//
//  BDKUntappd // BDKSearchViewController.m
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKSearchViewController.h"

#import "BDKTableViewCell.h"

@interface BDKSearchViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) UIAlertView *alertView;
@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSArray *objects;

- (void)refreshControlPulled:(UIRefreshControl *)control;

@end

@implementation BDKSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _objects = [NSArray array];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView registerClass:[BDKTableViewCell class] forCellReuseIdentifier:BDKTableViewCellID];
    [self.refreshControl addTarget:self action:@selector(refreshControlPulled:)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.alertView show];
}

#pragma mark - Methods

- (void)setAlertTitle:(NSString *)title description:(NSString *)description {
    self.alertView = [[UIAlertView alloc] initWithTitle:title
                                                message:description
                                               delegate:self
                                      cancelButtonTitle:@"Search"
                                      otherButtonTitles:nil, nil];
    self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
}

#pragma mark - Private methods

- (void)refreshControlPulled:(UIRefreshControl *)control {
    if (!self.performSearchBlock) {
        [control endRefreshing];
        return;
    }
    
    self.performSearchBlock(self.query, ^(NSArray *results){
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cellTappedBlock(indexPath);
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.query = [[alertView textFieldAtIndex:0] text];
    [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
