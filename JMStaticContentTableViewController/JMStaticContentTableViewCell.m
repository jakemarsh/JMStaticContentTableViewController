#import "JMStaticContentTableViewCell.h"

@implementation JMStaticContentTableViewCell

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize cellHeight = _cellHeight;
@synthesize cellStyle = _cellStyle;
@synthesize tableViewCellSubclass = _tableViewCellSubclass;

@synthesize configureBlock = _configureBlock;
@synthesize whenSelectedBlock = _whenSelectedBlock;

- (id) init {
	self = [super init];
	if(!self) return nil;

	self.cellHeight = UITableViewAutomaticDimension;
	self.tableViewCellSubclass = [UITableViewCell class];
	self.cellStyle = UITableViewCellStyleDefault;
	self.reuseIdentifier = @"DefaultCell";
	
	return self;
}

@end