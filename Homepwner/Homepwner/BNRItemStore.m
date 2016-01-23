//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Sandy House on 2016-01-22.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray *privateAllItems; 

@end

@implementation BNRItemStore

// This should only be called to retrieve the singleton instance of BNRItemStore
+ (instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil; // declared and initialized at the start of the program - not every time the method is called
    
    // Creates single instance the first time this method is called
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

// No one should call this as the singleton instance is never explicitly initialized.
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BNRItemStore shardStore]" userInfo:nil];
    return nil;
}

// The real initializer - only sharedStore calls this once to create the singleton instance
- (instancetype)initPrivate
{
    NSLog(@"Initializing single instance of the items array");
    self = [super init];
    
    // instantiate privateAllItems
    if(self) {
        _privateAllItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (BNRItem *)createItem
{
    NSLog(@"Creating a random item");
    BNRItem *item = [BNRItem randomItem];
    
    [self.privateAllItems addObject:item];
    
    return item;
}

// Getter for allItems. Return privateAllItems, an NSMutableArray, as an NSArray. (NSMutableArray is an NSArray)
- (NSArray *)allItems
{
    return self.privateAllItems;
}



@end
