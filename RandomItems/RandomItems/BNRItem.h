//
//  BNRItem.h
//  RandomItems
//
//  Created by Sandy House on 2016-01-15.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject
{
    // Instance Variables
    NSString *_itemName;
    NSString *_serialNumber;
    int _valueInDollars;
    NSDate *_dateCreated;
    
    // Allow it to hold another BNRItem
    BNRItem *_containedItem;
    __weak BNRItem *_container;
}

// Class Methods
+ (instancetype)randomItem; 

// Initializers
// Designated initializer
// initWithItemName:valueInDollars:serialNumber:
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;
// initWithItemName:serialNumber:
- (instancetype)initWithItemName:(NSString *)name
                    serialNumber:(NSString *)sNumber; 
// initWithItemName:
- (instancetype)initWithItemName:(NSString *)name;


// Instance Methods
- (void)setItemName:(NSString *)str;
- (NSString *)itemName;

- (void)setSerialNumber:(NSString *)str;
- (NSString *)serialNumber;

- (void)setValueInDollars:(int)v;
- (int)valueInDollars;

// read only so no setter 
- (NSDate *)dateCreated;

- (void)setContainedItem:(BNRItem *)item;
- (BNRItem *)containedItem;

- (void)setContainer:(BNRItem *)item;
- (BNRItem *)container; 

@end
