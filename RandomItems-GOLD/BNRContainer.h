//
//  BNRContainer.h
//  RandomItems
//
//  Created by Sandy House on 2016-01-18.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRItem.h"

@interface BNRContainer : BNRItem {
    NSArray *_subitems;
}

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber
                     listOfItems:(NSArray *)arr;
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                     listOfItems:(NSArray *)arr;

- (void)setSubitems:(NSArray *)arr;
- (NSArray *)subitems;

// Adds the values of all of the subitems and the container itself
- (NSString *)containerSum;

@end
