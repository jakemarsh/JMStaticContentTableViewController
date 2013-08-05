#import <Foundation/Foundation.h>
#import "JMStaticContentTableViewBlocks.h"

@class JMStaticContentTableViewCell;

@interface JMStaticContentTableViewSection : NSObject

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *staticContentCells;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSString *footerTitle;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic) NSInteger sectionIndex;

- (void) addCell:(JMStaticContentTableViewCellBlock)configurationBlock;

- (void) addCell:(JMStaticContentTableViewCellBlock)configurationBlock
	whenSelected:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock;

- (void) addCell:(JMStaticContentTableViewCellBlock)configurationBlock
        animated:(BOOL)animated;

- (void) insertCell:(JMStaticContentTableViewCellBlock)configurationBlock
	   whenSelected:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock
		atIndexPath:(NSIndexPath *)indexPath
		   animated:(BOOL)animated;

- (void) insertCell:(JMStaticContentTableViewCellBlock)configurationBlock
       whenSelected:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock
        atIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated updateView:(BOOL)updateView;

- (void) reloadCellAtIndex:(NSUInteger)rowIndex;
- (void) reloadCellAtIndex:(NSUInteger)rowIndex animated:(BOOL)animated;

- (void) removeAllCells;
- (void) removeCellAtIndex:(NSUInteger)rowIndex;
- (void) removeCellAtIndex:(NSUInteger)rowIndex animated:(BOOL)animated;

@end