//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Sandy House on 2016-01-22.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray *privateAllItems; 


@end

@implementation BNRItemStore

// This should only be called to retrieve the singleton instance of BNRItemStore
+ (instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil; // declared and initialized at the start of the program - not every time the method is called
    
    /*// Creates single instance the first time this method is called
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
     */
    
    // thread-safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
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
        //_privateAllItems = [[NSMutableArray alloc] init];
        NSString *path = [self itemArchivePath];
        _privateAllItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If nothing was previously saved
        if (!_privateAllItems) {
            _privateAllItems = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

- (BNRItem *)createItem
{
    NSLog(@"Creating a random item");
    //BNRItem *item = [BNRItem randomItem];
    BNRItem *item = [[BNRItem alloc] init];
    
    [self.privateAllItems addObject:item];
    
    return item;
}

- (void)removeItem:(BNRItem *)item
{
    // Remove image from image store 
    NSString *key = item.itemKey;
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.privateAllItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    
    BNRItem *item = [self.privateAllItems objectAtIndex:fromIndex];
    
    // Remove from array
    [self.privateAllItems removeObjectAtIndex:fromIndex];
    // Readd to array
    [self.privateAllItems insertObject:item atIndex:toIndex];
}

// Getter for allItems. Return privateAllItems, an NSMutableArray, as an NSArray. (NSMutableArray is an NSArray)
- (NSArray *)allItems
{
    return self.privateAllItems;
}


- (NSString *)itemArchivePath
{
    // Find paths that have the NSDocumentDirectory - there will only be one on iOS 
    NSArray *documentDirectories =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get a document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    
    
    
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    NSLog(@"%@",path);
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateAllItems
                                       toFile:path];
}



@end
