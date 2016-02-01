//
//  BNRDrawViewController.m
//  TouchTracker
//
//  Created by Sandy House on 2016-01-26.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"

@interface BNRDrawViewController ()

@end

@implementation BNRDrawViewController


// Set up the view controller's view programmatically
- (void)loadView
{
    // Set up an instance of BNRDrawView as BNRDrawViewController's view
    BNRDrawView *drawView = [[BNRDrawView alloc] initWithFrame:CGRectZero];
    self.view = drawView;
}







- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
