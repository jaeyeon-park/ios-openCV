//
//  movieMedia.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class movieMedia:NSObject,hasFrameBuffer,makeVideo,AVPlayerItemOutputPullDelegate{
    private var avPlayer : AVPlayer?
    private var previewLayer : AVPlayerLayer?
    private var videoOutlet : AVPlayerItemVideoOutput!
    private var Q : DispatchQueue!
    var delegateMedia : mediaDelegate?
    override init(){
        super.init()
        let pixelBufferDict: [String:Any] = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA];
        videoOutlet = AVPlayerItemVideoOutput(pixelBufferAttributes: pixelBufferDict);
        Q = DispatchQueue(label:"outLetFrame");
        videoOutlet.setDelegate(self, queue: Q);
    
        NotificationCenter.default.addObserver(self, selector: #selector(attachVideoProcess), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.avPlayer?.currentItem);
    }
    //AVPlayerItemOutputPullDelegate
    func outputMediaDataWillChange(_ sender: AVPlayerItemOutput){
        print("debug : outputMediaWillChange");
    }
    func outputSequenceWasFlushed(_ output: AVPlayerItemOutput){
        print("debug : new file");
        delegateMedia?.notifyVideoFlowStart()
    }
    //makeVideo protocol
    func attachSrc(from: Any) {
        if let file = from as? NSURL{
            avPlayer = AVPlayer(url: file as URL)
        }                                                           //player에 입력단자(전달받은 영상소스의 URL) 연결
        avPlayer?.currentItem?.add(videoOutlet);                    //player에 출력단자(분석객체로 넘길 픽셀정보를 추출하는 컨테이너) 연결
        avPlayer?.isMuted = true;                                   //동영상 내장 소리 음소거
        previewLayer = AVPlayerLayer(player: avPlayer);             //player의 표시 화면 layer를 추출
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill;
    }
    func play(on : UIImageView) {
        previewLayer?.frame = on.bounds
        on.layer.addSublayer(previewLayer!) //화면 표시할 영역에 player layer를 추가
        
        avPlayer?.play()
        delegateMedia?.willStartVideoProcessing(with: self)
    }
    
    func stop() {
        if avPlayer != nil{
            avPlayer?.pause()
        }
        if previewLayer?.superlayer != nil{
            previewLayer?.removeFromSuperlayer()
        }
        
        delegateMedia?.notifyVideoFlowEnd()
        delegateMedia?.didEndVideoProcessing()
    }
    //hasFrameBuffer Delegate
    func extractFrameBuffer(param:Any) -> CVPixelBuffer? {
        var outputItemTime : CMTime = CMTime.invalid;
        var frameBuffer : CVPixelBuffer? = nil
        if let sender : CADisplayLink = param as? CADisplayLink{
            let nextSync : CFTimeInterval = sender.timestamp + sender.duration;
            outputItemTime = self.videoOutlet.itemTime(forHostTime: nextSync);
            if(self.videoOutlet.hasNewPixelBuffer(forItemTime: outputItemTime)){
               frameBuffer = self.videoOutlet.copyPixelBuffer(forItemTime: outputItemTime, itemTimeForDisplay: nil);
            }
        }
        return frameBuffer
    }
    //notification function
    @objc func attachVideoProcess(note : NSNotification){
        print("videoEnd")
        delegateMedia?.notifyVideoFlowEnd()
        delegateMedia?.didEndVideoProcessing()
    }
}
