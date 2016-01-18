//
//  BNRItem.m
//  RandomItems
//
//  Created by Sandy House on 2016-01-15.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

// Create, configure, and return a BNRItem instance
+ (instancetype)randomItem {
    
    // We want a random item so we need random values for each instance variable
    
    // Array of adjectives
    NSArray *randomAdjectiveList = @[@"Poopy", @"Shiny", @"Rich"];
    // Array of nouns
    NSArray *randomNounList = @[@"Finger", @"Butt", @"Nose"];
    
    // Get a random adjective and noun index
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    // Form a random item name from the adjective and noun
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            randomAdjectiveList[adjectiveIndex],
                            randomNounList[nounIndex]];
    // Random price
    int randomPrice = arc4random() % 100;
    // random serial number
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10];
    
    // create the new item
    BNRItem *newItem = [[self alloc] initWithItemName:randomName
                                       valueInDollars:randomPrice
                                         serialNumber:randomSerialNumber];
    return newItem;
    
}


// INITIALIZERS
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber {
    // Call the superclass' designated initializer
    self = [super init];
    
    if (self) {
        // Give the instance variables initial calues
        _itemName = name;
        _valueInDollars = value;
        _serialNumber = sNumber;
        // current date and time
        _dateCreated = [[NSDate alloc] init];
    }
    
    return self;
}
- (instancetype)initWithItemName:(NSString *)name {
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}
- (instancetype)initWithItemName:(NSString *)name
                    serialNumber:(NSString *)sNumber {
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:sNumber];
}
- (instancetype)init {
    return [self initWithItemName:@"Item"];
}

// SETTERS AND GETTERS

- (void)setItemName:(NSString *)str {
    _itemName = str;
}
- (NSString *)itemName {
    return _itemName;
}

- (void)setSerialNumber:(NSString *)str {
    _serialNumber = str;
}
- (NSString *)serialNumber {
    return _serialNumber;
}

- (void)setValueInDollars:(int)v {
    _valueInDollars = v;
}
- (int)valueInDollars {
    return _valueInDollars;
}

- (NSDate *)dateCreated {
    return _dateCreated;
}

- (void)setContainedItem:(BNRItem *)item {
    _containedItem = item;
    
    // self contains item so item's container is self.
    item.container = self;
}
- (BNRItem *)containedItem {
    return _containedItem;
}

- (void)setContainer:(BNRItem *)item {
    _container = item;
}
- (BNRItem *)container {
    return _container;
}

// Override the description method
- (NSString *)description {
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
     self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    
    return descriptionString;
}

// Override dealloc method
- (void)dealloc {
    NSLog(@"Destroyed: %@", self); 
}

@end
