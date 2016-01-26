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

@end

@implementation BNRImageStore


+ (instancetype)sharedStore
{
    
    static BNRImageStore *sharedStore = nil;
    
    if(!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
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
        
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    _imageDictionary[key] = image;
}
- (UIImage *)imageForKey:(NSString *)key
{
    return _imageDictionary[key];
}
- (void)deleteImageForKey:(NSString *)key
{
    if(!key) {
        return; 
    }
    _imageDictionary[key] = nil;
}


@end
