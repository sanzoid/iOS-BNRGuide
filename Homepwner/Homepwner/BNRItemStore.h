//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Sandy House on 2016-01-22.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem; 

@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

// Get the singleton instance of BNRItemStore
+ (instancetype)sharedStore;

- (BNRItem *)createItem; 
- (void)removeItem:(BNRItem *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex;

@end
