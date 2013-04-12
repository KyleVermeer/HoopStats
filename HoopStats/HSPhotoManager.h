//
//  HSPhotoManager.h
//  HoopStats
//
//  Created by Kyle Vermeer on 3/16/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface HSPhotoManager : NSObject

+(id)sharedInstance;

-(NSData*)dataForPhotoInStorageForPlayer:(Player*)player;
-(BOOL)putPhotoDataInCache:(NSData *)imageData ForPlayer:(Player*)player;

@end
