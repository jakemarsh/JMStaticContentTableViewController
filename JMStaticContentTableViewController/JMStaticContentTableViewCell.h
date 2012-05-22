#import <Foundation/Foundation.h>
#import "JMStaticContentTableViewBlocks.h"

@interface JMStaticContentTableViewCell : NSObject

@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) UITableViewCellStyle cellStyle;
@property (nonatomic, strong) Class tableViewCellSubclass;

@property (nonatomic, copy) JMStaticContentTableViewCellBlock configureBlock;
@property (nonatomic, copy) JMStaticContentTableViewCellWhenSelectedBlock whenSelectedBlock;

- (void) setWhenSelectedBlock:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock;

@end