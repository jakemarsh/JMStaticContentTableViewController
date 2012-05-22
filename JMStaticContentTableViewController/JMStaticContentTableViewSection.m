#import "JMStaticContentTableViewSection.h"
#import "JMStaticContentTableViewCell.h"

@implementation JMStaticContentTableViewSection

@synthesize tableView = _tableView;
@synthesize staticContentCells = _staticContentCells;
@synthesize title = _title;

- (void) addCell:(JMStaticContentTableViewCellBlock)configurationBlock {
	[self addCell:configurationBlock whenSelected:nil];
}

- (void) addCell:(JMStaticContentTableViewCellBlock)configurationBlock whenSelected:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock {
	if(!self.staticContentCells) self.staticContentCells = [NSArray array];

	JMStaticContentTableViewCell *staticContentCell = [[JMStaticContentTableViewCell alloc] init];

	staticContentCell.configureBlock = configurationBlock;
	staticContentCell.whenSelectedBlock = whenSelectedBlock;

	configurationBlock(staticContentCell, nil, nil);

	self.staticContentCells = [self.staticContentCells arrayByAddingObject:staticContentCell];	
}

- (void) insertCell:(JMStaticContentTableViewCellBlock)configurationBlock
	   whenSelected:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock
		atIndexPath:(NSIndexPath *)indexPath
		   animated:(BOOL)animated {

	if(!self.staticContentCells) self.staticContentCells = [NSArray array];
		
	NSMutableArray *mutableCells = [self.staticContentCells mutableCopy];
	
	JMStaticContentTableViewCell *staticContentCell = [[JMStaticContentTableViewCell alloc] init];

	staticContentCell.configureBlock = configurationBlock;
	staticContentCell.whenSelectedBlock = whenSelectedBlock;

	configurationBlock(staticContentCell, nil, nil);

	[mutableCells insertObject:staticContentCell atIndex:indexPath.row];

	self.staticContentCells = [NSArray arrayWithArray:mutableCells];

	if(animated) {
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	} else {
		[self.tableView reloadData];
	}
}

- (void) removeCellAtIndex:(NSUInteger)rowIndex {
	[self removeCellAtIndex:rowIndex animated:YES];
}
- (void) removeCellAtIndex:(NSUInteger)rowIndex animated:(BOOL)animated {
	NSMutableArray *cells = [self.staticContentCells mutableCopy];
	
	[cells removeObjectAtIndex:rowIndex];
	
	self.staticContentCells = [NSArray arrayWithArray:cells];

	if(animated) {
		[self.tableView beginUpdates];

		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

		[self.tableView endUpdates];
	} else {
		[self.tableView reloadData];
	}
}

- (void) removeAllCells {
	if(self.staticContentCells) {
		self.staticContentCells = nil;
		self.staticContentCells = [NSArray array];
	}
}

@end