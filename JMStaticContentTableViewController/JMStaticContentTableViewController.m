#import "JMStaticContentTableViewController.h"
#import <QuartzCore/QuartzCore.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
#define NSTextAlignmentCenter       UITextAlignmentCenter
#endif


@implementation JMStaticContentTableViewController

@synthesize staticContentSections = _staticContentSections;

@synthesize headerText = _headerText;
@synthesize footerText = _footerText;

#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];

	[self removeAllSections];
}
- (void) viewDidUnload {
    [super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.staticContentSections.count;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:section];

    return sectionContent.staticContentCells.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:indexPath.section];
	JMStaticContentTableViewCell *cellContent = [sectionContent.staticContentCells objectAtIndex:indexPath.row];

	return cellContent.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:section];
    UIView *headerView = sectionContent.headerView;
	if (headerView) {
        return CGRectGetHeight(headerView.frame);
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:section];
    UIView *footerView = sectionContent.headerView;
	if (footerView) {
        return CGRectGetHeight(footerView.frame);
    }
    
    return UITableViewAutomaticDimension;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:section];
	return sectionContent.headerTitle;
}
- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:section];
	return sectionContent.footerTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:section];
	return sectionContent.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:section];
	return sectionContent.footerView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:indexPath.section];
	JMStaticContentTableViewCell *cellContent = [sectionContent.staticContentCells objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellContent.reuseIdentifier];

    if (cell == nil) {
		cell = [[[cellContent tableViewCellSubclass] alloc] initWithStyle:cellContent.cellStyle reuseIdentifier:cellContent.reuseIdentifier];
    }

	cell.imageView.image = nil;
	cell.accessoryView = nil;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	cellContent.configureBlock(cellContent, cell, indexPath);

    return cell;
}

#pragma mark - Table view delegate

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:indexPath.section];
	JMStaticContentTableViewCell *cellContent = [sectionContent.staticContentCells objectAtIndex:indexPath.row];

    return cellContent.editingStyle;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:indexPath.section];
	JMStaticContentTableViewCell *cellContent = [sectionContent.staticContentCells objectAtIndex:indexPath.row];

    return cellContent.editable;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:indexPath.section];
	JMStaticContentTableViewCell *cellContent = [sectionContent.staticContentCells objectAtIndex:indexPath.row];

    return cellContent.moveable;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(!tableView.editing && !tableView.allowsMultipleSelection) [tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(tableView.editing && !tableView.allowsMultipleSelectionDuringEditing) [tableView deselectRowAtIndexPath:indexPath animated:YES];

	JMStaticContentTableViewSection *sectionContent = [self.staticContentSections objectAtIndex:indexPath.section];
	JMStaticContentTableViewCell *cellContent = [sectionContent.staticContentCells objectAtIndex:indexPath.row];

	if(cellContent.whenSelectedBlock) {
		cellContent.whenSelectedBlock(indexPath);
	}
}
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[self.view endEditing:YES];
}

#pragma mark - Static Content

- (void) _updateSectionIndexes {
    NSInteger updatedIndex = 0;
    for(JMStaticContentTableViewSection *section in self.staticContentSections) {
        section.sectionIndex = updatedIndex;
        updatedIndex++;
    }
}

- (void) removeAllSections {
	if(self.staticContentSections) {
		self.staticContentSections = nil;
		self.staticContentSections = [NSArray array];
	}
}

- (void) addSection:(JMStaticContentTableViewControllerAddSectionBlock)b {
	if(!self.staticContentSections) self.staticContentSections = [NSArray array];
	
	JMStaticContentTableViewSection *section = [[JMStaticContentTableViewSection alloc] init];
	section.tableView = self.tableView;
    section.sectionIndex = [self.staticContentSections count];

	b(section, section.sectionIndex);

	self.staticContentSections = [self.staticContentSections arrayByAddingObject:section];

    [self _updateSectionIndexes];
}

- (void) insertSection:(JMStaticContentTableViewControllerAddSectionBlock)b atIndex:(NSUInteger)sectionIndex {
	[self insertSection:b atIndex:sectionIndex animated:YES];
}
- (void) insertSection:(JMStaticContentTableViewControllerAddSectionBlock)b atIndex:(NSUInteger)sectionIndex animated:(BOOL)animated {
	[self insertSection:b atIndex:sectionIndex animated:YES updateView:YES];
}

- (void) insertSection:(JMStaticContentTableViewControllerAddSectionBlock)b atIndex:(NSUInteger)sectionIndex animated:(BOOL)animated updateView:(BOOL)updateView {
	if(!self.staticContentSections) self.staticContentSections = [NSArray array];

	NSMutableArray *mutableSections = [self.staticContentSections mutableCopy];

	JMStaticContentTableViewSection *section = [[JMStaticContentTableViewSection alloc] init];

	b(section, sectionIndex);

	[mutableSections insertObject:section atIndex:sectionIndex];

	self.staticContentSections = [NSArray arrayWithArray:mutableSections];

    [self _updateSectionIndexes];

    if (updateView) {
        if(animated) {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [self.tableView reloadData];
        }
    }
}

- (void) removeSectionAtIndex:(NSUInteger)sectionIndex {
	[self removeSectionAtIndex:sectionIndex animated:YES];
}
- (void) removeSectionAtIndex:(NSUInteger)sectionIndex animated:(BOOL)animated {
	NSMutableArray *sections = [self.staticContentSections mutableCopy];

	[sections removeObjectAtIndex:sectionIndex];

	self.staticContentSections = [NSArray arrayWithArray:sections];

    [self _updateSectionIndexes];

	if(animated) {
		[self.tableView beginUpdates];

		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];

		[self.tableView endUpdates];
	} else {
		[self.tableView reloadData];
	}
}

- (void) reloadSectionAtIndex:(NSUInteger)sectionIndex {
	[self reloadSectionAtIndex:sectionIndex animated:YES];
}
- (void) reloadSectionAtIndex:(NSUInteger)sectionIndex animated:(BOOL)animated {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
}

- (JMStaticContentTableViewSection *) sectionAtIndex:(NSUInteger)sectionIndex {
	return [self.staticContentSections objectAtIndex:sectionIndex];
}

- (void) insertCell:(JMStaticContentTableViewCellBlock)configurationBlock 
		atIndexPath:(NSIndexPath *)indexPath 
		   animated:(BOOL)animated {

	[self insertCell:configurationBlock
		whenSelected:nil
		 atIndexPath:indexPath
			animated:YES];
}

- (void) insertCell:(JMStaticContentTableViewCellBlock)configurationBlock
	   whenSelected:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock
		atIndexPath:(NSIndexPath *)indexPath 
		   animated:(BOOL)animated {

	JMStaticContentTableViewSection *section = [self sectionAtIndex:indexPath.section];

	[section insertCell:configurationBlock 
		   whenSelected:whenSelectedBlock 
			atIndexPath:indexPath
			   animated:animated];
}

#pragma mark - Headers & Footers

- (void) setHeaderText:(NSString *)headerTextValue {
    _headerText = headerTextValue;
    
	if(!headerTextValue) {
		if([self isViewLoaded]) {
			self.tableView.tableFooterView = nil;
		}
		
		return;
	}
	
	if([self isViewLoaded]) {
		UIView *headerLabelContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 0.0)];
		UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 280.0, 0.0)];
        
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.font = [UIFont systemFontOfSize:15.0];
		headerLabel.textColor = [UIColor colorWithRed:61.0/255.0 green:77.0/255.0 blue:99.0/255.0 alpha:1.0];
		headerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.65];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.textAlignment = NSTextAlignmentCenter;
		headerLabel.numberOfLines = 0;
        
		headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		headerLabel.text = self.headerText;
        
		[headerLabel sizeToFit];
        
		CGRect headerLabelContainerViewRect = headerLabelContainerView.frame;
		headerLabelContainerViewRect.size.height = headerLabel.frame.size.height + 10.0;
		headerLabel.frame = headerLabelContainerViewRect;
        
		[headerLabelContainerView addSubview:headerLabel];
        
		CGRect headerLabelFrame = headerLabel.frame;
		headerLabelFrame.size.width = 280.0;
		headerLabelFrame.origin.x = 20.0;
		headerLabelFrame.origin.y = 10.0;	
        headerLabelFrame.size.height += 10.0;
		headerLabel.frame = headerLabelFrame;
        
		CGRect containerFrame = headerLabelContainerView.frame;
		containerFrame.size.height = headerLabel.frame.size.height + 10.0;
		headerLabelContainerView.frame = containerFrame;
        
		self.tableView.tableHeaderView = headerLabelContainerView;
	}
}

- (void) setFooterText:(NSString *)footerTextValue {
    _footerText = footerTextValue;

	if(!footerTextValue) {
		if([self isViewLoaded]) {
			self.tableView.tableFooterView = nil;
		}
		
		return;
	}
	
	if([self isViewLoaded]) {
		UIView *footerLabelContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 0.0)];
		UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 280.0, 0.0)];

		footerLabel.backgroundColor = [UIColor clearColor];
		footerLabel.font = [UIFont systemFontOfSize:15.0];
		footerLabel.textColor = [UIColor colorWithRed:61.0/255.0 green:77.0/255.0 blue:99.0/255.0 alpha:1.0];
		footerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.65];
		footerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		footerLabel.textAlignment = NSTextAlignmentCenter;
		footerLabel.numberOfLines = 0;

		footerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

		footerLabel.text = self.footerText;

		[footerLabel sizeToFit];

		CGRect footerLabelContainerViewRect = footerLabelContainerView.frame;
		footerLabelContainerViewRect.size.height = footerLabel.frame.size.height + 10.0;
		footerLabel.frame = footerLabelContainerViewRect;

		[footerLabelContainerView addSubview:footerLabel];

		CGRect footerLabelFrame = footerLabel.frame;
		footerLabelFrame.size.width = 260.0;
		footerLabelFrame.origin.x = 30.0;
		footerLabelFrame.origin.y = 0.0;	
		footerLabel.frame = footerLabelFrame;

		CGRect containerFrame = footerLabelContainerView.frame;
		containerFrame.size.height = footerLabel.frame.size.height + 10.0;
		footerLabelContainerView.frame = containerFrame;

		self.tableView.tableFooterView = footerLabelContainerView;
	}
}

@end