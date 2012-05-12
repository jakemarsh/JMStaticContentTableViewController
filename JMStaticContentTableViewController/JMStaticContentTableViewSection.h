#import <Foundation/Foundation.h>
#import "JMStaticContentTableViewBlocks.h"

@class JMStaticContentTableViewCell;

@interface JMStaticContentTableViewSection : NSObject

@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, retain) NSArray *staticContentCells;
@property (nonatomic, retain) NSString *title;

- (void) addCell:(JMStaticContentTableViewCellBlock)configurationBlock;

- (void) addCell:(JMStaticContentTableViewCellBlock)configurationBlock
	whenSelected:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock;

- (void) insertCell:(JMStaticContentTableViewCellBlock)configurationBlock
	   whenSelected:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock
		atIndexPath:(NSIndexPath *)indexPath
		   animated:(BOOL)animated;

- (void) removeAllCells;
- (void) removeCellAtIndex:(NSUInteger)rowIndex;
- (void) removeCellAtIndex:(NSUInteger)rowIndex animated:(BOOL)animated;

@end