//
//  colorPalette.cpp
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

#include "colorPalette.hpp"

void reduceColor_Quantization(const cv::Mat3b& src, cv::Mat3b& dst)
{
    uchar N = 64;
    dst = src / N;
    dst *= N;
}
// https://stackoverflow.com/a/34734939/5008845
// https://stackoverflow.com/questions/35479344/how-to-get-color-palette-from-image-using-opencv
void reduceColor_kmeans(const cv::Mat3b& src, cv::Mat3b& dst, int colorCount)
{
    int K = colorCount; //Extract 6 color
    int n = src.rows * src.cols;
    cv::Mat data = src.reshape(1, n);
    data.convertTo(data, CV_32F);
    
    std::vector<int> labels;
    cv::Mat1f colors;
    cv::kmeans(data, K, labels, cv::TermCriteria(), cConst::kmeansLevel, cv::KMEANS_PP_CENTERS, colors);
    
    for (int i = 0; i < n; ++i)
    {
        data.at<float>(i, 0) = colors(labels[i], 0);
        data.at<float>(i, 1) = colors(labels[i], 1);
        data.at<float>(i, 2) = colors(labels[i], 2);
    }
    
    cv::Mat reduced = data.reshape(3, src.rows);
    reduced.convertTo(dst, CV_8U);
}

void reduceColor_Stylization(const cv::Mat3b& src, cv::Mat3b& dst)
{
    stylization(src, dst);
}

void reduceColor_EdgePreserving(const cv::Mat3b& src, cv::Mat3b& dst)
{
    edgePreservingFilter(src, dst);
}


std::map<cv::Vec3b, int, lessVec3b> getPalette(const cv::Mat3b& src)
{
    std::map<cv::Vec3b, int, lessVec3b> palette;
    for (int r = 0; r < src.rows; ++r)
    {
        for (int c = 0; c < src.cols; ++c)
        {
            cv::Vec3b color = src(r, c);
            if (palette.count(color) == 0)
            {
                palette[color] = 1;
            }
            else
            {
                palette[color] = palette[color] + 1;
            }
        }
    }
    return palette;
}
