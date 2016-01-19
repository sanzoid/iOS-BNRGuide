//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by Sandy House on 2016-01-19.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRHypnosisView.h"

@implementation BNRHypnosisView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        // All BNRHypnosisViews start with a clear background
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    
    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + (bounds.size.width / 2.0);
    center.y = bounds.origin.y + (bounds.size.height / 2.0);
    
    
    // A SINGLE CIRCLE
    /*
    // RADIUS: min(width or height) divided by 2
    float radius = (MIN(bounds.size.width, bounds.size.height) / 2.0);
    
    // UIBezierPath: Create an instance
    UIBezierPath *path = [[UIBezierPath alloc] init];
    // define a CIRCLE-shaped path - add an arc to the path at center.
    [path addArcWithCenter:center
                    radius:radius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    */
    
    // CONCENTRIC CIRCLES
    
    // Draw the largest circle and then smaller circles
    // Largest circle will be at the corners of the screen
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        // Pick up the pencil - moves to the starting point of the new circle instead of dragging the pencil over when drawing
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        
        // DEFINE the circle
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
    }
    
    
    // Set line width and color
    path.lineWidth = 10;
    [[UIColor lightGrayColor] setStroke];
    // draw the path
    [path stroke];
    
    
    // DRAWING AN IMAGE
    // Rectangle to draw it in
    CGRect logoRect = CGRectMake(bounds.origin.x, bounds.size.height/2.0 - bounds.size.width/2.0, bounds.size.width, bounds.size.width);
    // Create UIImage instance
    UIImage *logoImage = [UIImage imageNamed:@"180"];
    // Draw the Image in the Rect
    [logoImage drawInRect:logoRect];
    
    
}

@end
