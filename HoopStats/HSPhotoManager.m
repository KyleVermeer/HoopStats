//
//  HSPhotoManager.m
//  HoopStats
//
//  Created by Kyle Vermeer on 3/16/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "HSPhotoManager.h"

@interface HSPhotoManager()

@property (strong, nonatomic) NSURL* photosStorageURL;

@end

#define PLAYER_PHOTOS_DIRECTORY @"PLAYER_PHOTOS"

@implementation HSPhotoManager

static HSPhotoManager* sharedInstance;

/* Initialize shared instance with initialize, called once per class */
+(void)initialize
{
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        sharedInstance = [[HSPhotoManager alloc] init];
    }
    
}

+(id)sharedInstance {
    return sharedInstance;
}

/* Not used
-(BOOL)photoIsInStore:(NSURL *)photoURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //Hash of photoURL is uniqueIdentifier for photo
    NSUInteger hash= [photoURL hash];
    NSURL *path = [self.photosStorageURL URLByAppendingPathComponent:
                   [NSString stringWithFormat:@"%u",hash]];
    return [fileManager isReadableFileAtPath:[path path]];
}
 */

-(NSURL*)photosStorageURL
{
    if (!_photosStorageURL) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //Get URL for our cache directory
        NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL* picturesURL = urls[0];
        NSURL* playerPhotosURL = [picturesURL URLByAppendingPathComponent:PLAYER_PHOTOS_DIRECTORY isDirectory:YES];
        //NSURL* playerPhotosURL = picturesURL;
        
        // If directory doesn't exist, create it!
        if (![fileManager fileExistsAtPath:[playerPhotosURL absoluteString] isDirectory:NULL]) {
            NSError *error = [[NSError alloc] init];
            [fileManager createDirectoryAtURL:playerPhotosURL withIntermediateDirectories:NO attributes:nil error:&error];
        }
        _photosStorageURL = playerPhotosURL; //Only 1 url in iOS
    }
    return _photosStorageURL;
}

-(NSData*)dataForPhotoInStorageForPlayer:(Player*)player
{
    //Hash of photoURL is uniqueIdentifier for photo
    NSUInteger hash= [player.objectID.URIRepresentation hash];
    NSURL *URLForPhoto = [self.photosStorageURL URLByAppendingPathComponent:
                              [NSString stringWithFormat:@"%u",hash]];
    NSData* data = [NSData dataWithContentsOfURL:URLForPhoto];
    return data;
}

-(BOOL)putPhotoDataInCache:(NSData *)imageData ForPlayer:(Player*)player;
{
    NSUInteger hash= [player.objectID.URIRepresentation hash];
    NSURL *URLForPhoto = [self.photosStorageURL URLByAppendingPathComponent:
                              [NSString stringWithFormat:@"%u",hash]];
    NSError *error = [[NSError alloc] init];
    return [imageData writeToURL:URLForPhoto options:NSDataWritingAtomic error:&error];
}



@end
