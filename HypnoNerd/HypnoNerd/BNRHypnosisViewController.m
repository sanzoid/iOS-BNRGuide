//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by Sandy House on 2016-01-20.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"

@interface BNRHypnosisViewController () <UITextFieldDelegate>
@end

@implementation BNRHypnosisViewController

// Override designated initializer to add the tabBarItem's title and image
- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self) {
        // tabBarItem's title
        self.tabBarItem.title = @"Hypnotize";
        
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        
        // tabBarItem's image
        self.tabBarItem.image = i;
    }
    
    return self;
}

- (void)loadView
{
    // Create a view
    BNRHypnosisView *backgroundView = [[BNRHypnosisView alloc] init];
    
    // Create a text field
    CGRect textFieldRect = CGRectMake(40, 70, 240, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    // UITextInputTraits
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"HYPNOTIZE ME!!!";
    textField.returnKeyType = UIReturnKeyDone;
    //textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.autocorrectionType = NO;
    
    // Set the text field's delegate to the BNRHynosisViewController.
    textField.delegate = self;
    
    
    // Add text field as a subview to the backgroundView
    [backgroundView addSubview:textField];
    
    // Set it as the view of this view controller
    self.view = backgroundView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"BNRHypnosisViewController loaded.");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    
    [self drawHypnoticMessage:textField.text];
    
    // Clear the text field and dismiss the keyboard
    textField.text = @"";
    [textField resignFirstResponder];
    
    return YES;
}

- (void)drawHypnoticMessage:(NSString *)message
{
    // Draw the given message 20 times in random spots around the screen
    for (int i = 0; i < 20; i++) {
        
        UILabel *messageLabel = [[UILabel alloc] init];
        
        // Configure the label's colors and text
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.text = message;
        
        // size of label depends on the message
        [messageLabel sizeToFit];
        
        // the bounds minus the width of the label (to fit it)
        int width = (int)(self.view.bounds.size.width);// - messageLabel.bounds.size.width);
        int height = (int)(self.view.bounds.size.height);// - messageLabel.bounds.size.height);
        
        // Random coordinates
        int x = arc4random() % width - messageLabel.bounds.size.width;
        int y = arc4random() % height - messageLabel.bounds.size.height;
        
        // Update the frame's origin
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x,y);
        messageLabel.frame = frame;
        
        // Add label to view
        [self.view addSubview:messageLabel];
        
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-50);
        motionEffect.maximumRelativeValue = @(50);
        [messageLabel addMotionEffect:motionEffect];
        
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue = @(-50);
        motionEffect.maximumRelativeValue = @(50);
        [messageLabel addMotionEffect:motionEffect];
        
        
        
    }
}

@end
