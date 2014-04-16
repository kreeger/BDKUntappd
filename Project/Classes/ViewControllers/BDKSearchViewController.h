//
//  BDKUntappd // BDKSearchViewController.h
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDKSearchViewController : UITableViewController

@property (copy, nonatomic) void (^performSearchBlock)(NSString *query, void (^whenFinished)(NSArray *results));
@property (copy, nonatomic) void(^cellDisplayBlock)(id objectForCell, UITableViewCell *cell);

- (void)setAlertTitle:(NSString *)title description:(NSString *)description;

@end
