//
//  BNRImageTransformer.m
//  Homepwner
//
//  Created by Sandy House on 2016-02-05.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRImageTransformer.h"
#import <UIKit/UIKit.h>

@implementation BNRImageTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

// UIImage -> NSData for saving to Core Data
- (id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

// Called when thumbnail data loaded from filesystem
- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];   // Create UIImage from NSData that was stored 
}

@end
