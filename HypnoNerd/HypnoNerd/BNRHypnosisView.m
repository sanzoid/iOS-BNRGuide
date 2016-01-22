//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by Sandy House on 2016-01-19.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRHypnosisView.h"

@interface BNRHypnosisView ()

@property (strong, nonatomic) UIColor *circleColor;

@end

@implementation BNRHypnosisView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        // Default colors
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor redColor];
        NSLog(@"eewe");
        //self.userInteractionEnabled = YES;
    }
    
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
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
    // [[UIColor lightGrayColor] setStroke];
    [self.circleColor setStroke];
    
    // draw the path
    [path stroke];
    
    /*
    // DRAWING AN IMAGE
    // Rectangle to draw it in
    CGRect logoRect = CGRectMake(bounds.origin.x, bounds.size.height/2.0 - bounds.size.width/2.0, bounds.size.width, bounds.size.width);
    // Create UIImage instance
    UIImage *logoImage = [UIImage imageNamed:@"180"];
    // Draw the Image in the Rect
    [logoImage drawInRect:logoRect];
    */
    
}

// Override touchesBegan:withEvent:
// This is when a finger touches the screen
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"I was touched");
    
    // Get 3 random numbers between 0 and 1 to generate a random color
    float red = (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue = (arc4random() % 100) / 100.0;
    
    NSLog(@"%f, %f, %f", red, green, blue);
    
    UIColor *randomColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1.0];
    self.circleColor = randomColor;
    
    
    // Get 3 random numbers between 0 and 1 to generate a random color
    float red2 = (arc4random() % 100) / 100.0;
    float green2 = (arc4random() % 100) / 100.0;
    float blue2 = (arc4random() % 100) / 100.0;
    
    NSLog(@"%f, %f, %f", red2, green2, blue2);
    
    UIColor *randomColor2 = [UIColor colorWithRed:red2
                                           green:green2
                                            blue:blue2
                                           alpha:1.0];
    self.backgroundColor = randomColor2;
    

}

- (void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    [self setNeedsDisplay];
}


@end
