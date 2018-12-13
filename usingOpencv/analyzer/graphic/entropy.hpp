//
//  entropy.hpp
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

#ifndef checkEntropy_hpp
#define checkEntropy_hpp

#include <stdio.h>
#include <opencv2/opencv.hpp>

float getEntropy(cv::Mat seqHist, cv::Size srcSize, int histSize);
cv::Mat serialize(cv::Mat src, int histSize);

#endif /* checkEntropy_hpp */
