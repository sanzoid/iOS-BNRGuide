//
//  main.m
//  RandomItems
//
//  Created by Sandy House on 2016-01-15.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

		// CREATE MUTABLE ARRAY
		NSMutableArray* items = [[NSMutableArray alloc] init];
		
		/*
		// ARRAY ADD OBJECTS AT END: addObject:
		[items addObject:@"One"];
		[items addObject:@"Two"];
		[items addObject:@"Three"];
		*/
		
		/*
		// ARRAY INSERT OBJECTS AT INDEX: insertObject:atIndex:
		[items insertObject:@"Zero" atIndex:0];
		 */
		
		/*
		// FAST ENUMERATION
		for (NSString* item in items) {
			NSLog(@"%@", item);
		}
		*/
		
		// INIT
		//BNRItem *item = [[BNRItem alloc] init];
		
		// INITIALIZE VARIABLES YOURSELF
		/*
		// MESSAGE SYNTAX
		[item setItemName:@"Headphones"];
		[item setSerialNumber:@"EP650"];
		[item setValueInDollars:50];
		NSLog(@"%@ %@ %@ %d",
		 [item itemName], [item dateCreated], [item serialNumber], [item valueInDollars]);
		*/
		
		/*
		// DOT SYNTAX
		item.itemName = @"Headphones";
		item.serialNumber = @"EP650";
		item.valueInDollars = 50;
		NSLog(@"%@ %@ %@ %d", item.itemName, item.dateCreated, item.serialNumber, item.valueInDollars);
		*/

		
		/*
		// DIFFERENT INITIALIZERS
		BNRItem *item = [[BNRItem alloc] initWithItemName:@"Headphones"
		valueInDollars:50
		serialNumber:@"EP650"];
		BNRItem *itemWithName = [[BNRItem alloc] initWithItemName:@"Contigo Mug"];
		BNRItem *itemWithNoName = [[BNRItem alloc] init];
		
		// NSLogging an object - When you NSLog an object, it sends the description message to that object and returns a string
		NSLog(@"%@", item);
		NSLog(@"%@", itemWithName);
		NSLog(@"%@", itemWithNoName);
		*/
		
		/*
		// RANDOM ITEM: Creating a random item using our randomItem class method
		BNRItem *randomItem = [BNRItem randomItem];
		NSLog(@"%@", randomItem);
		*/
		
		/*
		// RANDOM ITEMS: Fill the items array with 10 random items and log each of them
		for(int i = 0; i < 10; i++) {
			BNRItem *newItem = [BNRItem randomItem];
			[items addObject:newItem];
		}
		
		for(BNRItem *item in items) {
			NSLog(@"%@", item);
		}
		*/
		
		/*
		// SILVER CHALLENGE: Another Initializer
		// INITIALIZER: initWithItemName:serialNumber:
		BNRItem *coolItem = [[BNRItem alloc] initWithItemName:@"Charlie"
												 serialNumber:@"Unicorn"];
		[items addObject:coolItem];
		NSLog(@"%@", coolItem);
		*/
		
		// EXCEPTION: UNRECOGNIZED SELECTOR
		// lastObj is an instance of BNRItem - it will not understand the count message
		//id lastObj = [items lastObject];
		//[lastObj count];
		
		// EXCEPTION: BEYOND BOUNDS
		//id noObj = [items objectAtIndex:12];
		
		// BACKPACK
		BNRItem *backpack = [[BNRItem alloc] initWithItemName:@"Backpack"];
		BNRItem *calculator = [[BNRItem alloc] initWithItemName:@"Calculator"];
		backpack.containedItem = calculator;
		
		backpack = nil;
		calculator = nil;
		
		// Destroy the mutable array object
		NSLog(@"DEATH TO ITEMS!!!");
		items = nil;
		
    }
    return 0;
}
