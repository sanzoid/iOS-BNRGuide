//
//  BNRItem.m
//  Homepwner
//
//  Created by Sandy House on 2016-02-05.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

// Insert code here to add functionality to your managed object subclass

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    self.dateCreated = [NSDate date];
    
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.itemKey = key; 
}

// THUMBNAIL IMAGE
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
