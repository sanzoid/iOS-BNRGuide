//
//  BNRContainer.m
//  RandomItems
//
//  Created by Sandy House on 2016-01-18.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRContainer.h"

@implementation BNRContainer

// override my superclass' designated initializer
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber {
    return [self initWithItemName:name
                   valueInDollars:value
                     serialNumber:sNumber
                      listOfItems:nil];
}

// Make this my DESIGNATED INITIALIZER
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber
                     listOfItems:(NSArray *)arr {
    
    self = [super initWithItemName:name valueInDollars:value serialNumber:sNumber];    // this does everything in my superclass' designated initializer
    
    if(self) {
        _subitems = arr;
    }
    
    
    return self;
    
}


- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                     listOfItems:(NSArray *)arr {
    
    return [self initWithItemName:name
                   valueInDollars:value
                     serialNumber:@""
                      listOfItems:arr];
}

- (void)setSubitems:(NSArray *)arr {
    _subitems = arr;
}

- (NSArray *)subitems {
    return _subitems;
}



- (NSString *)description {
    
    
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"Container %@: Worth $%d. Total worth: $%@. \nItems inside: %@", self.itemName, self.valueInDollars, [self containerSum], self.subitems];
    
    return descriptionString;
}

- (NSString *)containerSum {
    // Go through each item in the array and add up its items
    int sum = 0;
    
    for(id item in self.subitems) {
        // item is a BNRitem
        sum += [item valueInDollars];
    }
    
    sum += self.valueInDollars;
    
    NSString *sumString = [NSString stringWithFormat:@"%d", sum];
    
    return sumString;
}

@end
