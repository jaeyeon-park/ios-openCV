//
//  captuerer.h
//  usingOpencv
//
//  Created by keun-jaeyeon on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//
#ifndef captuerer_h
#define captuerer_h
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "opencv2/videoio/cap_ios.h"
#endif

#import <Foundation/Foundation.h>
@interface capturer : NSObject
#ifdef __cplusplus
{
    cv::Mat* srcPointer;
}
-(id)init:(cv::Mat*)bufferPointer;
-(cv::Mat)getThisTimeCVMatBuffer;
#endif

@end
#endif /* captuerer_h */
