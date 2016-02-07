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


//////////////////////////////////////////////// INITIALIZERS
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
        
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key; 
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


// NSCODER
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
    
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(self) {
        _itemName = [aDecoder decodeObjectForKey:@"itemName"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        
        _valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
        
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"]; 
    }
    
    return self; 
}

// THUMBNAIL IAMGE
- (void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    
    // Thumbnail's rectangle
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    // Scaling ratio - fit the image within the rectangle
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    // Transparent bitmap
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Rounded rectangle path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    
    // All subsequent drawing will clip to rounded rectangle
    [path addClip];
    
    // Center image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // Draw the image on it
    [image drawInRect:projectRect];
    
    // Get image from image context and keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    // Clean up image contesxt resources
    UIGraphicsEndImageContext(); 
    
}

@end
