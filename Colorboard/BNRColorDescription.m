//
//  BNRColorDescription.m
//  Colorboard
//
//  Created by Sandy House on 2016-02-08.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRColorDescription.h"

@implementation BNRColorDescription

- (instancetype)init
{
    self = [super init];
    if (self) {
        _color = [UIColor colorWithRed:0
                                 green:0
                                  blue:1
                                 alpha:1];
        _name = @"Blue";
    }
    return self; 
}

@end
