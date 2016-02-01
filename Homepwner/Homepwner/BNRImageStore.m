//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Sandy House on 2016-01-25.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()

@property (nonatomic, strong) NSMutableDictionary *imageDictionary;

- (NSString *)imagePathForKey:(NSString *)key;

@end

@implementation BNRImageStore


+ (instancetype)sharedStore
{
    
    static BNRImageStore *sharedStore = nil;
    
    /*
    if(!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
     */
    
    // thread-safe 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore; 
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BNRImageStore sharedStore]" userInfo:nil];
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if(self) {
        _imageDictionary = [[NSMutableDictionary alloc] init];
        
        // Observe memory warning notification. Triggers clearCache:
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    _imageDictionary[key] = image;
    
    // Store image
    // Create a full path for the image
    NSString *imagePath = [self imagePathForKey:key];
    
    // Turn image into JPEG data
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    // Write it to full path
    [data writeToFile:imagePath atomically:YES];
}
- (UIImage *)imageForKey:(NSString *)key
{
    //return _imageDictionary[key];
    
    // If possible, get it from the dictionary
    UIImage *result = _imageDictionary[key];
    
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        if (result) {
            _imageDictionary[key] = result;
        } else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    
    return result;
}
- (void)deleteImageForKey:(NSString *)key
{
    if(!key) {
        return; 
    }
    _imageDictionary[key] = nil;
    
    // Delete image in filesystem
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}


- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %tu images out of the cache", [self.imageDictionary count]);
    // All images will lose an owner and be destroyed unless it's currently being displayed
    [self.imageDictionary removeAllObjects];
}

@end
