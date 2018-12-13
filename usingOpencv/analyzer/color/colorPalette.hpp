//
//  colorPalette.hpp
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

#ifndef colorPalette_hpp
#define colorPalette_hpp

#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <map>
#include "basicConstants.hpp"

struct lessVec3b
{
    bool operator()(const cv::Vec3b& lhs, const cv::Vec3b& rhs) const {
        return (lhs[0] != rhs[0]) ? (lhs[0] < rhs[0]) : ((lhs[1] != rhs[1]) ? (lhs[1] < rhs[1]) : (lhs[2] < rhs[2]));
    }
};
void reduceColor_Quantization(const cv::Mat3b& src, cv::Mat3b& dst);
void reduceColor_kmeans(const cv::Mat3b& src, cv::Mat3b& dst, int colorCount);
void reduceColor_Stylization(const cv::Mat3b& src, cv::Mat3b& dst);
void reduceColor_EdgePreserving(const cv::Mat3b& src, cv::Mat3b& dst);
std::map<cv::Vec3b, int, lessVec3b> getPalette(const cv::Mat3b& src);

#endif /* colorPalette_hpp */
