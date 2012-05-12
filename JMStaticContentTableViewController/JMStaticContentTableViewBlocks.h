//
//  JMStaticContentTableView.h
//  JMStaticTableViewController
//
//  Created by Jake Marsh on 10/8/11.
//  Copyright (c) 2011 Rubber Duck Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMStaticContentTableViewSection, JMStaticContentTableViewCell;

typedef void(^JMStaticContentTableViewCellBlock)(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath);
typedef void(^JMStaticContentTableViewCellWhenSelectedBlock)(NSIndexPath *indexPath);

typedef void(^JMStaticContentTableViewControllerAddSectionBlock)(JMStaticContentTableViewSection *section, NSUInteger sectionIndex);