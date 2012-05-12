#import "StaticTextFieldTableViewCell.h"

@implementation StaticTextFieldTableViewCell

@synthesize contentTextField = _contentTextField;

- (void) dealloc {
	[_contentTextField release];

	[super dealloc];
}

@end