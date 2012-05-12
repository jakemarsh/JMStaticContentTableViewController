#import <Foundation/Foundation.h>
#import "JMStaticContentTableViewBlocks.h"

@interface JMStaticContentTableViewCell : NSObject

@property (nonatomic, retain) NSString *reuseIdentifier;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) UITableViewCellStyle cellStyle;
@property (nonatomic, retain) Class tableViewCellSubclass;

@property (nonatomic, copy) JMStaticContentTableViewCellBlock configureBlock;
@property (nonatomic, copy) JMStaticContentTableViewCellWhenSelectedBlock whenSelectedBlock;

@end