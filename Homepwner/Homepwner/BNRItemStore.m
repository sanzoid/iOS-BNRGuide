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
#import "AppDelegate.h"

@import CoreData;

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray *privateAllItems; 

@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

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
        /*
         // RETRIVE FROM ARCHIVE
        //_privateAllItems = [[NSMutableArray alloc] init];
        NSString *path = [self itemArchivePath];
        _privateAllItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If nothing was previously saved
        if (!_privateAllItems) {
            _privateAllItems = [[NSMutableArray alloc] init];
        }
         */
        
        // CORE DATA MODIFICATIONS
        // Read in in Homepwner.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // Where does SQLite file go?
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        // Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];    // Core Data
        
    }
    
    return self;
}

- (BNRItem *)createItem
{
    NSLog(@"Creating a random item");
    //BNRItem *item = [BNRItem randomItem];
    //BNRItem *item = [[BNRItem alloc] init];
    
    // Insert new object from entity
    double order;
    if ([self.allItems count] == 0) {   // Start at 1.0
        order = 1.0;
    } else {    // Increase count by 1.0 for the order
        order = [[self.privateAllItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"After adding %d items, order = %.2f", [self.privateAllItems count], order);
    
    BNRItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem"
                                                  inManagedObjectContext:self.context];
    item.orderingValue = order;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    item.valueInDollars = [defaults integerForKey:BNRNextItemValuePrefsKey];
    item.itemName = [defaults objectForKey:BNRNextItemNamePrefsKey];
    
    NSLog(@"defaults = %@", [defaults dictionaryRepresentation]); 
    
    [self.privateAllItems addObject:item];
    
    return item;
}

- (void)removeItem:(BNRItem *)item
{
    // Remove image from image store 
    NSString *key = item.itemKey;
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.context deleteObject:item]; // remove from database
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
    
    // Compute a new orderValue for the object that was moved
    double lowerBound = 0.0;
    if (toIndex > 0) {
        lowerBound = [self.privateAllItems[(toIndex - 1)] orderingValue];
    } else {
        lowerBound = [self.privateAllItems[1] orderingValue] - 2.0;
    }

    double upperBound = 0.0;
    if (toIndex < [self.privateAllItems count] - 1) {
        upperBound = [self.privateAllItems[(toIndex + 1)] orderingValue];
    } else {
        upperBound = [self.privateAllItems[(toIndex - 1)] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    NSLog(@"moving %f to order %f", item.orderingValue, newOrderValue);
    item.orderingValue = newOrderValue;
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
    
    //return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
    
}

- (BOOL)saveChanges
{
    // ARCHIVING
    /*NSString *path = [self itemArchivePath];
    NSLog(@"%@",path);
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateAllItems
                                       toFile:path];*/
    
    // CORE DATA
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)loadAllItems
{
    if (!self.privateAllItems) {
        // Create an NSFetchRequest
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // Give it an entity
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRItem"
                                             inManagedObjectContext:self.context];
        request.entity = e;
        
        // Give it a sort descripter
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue"
                                                             ascending:YES];
        request.sortDescriptors = @[sd];
        
        // Make the request
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request
                                                      error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateAllItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSArray *)allAssetTypes
{
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRAssetType"
                                           inManagedObjectContext:self.context];
        request.entity = e;
        
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request
                                                      error:&error];
        if(!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    
    // First time program being run
    if ([_allAssetTypes count] == 0) {
        NSManagedObject *type;
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
    }
    return _allAssetTypes;
}

@end
