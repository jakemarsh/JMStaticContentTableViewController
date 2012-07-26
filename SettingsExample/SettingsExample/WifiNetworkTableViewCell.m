//
//  WifiNetworkTableViewCell.m
//  SettingsExample
//
//  Created by Jake Marsh on 5/22/12.
//  Copyright (c) 2012 Rubber Duck Software. All rights reserved.
//

#import "WifiNetworkTableViewCell.h"

@implementation WifiNetworkTableViewCell

@synthesize connectingActivityIndicatorView = _connectingActivityIndicatorView;
@synthesize selectedCheckmarkImageView = _selectedCheckmarkImageView;

- (id) init {
	self = [super init];
	if(!self) return nil;
    
	self.connectingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
	self.selectedCheckmarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIPreferencesBlueCheck.png"]];
	self.selectedCheckmarkImageView.frame = CGRectMake(0.0, 0.0, 14.0, 14.0);
	//self.selectedCheckmarkImageView.hidden = YES;
    
	[self.contentView addSubview:self.connectingActivityIndicatorView];
	[self.contentView addSubview:self.selectedCheckmarkImageView];
    
	return self;
}

- (void) layoutSubviews {
	[super layoutSubviews];
    
	self.connectingActivityIndicatorView.frame = CGRectMake(5.0, 10.0, 15.0, 15.0);
	self.selectedCheckmarkImageView.frame = CGRectMake(200.0, 10.0, 14.0, 14.0);
    
	[self.contentView bringSubviewToFront:self.selectedCheckmarkImageView];
}

@end