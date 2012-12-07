//
//  WifiViewController.m
//  SettingsExample
//
//  Created by Jake Marsh on 10/9/11.
//  Copyright (c) 2011 Rubber Duck Software. All rights reserved.
//

#import "WifiViewController.h"
#import "WifiNetwork.h"
#import "WifiNetworkTableViewCell.h"

@interface WifiViewController ()

@property (nonatomic, strong) UISwitch *wifiSwitch;
@property (nonatomic, strong) UISwitch *askToJoinSwitch;
@property (nonatomic, strong) UIActivityIndicatorView *searchingForNetworksActivityIndicator;

@property (nonatomic, strong) NSArray *simulatedNetworks;
@property (nonatomic, strong) NSIndexPath *selectedNetworkIndexPath;

- (void) _foundNetworks;
- (void) _switchChanged:(UISwitch *)senderSwitch;

@end

@implementation WifiViewController

@synthesize wifiSwitch = _wifiSwitch;
@synthesize askToJoinSwitch = _askToJoinSwitch;
@synthesize searchingForNetworksActivityIndicator = _searchingForNetworksActivityIndicator;

@synthesize simulatedNetworks = _simulatedNetworks;
@synthesize selectedNetworkIndexPath = _selectedNetworkIndexPath;

- (id) init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;

	self.title = NSLocalizedString(@"Wi-Fi Networks", @"Wi-Fi Networks");

	NSMutableArray *networks = [NSMutableArray array];
	
	WifiNetwork *iamtheinternet = [[WifiNetwork alloc] init];
	iamtheinternet.networkName = @"iamtheinternet";
	iamtheinternet.signalStrength = 3;
	iamtheinternet.secure = YES;
	
	[networks addObject:iamtheinternet];
	
	WifiNetwork *watson = [[WifiNetwork alloc] init];
	watson.networkName = @"watson";
	watson.signalStrength = 3;
	watson.secure = YES;
	
	[networks addObject:watson];
	
	WifiNetwork *airportEXTREME = [[WifiNetwork alloc] init];
	airportEXTREME.networkName = @"airportEXTREME";
	airportEXTREME.signalStrength = 3;
	airportEXTREME.secure = YES;
	
	[networks addObject:airportEXTREME];
	
	WifiNetwork *tardis = [[WifiNetwork alloc] init];
	tardis.networkName = @"tardis";
	tardis.signalStrength = 3;
	tardis.secure = YES;
	
	[networks addObject:tardis];
	
	WifiNetwork *pennygetyourownwifi = [[WifiNetwork alloc] init];
	pennygetyourownwifi.networkName = @"pennygetyourownwifi";
	pennygetyourownwifi.signalStrength = 3;
	pennygetyourownwifi.secure = YES;
	
	[networks addObject:pennygetyourownwifi];
	
	[networks sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		WifiNetwork *network1 = (WifiNetwork *)obj1;
		WifiNetwork *network2 = (WifiNetwork *)obj2;
		
		return [network1.networkName compare:network2.networkName];
	}];

	self.simulatedNetworks = [NSArray arrayWithArray:networks];

	return self;
}

- (void) _foundNetworks {
	if([self numberOfSectionsInTableView:self.tableView] == 1) return;

	[self.tableView beginUpdates];

	for(NSUInteger i = 0; i < [self.simulatedNetworks count]; i++) {
		WifiNetwork *network = [self.simulatedNetworks objectAtIndex:i];

        __unsafe_unretained __block WifiViewController *safeSelf = self;

		[self insertCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"WifiNetworkCell";
			staticContentCell.tableViewCellSubclass = [WifiNetworkTableViewCell class];

			cell.textLabel.text = network.networkName;
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

			cell.indentationLevel = 2;
			cell.indentationWidth = 10.0;

			if(safeSelf.selectedNetworkIndexPath && indexPath.row == safeSelf.selectedNetworkIndexPath.row) {
				cell.textLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1.0];
				((WifiNetworkTableViewCell *)cell).selectedCheckmarkImageView.hidden = NO;
				//[((WifiNetworkTableViewCell *)cell).connectingActivityIndicatorView startAnimating];
			} else {
				cell.textLabel.textColor = [UIColor blackColor];
				((WifiNetworkTableViewCell *)cell).selectedCheckmarkImageView.hidden = YES;
			}
		} whenSelected:^(NSIndexPath *indexPath) {
			NSIndexPath *oldSelectedIndexPath = nil;
			if(safeSelf.selectedNetworkIndexPath) {
				oldSelectedIndexPath = [NSIndexPath indexPathForRow:safeSelf.selectedNetworkIndexPath.row
                                                          inSection:safeSelf.selectedNetworkIndexPath.section];
			}

			safeSelf.selectedNetworkIndexPath = indexPath;

			if(oldSelectedIndexPath && oldSelectedIndexPath.row != indexPath.row) {
				[safeSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:oldSelectedIndexPath, indexPath, nil]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
			} else {
				[safeSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
			}
		} atIndexPath:[NSIndexPath indexPathForRow:i inSection:1] animated:YES];
	}

	[self.tableView endUpdates];

	[self.searchingForNetworksActivityIndicator stopAnimating];
}
- (void) _switchChanged:(UISwitch *)senderSwitch {
	if([senderSwitch isEqual:self.wifiSwitch]) {
		[self.tableView beginUpdates];

		if(self.wifiSwitch.on) {
			[self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];

			self.footerText = NSLocalizedString(@"Known networks will be joined automatically. If no known networks are available, you will be asked before joining a new network.", @"wifiFooter");
		} else {
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];

			self.footerText = NSLocalizedString(@"Location accuracy is improved when Wi-Fi is enabled.", @"wifiOffFooter");
		}

		[self.tableView endUpdates];
	}
}

#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];

	self.wifiSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	self.wifiSwitch.on = YES;

	[self.wifiSwitch addTarget:self action:@selector(_switchChanged:) forControlEvents:UIControlEventValueChanged];

	self.askToJoinSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	self.askToJoinSwitch.on = YES;

	self.searchingForNetworksActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"UIControlCell";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

			cell.textLabel.text = NSLocalizedString(@"Wi-Fi", @"Wi-Fi");
			cell.accessoryView = self.wifiSwitch;
		}];
	}];

	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		section.headerTitle = NSLocalizedString(@"Choose a Network...", @"Choose a Network...");

		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"WifiNetworkOtherCell";
			cell.textLabel.text = NSLocalizedString(@"Other...", @"Other...");

			cell.indentationLevel = 2;
			cell.indentationWidth = 10.0;
		}];
	}];

	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"UIControlCell";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

			cell.textLabel.text = NSLocalizedString(@"Ask to Join Networks", @"Ask to Join Networks");
			cell.accessoryView = self.askToJoinSwitch;
		}];
	}];

	self.footerText = NSLocalizedString(@"Known networks will be joined automatically. If no known networks are available, you will be asked before joining a new network.", @"wifiFooter");
}
- (void) viewDidUnload {
    [super viewDidUnload];

	self.wifiSwitch = nil;
	self.askToJoinSwitch = nil;
	self.searchingForNetworksActivityIndicator = nil;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self.searchingForNetworksActivityIndicator startAnimating];
}
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[self performSelector:@selector(_foundNetworks) withObject:nil afterDelay:0.7];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Table View Delegate

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if(section == 1) {
		UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 16.0)];

		UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 10.0, 320.0, 16.0)];

		headerLabel.backgroundColor = [tableView backgroundColor];
		headerLabel.text = NSLocalizedString(@"Choose a Network...", @"Choose a Network...");
		headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
		headerLabel.textColor = [UIColor colorWithRed:61.0/255.0 green:77.0/255.0 blue:99.0/255.0 alpha:1.0];
		headerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.65];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);

		[header addSubview:headerLabel];

		self.searchingForNetworksActivityIndicator.frame = CGRectMake(190.0, 18.0, 0.0, 0.0);
		[header addSubview:self.searchingForNetworksActivityIndicator];

		return header;
	} else {
		return nil;
	}
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//	if(section == 1) {
//		return 22.0;
//	} else {
		return UITableViewAutomaticDimension;
//	}
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	if(self.wifiSwitch.on) {
		return [super numberOfSectionsInTableView:tableView];
	} else {
		return 1;
	}
}

@end