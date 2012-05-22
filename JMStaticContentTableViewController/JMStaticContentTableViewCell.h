#import <Foundation/Foundation.h>
#import "JMStaticContentTableViewBlocks.h"

@interface JMStaticContentTableViewCell : NSObject

@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) UITableViewCellStyle cellStyle;
@property (nonatomic, strong) Class tableViewCellSubclass;
@property (nonatomic) UITableViewCellEditingStyle editingStyle; // Defaults to 'UITableViewCellEditingStyleNone'
@property (nonatomic) BOOL editable; // Defaults to 'NO'
@property (nonatomic) BOOL moveable; // Defaults to 'NO'

@property (nonatomic, copy) JMStaticContentTableViewCellBlock configureBlock;
@property (nonatomic, copy) JMStaticContentTableViewCellWhenSelectedBlock whenSelectedBlock;

- (void) setWhenSelectedBlock:(JMStaticContentTableViewCellWhenSelectedBlock)whenSelectedBlock;

@end