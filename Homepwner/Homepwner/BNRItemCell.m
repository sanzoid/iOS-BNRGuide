//
//  BNRItemCell.m
//  Homepwner
//
//  Created by Sandy House on 2016-02-01.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock(); 
    }
}

@end
