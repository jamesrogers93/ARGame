//
//  ARMarkerTracker.h
//  ARGame
//
//  Created by James Rogers on 21/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

#ifndef ARHandler_h
#define ARHandler_h

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
//#import <QuartzCore/QuartzCore.h>
#import <AR/ar.h>
#import <AR/video.h>
#import <AR/gsub_es.h>
#import <AR/sys/CameraVideo.h>

@interface ARHandler: NSObject <CameraVideoTookPictureDelegate>
{}

- (void) onViewLoad;
- (void) start;
- (void) startRunLoop;
- (void) stopRunLoop;
- (void) processFrame:(AR2VideoBufferT *)buffer;

@property (readonly) GLKMatrix4 camProjection;
@property (readonly) NSData*   camBuffer;
@property (readonly) GLuint   camBufferTexture;

@property (nonatomic, getter=isPaused) BOOL paused;

@end

#endif /* ARMarkerTracker_h */
