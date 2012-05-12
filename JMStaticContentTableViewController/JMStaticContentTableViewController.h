#import <UIKit/UIKit.h>
#import "JMStaticContentTableViewSection.h"
#import "JMStaticContentTableViewCell.h"
#import "StaticTextFieldTableViewCell.h"
#import "JMStaticContentTableViewBlocks.h"

@interface JMStaticContentTableViewController : UITableViewController

@property (nonatomic, retain) NSArray *staticContentSections;
@property (nonatomic, retain) NSString *footerText;

- (void) addSection:(JMStaticContentTableViewControllerAddSectionBlock)b;

- (void) insertSection:(JMStaticContentTableViewControllerAddSectionBlock)b 
			   atIndex:(NSUInteger)sectionIndex;

- (void) insertSection:(JMStaticContentTableViewControllerAddSectionBlock)b 
			   atIndex:(NSUInteger)sectionIndex 
			  animated:(BOOL)animated;

- (void) removeAllSections;

- (void) removeSectionAtIndex:(NSUInteger)sectionIndex;
- (void) removeSectionAtIndex:(NSUInteger)sectionIndex animated:(BOOL)animated;

- (JMStaticContentTableViewSection *) sectionAtIndex:(NSUInteger)sectionIndex;

- (void) insertCell:(JMStaticContentTableViewCellBlock)configurationBlock 
		atIndexPath:(NSIndexPath *)indexPath 
		   animated:(BOOL)animated;

- (void) insertCell:(JMStaticContentTableViewCellBlock)configurationBlock
	   whenSelected:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock
		atIndexPath:(NSIndexPath *)indexPath 
		   animated:(BOOL)animated;

@end