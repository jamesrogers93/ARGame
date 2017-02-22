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
//#import <QuartzCore/QuartzCore.h>
#import <AR/ar.h>
#import <AR/video.h>
//#import <AR/gsub_es.h>
#import <AR/sys/CameraVideo.h>

@interface ARHandler: NSObject <CameraVideoTookPictureDelegate>
{}

- (void) onViewLoad;
- (void) start;
- (void) startVideoCapture;
- (void) endVideoCapture;
- (void) processFrame:(AR2VideoBufferT *)buffer;



@end

#endif /* ARMarkerTracker_h */
