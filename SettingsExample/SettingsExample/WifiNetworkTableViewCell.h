//
//  WifiNetworkTableViewCell.h
//  SettingsExample
//
//  Created by Jake Marsh on 5/22/12.
//  Copyright (c) 2012 Rubber Duck Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifiNetworkTableViewCell : UITableViewCell

@property (nonatomic, strong) UIActivityIndicatorView *connectingActivityIndicatorView;
@property (nonatomic, strong) UIImageView *selectedCheckmarkImageView;

@end