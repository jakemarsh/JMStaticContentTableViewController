//
//  WifiNetwork.h
//  SettingsExample
//
//  Created by Jake Marsh on 5/22/12.
//  Copyright (c) 2012 Rubber Duck Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiNetwork : NSObject

@property (nonatomic, strong) NSString *networkName;
@property (nonatomic) NSUInteger signalStrength; //From 0-3
@property (nonatomic) BOOL secure;

@end