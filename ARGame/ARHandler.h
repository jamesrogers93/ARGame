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
#import <QuartzCore/QuartzCore.h>
#include <AR/ar.h>
#include <AR/video.h>
#include <AR/gsub_es2.h>
#import <AR/sys/CameraVideo.h>

@interface ARHandler: NSObject <CameraVideoTookPictureDelegate>
{}

- (void) onViewLoad;
- (void) start;
- (void) draw;
- (void) processFrame:(AR2VideoBufferT *)buffer;

@property (readonly) ARGL_CONTEXT_SETTINGS_REF arglContextSettings;

@property (readonly, nonatomic, getter=isRunning) BOOL running;
@property (nonatomic, getter=isPaused) BOOL paused;

@property (readonly) GLKMatrix4 camProjection;

@end

#endif /* ARMarkerTracker_h */
