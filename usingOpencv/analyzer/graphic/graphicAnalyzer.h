//
//  graphicAnalyzer.h
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//


#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "opencv2/videoio/cap_ios.h"
#import "internalFunctions.hpp"
#import "entropy.hpp"

#ifndef basicConstants_hpp
#import "basicConstants.hpp"
#endif

#endif //__cplusplus endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 하는 일 : 이미지 단순화, 이미지 단순도 추출, 단순화된 이미지 추출
 특징 
 : processing 함수와 getter 함수가 불리되어 있음.
 : colorAnayzer interface와 묶이기 위해 상위 analyzer interface에서 호출되어서 인스턴스를 만듦
 : 실제 프로세싱 작업이 이루어지는 곳.
 */

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "opencv2/videoio/cap_ios.h"
#import "internalFunctions.hpp"
#import "entropy.hpp"

#ifndef basicConstants_hpp
#import "basicConstants.hpp"
#endif

#endif //__cplusplus endif

#define GRAHPICINFO
@interface graphicAnalyzer : NSObject
#ifdef __cplusplus
{
    cv::Mat old;
    
    cv::Mat diffMat;
    cv::Mat simplified;
    
    int simplicity;
    double difference;
}
-(id) init;
//processing Matrix functions
- (cv::Mat)simplify : (cv::Mat)frame;
- (cv::Mat)diffNextFrame : (cv::Mat)src1 withBinary:(bool)binaryOpt;

//processed Matrix getter
- (cv::Mat)getSimplifiedMat;
- (cv::Mat)getDiffMat;

//computation for value from processed Matrix
- (int)computeEntropy : (cv::Mat)simplifiedMat;
- (int)computeDifference : (cv::Mat)diffMat withBinary:(bool)birnayrOpt;
- (int)computeSimplicity : (cv::Mat)simplifiedMat;
#endif
- (UIImage*)getSimplified;
- (UIImage*)getDiff;

- (NSNumber*)getSimplicity;
- (NSNumber*)getDifference;

@end
