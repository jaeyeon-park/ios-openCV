//
//  cameraMedia.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//


import Foundation
import AVFoundation

class cameraMedia:NSObject,hasFrameBuffer,makeVideo,AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var captureSession  : AVCaptureSession!            //입력 - 출력 연결 세션
    private var previewLayer    : AVCaptureVideoPreviewLayer?  //영상 자체를 보여주는 프리뷰레이어
    private var videoOutlet       : AVCaptureVideoDataOutput!  //분석프로세스로 넘길 픽셀버퍼 가져오는 컨테이너
    private var Q               : DispatchQueue!               //captureOutput 콜백이 쌓일 Q
    private let cameraFPS       : Int32 = 30                   //카메라 인풋 영상 FPS
    private var device          : AVCaptureDevice!             //카메라 디바이스 정보를 담은 컨테이너
    private var pixelBuffer : CVPixelBuffer? = nil
    var delegateMedia : mediaDelegate?
    private var frameCount : Int32 = 0
    override init(){
        super.init()
        Q = DispatchQueue(label: "outLetFrame")

        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480
        videoOutlet = AVCaptureVideoDataOutput()
        videoOutlet.setSampleBufferDelegate(self, queue: Q)
        videoOutlet.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String) : NSNumber(value:kCVPixelFormatType_32BGRA as UInt32)]
    }

    func extractFrameBuffer(param: Any) -> CVPixelBuffer? {
        if self.pixelBuffer != nil {
            return self.pixelBuffer
        }else{
            return nil
        }
    }
    
    //makeVideo protocol
    func attachSrc(from: Any) {
        device =  AVCaptureDevice.default(for: .video)
        do{
            //session에 입력단자(카메라 하드웨어) 연결
            let input = try AVCaptureDeviceInput(device: device)
            if(captureSession.canAddInput(input)){
                captureSession.addInput(input)
                
                // 카메라 fps 설정에 관해서 :
                // http://stackoverflow.com/questions/34718833/ios-swift-avcapturesession-capture-frames-respecting-frame-rate
                do{
                    try device.lockForConfiguration()
                    //print(device.activeFormat.formatDescription)
                    //print(device.activeFormat.videoSupportedFrameRateRanges)
                    device.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: self.cameraFPS)//CMTime(seconds: 1, preferredTimescale: 10)
                    device.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: self.cameraFPS)//CMTime(seconds: 1, preferredTimescale: 10)
                    device.unlockForConfiguration()
                }catch{
                    print("error lock for configuration")
                }
                
                //session에 출력단자(분석객체에게 픽셀정보를 넘길 컨테이너) 연결
                if(captureSession.canAddOutput(videoOutlet)){
                    captureSession.addOutput(videoOutlet)
                    
                    //session에 출력단자(previewLayer) 연결
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                    print("debug : cameraProcess.swift/attachSource to Session")
                }
            }
        }
        catch{
            print("error")
        }
    }
    func play(on:UIImageView) {
        previewLayer?.frame = on.bounds
        previewLayer?.position = CGPoint(x: on.frame.width/2, y: on.frame.height/2)
        on.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()

        delegateMedia?.willStartVideoProcessing(with: self)
        delayWithSeconds(1, completion: {
            if(self.pixelBuffer != nil){
                self.delegateMedia?.notifyVideoFlowStart()
                //thumbnailStorage.insertInSharedInstance(img: self.pixelBuffer!) // make thumbnail once at starting point
            }
        })
    }
    func stop() {
        if(captureSession.isRunning){
            if(previewLayer?.superlayer != nil){
                previewLayer?.removeFromSuperlayer()
            }
            if let input:AVCaptureInput = captureSession.inputs[0]{
                captureSession.removeInput(input)
                captureSession.removeOutput(videoOutlet)
                captureSession.stopRunning()
                delegateMedia?.notifyVideoFlowEnd()
                delegateMedia?.didEndVideoProcessing()
            }
        }
    }
    /*func snapThumbnail(){
        if self.pixelBuffer != nil {
            thumbnailStorage.insertInSharedInstance(img: self.pixelBuffer!) // make thumbnail when user wants to make his(or her) sight as thumbnail
        }
    }*/
    //AVCaptureVideoDataOutputSampleBufferDelegate function
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if(CMSampleBufferDataIsReady(sampleBuffer)){
             //픽셀버퍼에 새로운 카메라 버퍼를 업데이트
            self.pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        }
    }

}
