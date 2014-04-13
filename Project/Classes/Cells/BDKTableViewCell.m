//
//  BDKUntappd // BDKTableViewCell.m
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

NSString * const BDKTableViewCellID = @"BDKTableViewCell";

#import "BDKTableViewCell.h"

@implementation BDKTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return self;
}

@end
