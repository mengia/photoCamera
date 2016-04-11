//
//  ViewController.swift
//  PhotoCamera
//
//  Created by Mengistayehu Mamo on 3/19/16.
//  Copyright © 2016 Mengistayehu Mamo. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    @IBOutlet weak var photoCameraButton: UIButton!
    
    let captureSession = AVCaptureSession()
    
    var frontFacingCamera : AVCaptureDevice?
    var backFacingCamera : AVCaptureDevice?
    var currectDevice : AVCaptureDevice?
    
    var imageStillOutPut: AVCaptureStillImageOutput?
    var stillImage : UIImage?
    
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    
    var toggledCameraRecognizer = UISwipeGestureRecognizer()
    var zoomInGestureRegognizer = UISwipeGestureRecognizer()
    var zoomOutGestrurRecognizer = UISwipeGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCameraButton.layer.cornerRadius = 40.0
        toggledCameraRecognizer.direction = .Up
        toggledCameraRecognizer.addTarget(self, action: "toggleCamera")
        view.addGestureRecognizer(toggledCameraRecognizer)
        
        zoomInGestureRegognizer.direction = .Right
        zoomInGestureRegognizer.addTarget(self, action: "zoomIn")
        view.addGestureRecognizer(zoomInGestureRegognizer)
        
        zoomOutGestrurRecognizer.direction = .Left
        zoomOutGestrurRecognizer.addTarget(self, action: "zoomOut")
        view.addGestureRecognizer(zoomOutGestrurRecognizer)
        
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in devices{
            if device.position == AVCaptureDevicePosition.Back{
                backFacingCamera = device
                
            }else{
                if device.position == AVCaptureDevicePosition.Front{
                    frontFacingCamera = device
                }
            }
            currectDevice = frontFacingCamera
        }
        do{
            let capturedeviceInPut = try AVCaptureDeviceInput(device: currectDevice)
            imageStillOutPut = AVCaptureStillImageOutput()
            imageStillOutPut?.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            captureSession.addOutput(imageStillOutPut)
            captureSession.addInput(capturedeviceInPut)
            
        } catch{
            print(error)
        }
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer .addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer!.frame = view.layer.frame
        view.bringSubviewToFront(photoCameraButton)
        captureSession.startRunning()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToCamera(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func capture(sender: AnyObject) {
        
        let videoConnection = imageStillOutPut?.connectionWithMediaType(AVMediaTypeVideo)
        imageStillOutPut?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (imageDataSampleBuffer, error) -> Void in
            
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
            self.stillImage = UIImage(data: imageData)
            self.performSegueWithIdentifier("showPhoto", sender: self)
            
        })
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPhoto"
        {
            let photoViewController = segue.destinationViewController as! PhotoViewController
            photoViewController.image = stillImage
        }
        
    }
    func toggleCamera(){
        captureSession.beginConfiguration()
        let newDevice = (currectDevice?.position == AVCaptureDevicePosition.Back) ?
            frontFacingCamera : backFacingCamera
        
        for input in captureSession.inputs{
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        let cameraInput : AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice)
        } catch{
            print(error)
            return
        }
        if captureSession.canAddInput(cameraInput){
            captureSession.addInput(cameraInput)
        }
        currectDevice = newDevice
        captureSession.commitConfiguration()
    }
 
    func zoomIn(){
        
        if let zoomFactor = currectDevice?.videoZoomFactor{
            if zoomFactor < 5{
                let newZoomFactor = min(zoomFactor + 1.0, 5.0)
                
                do {
                    try currectDevice?.lockForConfiguration()
                    currectDevice?.rampToVideoZoomFactor(newZoomFactor, withRate: 1.0)
                    currectDevice?.unlockForConfiguration()
                }catch{
                    print(error)
                }
            }
        }
    }
    func zoomOut(){
        if let zoomFactor = currectDevice?.videoZoomFactor{
            if zoomFactor > 1.0{
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                
                do{
                    try currectDevice?.lockForConfiguration()
                    currectDevice?.rampToVideoZoomFactor(newZoomFactor, withRate: 1.0)
                    currectDevice?.unlockForConfiguration()
                } catch{
                    print(error)
                }
            }
        }
    }
}
