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
#import "BNRDetailViewController.h"

@interface BNRItemsViewController ()

//@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation BNRItemsViewController


// DESIGNATED INITIALIZER
- (instancetype)init
{
    // Ensures that we always initialize with PLAIN
    self = [super initWithStyle:UITableViewStylePlain];
    
    NSLog(@"Initializing 5 Random items.");
    if(self) {
        /*// Create 5 random items in sharedStore
        for(int i = 0; i < 5; i++) {
            NSLog(@"Item %d.", i);
            [[BNRItemStore sharedStore] createItem];
        }
        */
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        // Bar Button item
        UIBarButtonItem *bbiNewItem = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];

        navItem.rightBarButtonItem = bbiNewItem;
        navItem.leftBarButtonItem = self.editButtonItem;
        
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
    /*
    // Tell the table about its headerView
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
     */
    
}

- (IBAction)addNewItem:(id)sender
{
    // Create a new BNRItem, insert into sharedStore, find out its index
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    
    //NSInteger lastRow = [self.tableView numberOfRowsInSection:0]; // after the last item
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // Insert new row into table
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
    
}

/*// We no longer need the headerView
- (IBAction)toggleEditingMode:(id)sender
{
    // We want to toggle the editing mode. By toggling the UIViewController's editing mode, we also toggle the table view's as it does it to match the view controller. Table copies view controller's editing mode.
    if (self.isEditing) {
        // Change text of button to inform user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        // Turn off editing mode
        [self setEditing:NO animated:YES];
    } else {
        // Change text of button to inform user of state
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        // Turn on editing mode
        [self setEditing:YES animated:YES];
    }
}


- (UIView *)headerView
{
    // Lazy instantiation - puts off loading it until it's needed
    if(!_headerView) {
        // Load HeaderView.xib
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
        // _headerView always pointed to the UIView inside the NIB file, now it has loaded the file so it knows of it.
    }
    return _headerView;
}
*/

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if the table view is asking to delete
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        // Find the item and remove it from the dataSource
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        // Remove it in the table as well
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath
      toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}

// Gold challenge
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return @"FINISH ME";
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] init];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = items[indexPath.row];
    
    // Pass the item to the BNRDetailViewController
    detailViewController.item = selectedItem;   // setItem 
    
    // Push onto the top of the controller stack
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData]; 
}

@end
