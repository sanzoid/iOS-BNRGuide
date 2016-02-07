//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by Sandy House on 2016-01-25.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetailViewController : UIViewController <UIViewControllerRestoration>

- (instancetype)initForNewItem:(BOOL)isNew; 

@property (nonatomic, strong)BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);


@end
