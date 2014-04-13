//
//  BDKUntappd // BDKBeersViewController.h
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@interface BDKDumbListViewController : UITableViewController

@property (copy, nonatomic) void(^refreshBlock)(void (^whenFinished)(NSArray *results));
@property (copy, nonatomic) void(^cellDisplayBlock)(id objectForCell, UITableViewCell *cell);

@end
