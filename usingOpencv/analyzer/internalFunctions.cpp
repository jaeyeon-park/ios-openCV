//
//  internalFunctions.cpp
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

#include "internalFunctions.hpp"

float findMin(float* rgb,int channelNum){
    float min = rgb[0];
    for(int channel = 0 ; channel<channelNum;channel++){
        if(min>rgb[channel]){
            min = rgb[channel];
        }
    }
    return min;
}

float findMax(float* rgb, int channelNum){
    float max = rgb[0];
    for(int channel = 0; channel < channelNum;channel++){
        if(max<rgb[channel]){
            max = rgb[channel];
        }
    }
    return max;
}
