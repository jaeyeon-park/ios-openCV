//
//  entropy.cpp
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//


#include "entropy.hpp"

float getEntropy(cv::Mat seqHist, cv::Size srcSize, int histSize){
    float entropy = 0;
    float totalPixelSize = srcSize.height*srcSize.width;
   
    for(int i=0;i<histSize;i++)
    {
        float sym_occur = seqHist.at<float>(0, i); //the number of times a sybmol has occured
        
        if(sym_occur>0) //log of zero goes to infinity
        {
            entropy += (sym_occur/totalPixelSize)*(log2f(totalPixelSize/sym_occur));
        }
    }
    return entropy;
}
cv::Mat serialize(cv::Mat src, int histSize){
    float range[] = { 0, 256 } ;
    const float* histRange = { range };
    
    bool uniform = true;
    bool accumulate = false;
    
    cv::Mat hist;
    
    /// Compute the histograms:
    calcHist( &src, 1, 0, cv::Mat(), hist, 1, &histSize, &histRange, uniform, accumulate );
    
    return hist;
    
}
