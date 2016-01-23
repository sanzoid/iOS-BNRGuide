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
 
}

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

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




@end
