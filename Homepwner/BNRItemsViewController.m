//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by Sandy House on 2016-01-22.
//  Copyright © 2016 sanzapps. All rights reserved.
//
// This file is the DATA SOURCE for the UITableViewController:BNRItemsViewController

#import "BNRItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

@implementation BNRItemsViewController


// DESIGNATED INITIALIZER
- (instancetype)init
{
    // Ensures that we always initialize with PLAIN
    self = [super initWithStyle:UITableViewStylePlain];
    
    NSLog(@"Initializing 5 Random items.");
    // Create 5 random items in the sharedStore
    if(self) {
        for(int i = 0; i < 5; i++) {
            NSLog(@"Item %d.", i);
            [[BNRItemStore sharedStore] createItem];
        }
    }
    
    return self;
}

// UITableViewController's designated initializer.
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    // Override it to call our new designated initializer
    // Totally ignore what style is used 
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create a UITableViewCell instance with default style
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    // Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Get the item at index
    BNRItem *item = [[[BNRItemStore sharedStore] allItems] objectAtIndex: indexPath.row];
    
    // Set the textLabel's text to the item's description
    cell.textLabel.text = [item description];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If there are no cells in the reuse pool, instantiate UITableViewCells with the reuse identifier
    // This is necessary when we don't explicitly create our cells and depend on reusing cells
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

@end
