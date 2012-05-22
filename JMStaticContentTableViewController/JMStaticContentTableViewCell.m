#import "JMStaticContentTableViewCell.h"

@implementation JMStaticContentTableViewCell

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize cellHeight = _cellHeight;
@synthesize cellStyle = _cellStyle;
@synthesize tableViewCellSubclass = _tableViewCellSubclass;

@synthesize configureBlock = _configureBlock;
@synthesize whenSelectedBlock = _whenSelectedBlock;

@synthesize editingStyle = _editingStyle;
@synthesize editable = _editable;
@synthesize moveable = _moveable;

- (id) init {
	self = [super init];
	if(!self) return nil;

	self.cellHeight = UITableViewAutomaticDimension;
	self.tableViewCellSubclass = [UITableViewCell class];
	self.cellStyle = UITableViewCellStyleDefault;
	self.reuseIdentifier = @"DefaultCell";

    self.editingStyle = UITableViewCellEditingStyleNone;
    self.editable = NO;
    self.moveable = NO;

	return self;
}

@end