//
//  BNRItem+CoreDataProperties.h
//  Homepwner
//
//  Created by Sandy House on 2016-02-05.
//  Copyright © 2016 sanzapps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BNRItem.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNRItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *itemName;
@property (nullable, nonatomic, retain) NSString *serialNumber;
//@property (nullable, nonatomic, retain) NSNumber *valueInDollars;
@property (nonatomic) int valueInDollars;
@property (nullable, nonatomic, retain) NSDate *dateCreated;
@property (nullable, nonatomic, retain) NSString *itemKey;
//@property (nullable, nonatomic, retain) id thumbnail;
@property (nonatomic, strong) UIImage *thumbnail;
//@property (nullable, nonatomic, retain) NSNumber *orderingValue;
@property (nonatomic) double orderingValue;
@property (nullable, nonatomic, retain) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image; 

@end

NS_ASSUME_NONNULL_END
