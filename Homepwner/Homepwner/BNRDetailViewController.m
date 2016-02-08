//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Sandy House on 2016-01-25.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "BNRAssetTypeViewController.h"
#import "AppDelegate.h";

@interface BNRDetailViewController ()
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate,
        UITextFieldDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

@end

@implementation BNRDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Add the image view
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:iv];
    
    self.imageView = iv;
    
    
    // Dictionary for views
    NSDictionary *viewMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLabel,
                                @"toolbar" : self.toolbar};
    
    // CONSTRAINTS
    // 0 points from left and right edges
    NSArray *ivHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:viewMap];
    // 8 points from top and bottom
    NSArray *ivVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-8-[imageView]-8-[toolbar]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:viewMap];
    [self.view addConstraints:ivHorizontalConstraints];
    [self.view addConstraints:ivVerticalConstraints];
    
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
}

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class]; 
        
        // If we are creating a detail view controller for a NEW item and not an existing item
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        // Register for UIContentSizeCategoryDidChangeNotification so it will updateFonts when that happens 
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(updateFonts)
                              name:UIContentSizeCategoryDidChangeNotification
                            object:nil];
        
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
    
    // AUTOLAYOUT DEBUGGING: Show all the ways it could layout the ambiguous stuff
    /*
    for (UIView *subview in self.view.subviews) {
        if([subview hasAmbiguousLayout]) {
            [subview exerciseAmbiguityInLayout];
        }
    }
    */
}

- (IBAction)takePicture:(id)sender
{
    if ([self.imagePickerPopover isPopoverVisible]) {
        // If popover is already up, get rid of it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    // Create an UIImagePickerController with sourceType and assign it a delegate
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If device has a camera, use camera.  
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    // Place imagePicker on the screen
    //[self presentViewController:imagePicker animated:YES completion:nil];
    
    // iPad - only ipads can have a Popover controller
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //Create a new popover controller that will display the imagePicker
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];  // DEPRECATED IN iOS 9.0
        self.imagePickerPopover.delegate = self;
        
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                                        animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self.item setThumbnailFromImage:image]; 
    
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey]; 
    
    // Take image picker off the screen
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    // Do I have a popover?
    if (self.imagePickerPopover) {
        // dismiss popover
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        // Dismiss modal image picker
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    BNRItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    // Format the date - turn NSDate into NSString  
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    // show image
    NSString *imageKey = self.item.itemKey;
    // Get the image
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
    // Put image on screen
    self.imageView.image = imageToDisplay;
    
    
    // Update title of button to show asset type 
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel) {
        //typeLabel = @"None";
        typeLabel = NSLocalizedString(@"None", @"Type label None");
    }
    //self.assetTypeButton.title = [NSString stringWithFormat:@"Type: %@", typeLabel];
    self.assetTypeButton.title = [NSString stringWithFormat:NSLocalizedString(@"Type: %@", @"Asset type button"), typeLabel];
    
    [self updateFonts];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES]; // ake first responder resign
    
    // Update the properties with what's currently in the textfields
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    //item.valueInDollars = [self.valueField.text intValue];
    
    int newValue = [self.valueField.text intValue];
    
    // if what's in the valueField has changed
    if (newValue != item.valueInDollars) {
        item.valueInDollars = newValue; // update the item
        
        // Update the default
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:newValue
                      forKey:BNRNextItemValuePrefsKey];
    }
    
}

// Make keyboard disappear when return button tapped
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
// AUTOLAYOUT DEBUG
- (void)viewDidLayoutSubviews {
    for (UIView *subview in self.view.subviews) {
        if([subview hasAmbiguousLayout]) {
            NSLog(@"AMBIGUOUS: %@", subview);
        }
    }
}
*/

// ORIENTATION STUFF
- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    // iPad? Don't do anything extra
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // landscape? hide imageView and toolbar cameraButton
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {    // portrait
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

// This is sent to view controller when the orientation successfully changes
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

- (void)save:(id)sender
{
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    [[BNRItemStore sharedStore] removeItem:self.item];
    
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

// Set the font for each label and field
- (void)updateFonts
{
    // get a preconfigured font that is customized to the user's preferences 
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    
    self.nameField.font = font;
    self.serialNumberField.font = font;
    self.valueField.font = font;
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (IBAction)showAssetTypePicker:(id)sender {
    [self.view endEditing:YES];
    
    BNRAssetTypeViewController *avc = [[BNRAssetTypeViewController alloc] init];
    avc.item = self.item;
    
    [self.navigationController pushViewController:avc
                                         animated:YES];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    BOOL isNew = NO;
    if ([identifierComponents count] == 3) {
        isNew = YES;
    }
    
    return [[self alloc] initForNewItem:isNew];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.item.itemKey
                 forKey:@"item.itemKey"];
    
    // save changes to item made by user
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
    
    // Have store save changes to disk
    [[BNRItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
    
    for (BNRItem *item in [[BNRItemStore sharedStore] allItems]) {
        if ([itemKey isEqualToString:item.itemKey]) {
            self.item = item;
            break;
        }
    }
    
    [super decodeRestorableStateWithCoder:coder];
}

@end
