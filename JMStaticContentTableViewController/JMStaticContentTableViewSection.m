#import "JMStaticContentTableViewSection.h"
#import "JMStaticContentTableViewCell.h"

@implementation JMStaticContentTableViewSection

@synthesize tableView = _tableView;
@synthesize staticContentCells = _staticContentCells;
@synthesize headerTitle = _headerTitle;
@synthesize footerTitle = _footerTitle;

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
    staticContentCell.indexPath = indexPath;

	configurationBlock(staticContentCell, nil, indexPath);

	[mutableCells insertObject:staticContentCell atIndex:indexPath.row];

	self.staticContentCells = [NSArray arrayWithArray:mutableCells];

	if(animated) {
		[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	} else {
		[self.tableView reloadData];
	}
}

- (void) addCell:(JMStaticContentTableViewCellBlock)configurationBlock
		   animated:(BOOL)animated {

	if(!self.staticContentCells) self.staticContentCells = [NSArray array];

	NSMutableArray *mutableCells = [self.staticContentCells mutableCopy];

	JMStaticContentTableViewCell *staticContentCell = [[JMStaticContentTableViewCell alloc] init];

	staticContentCell.configureBlock = configurationBlock;
    staticContentCell.indexPath = [NSIndexPath indexPathForRow:[self.staticContentCells count] inSection:self.sectionIndex];

	configurationBlock(staticContentCell, nil, staticContentCell.indexPath);

	[mutableCells addObject:staticContentCell];

	self.staticContentCells = [NSArray arrayWithArray:mutableCells];

	if(animated) {
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:staticContentCell.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	} else {
		[self.tableView reloadData];
	}
}

- (void) reloadCellAtIndex:(NSUInteger)rowIndex {
    [self reloadCellAtIndex:rowIndex animated:YES];
}

- (void) reloadCellAtIndex:(NSUInteger)rowIndex animated:(BOOL)animated {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowIndex inSection:self.sectionIndex]]
                          withRowAnimation:animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
}

- (void) removeCellAtIndex:(NSUInteger)rowIndex {
	[self removeCellAtIndex:rowIndex animated:YES];
}
- (void) removeCellAtIndex:(NSUInteger)rowIndex animated:(BOOL)animated {
	NSMutableArray *cells = [self.staticContentCells mutableCopy];
	
	[cells removeObjectAtIndex:rowIndex];
	
	self.staticContentCells = [NSArray arrayWithArray:cells];

	if(animated) {
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowIndex inSection:self.sectionIndex]] withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (NSString *) description {
    NSMutableString *str = [NSMutableString stringWithString:@"<JMStaticContentTableViewSection"];

    [str appendFormat:@" sectionIndex='%d'", self.sectionIndex];
    if(self.headerTitle) [str appendFormat:@" headerTitle='%@'", self.headerTitle];
    if(self.footerTitle) [str appendFormat:@" footerTitle='%@'", self.footerTitle];

    for(JMStaticContentTableViewCell *cell in self.staticContentCells) {
        [str appendFormat:@"\n      %@", [cell description]];
    }

    [str appendString:@"\n>"];

    return [NSString stringWithString:str];
}

@end