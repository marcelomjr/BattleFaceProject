//
//  AppDelegate.swift
//  JoyCamera
//
//  Created by Clara Carneiro on 7/28/17.
//  Copyright (c) 2017 Joy. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    @IBOutlet var cameraView: UIView!
    @IBOutlet var pickedImageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var flashButton: UIButton!
    @IBOutlet var captureButton: UIButton!
    
    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var stillImageOutput = AVCaptureStillImageOutput()
    var frontCamera: Bool = false
    var didtakePhoto = Bool()
    var flashEnable: Bool = false

    var takenPhoto: UIImage?
    
    var battleWasBuilt:Bool = false
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        if self.battleWasBuilt
        {
            self.dismiss(animated: true, completion: {})
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        frontCamera(frontCamera)
        
        if captureDevice != nil
        {
            beginSession()
        }
    }
    

    
    func beginSession()
    {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.cameraView.layer.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureSession.startRunning()
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {captureSession.addOutput((stillImageOutput))}
    }

 
    func frontCamera(_ front: Bool){
        var icon = UIImage()
        let devices = AVCaptureDevice.devices()

        do {try captureSession.removeInput(AVCaptureDeviceInput(device: captureDevice))} catch { print ("error while looking for devices")}

        for device in devices!{
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)){
                if front {
                    if (device as AnyObject).position == AVCaptureDevicePosition.front {
                        icon = #imageLiteral(resourceName: "CameraFrontal") as UIImage
                        cameraButton.setBackgroundImage(icon, for: UIControlState.normal)
                        captureDevice = device as? AVCaptureDevice
                        do {try captureSession.addInput(AVCaptureDeviceInput(device:captureDevice))} catch { print ("error while setting camera position")}
                        break }}
                else {
                    if (device as AnyObject).position == AVCaptureDevicePosition.back {
                        icon = #imageLiteral(resourceName: "CameraTraseira") as UIImage
                        cameraButton.setBackgroundImage(icon, for: UIControlState.normal)
                        captureDevice = device as? AVCaptureDevice
                        do {try captureSession.addInput(AVCaptureDeviceInput(device:captureDevice))} catch { print ("error while setting camera position")}
                        break }}}}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    
    @IBAction func toggleFlash(_ sender: Any)
    {
        if self.flashEnable
        {
            self.flashEnable = false
            let inactiveImage = #imageLiteral(resourceName: "Flash") as UIImage
            self.flashButton.setBackgroundImage(inactiveImage, for: UIControlState.normal)
            self.flashOff()
        }
        // Flash is off
        else
        {
            self.flashEnable = true
            let activeImage = #imageLiteral(resourceName: "FlashSelected") as UIImage
            self.flashButton.setBackgroundImage(activeImage, for: UIControlState.normal)
            flashOn()
        }
    }
    func flashOff()
    {
        guard self.captureDevice!.hasTorch == true else
        {
            print("Erro>>>Explicar erro aqui")
            return
        }
        
        do
        {
            try captureDevice!.lockForConfiguration()
            captureDevice!.flashMode = .off
            captureDevice!.unlockForConfiguration()
        }
        catch
        {
            print ("error while trying to activate flash")
        }
    }
    func flashOn()
    {
        guard self.captureDevice!.hasTorch == true else
        {
            print("Erro>>>Explicar erro aqui")
            return
        }
        
        do
        {
            try captureDevice!.lockForConfiguration()
            captureDevice!.flashMode = .on
            captureDevice!.unlockForConfiguration()
        }
        catch
        {
            print ("error while trying to activate flash")
        }
    }
    

    @IBAction func setCamera(_ sender: UIButton) {
        //switch camera to frontal
        frontCamera = !frontCamera
        captureSession.beginConfiguration()
        let inputs = captureSession.inputs as! [AVCaptureInput]
        for oldInput: AVCaptureInput in inputs {captureSession.removeInput(oldInput)}

        frontCamera(frontCamera)
        captureSession.commitConfiguration()
    }


    
    
    @IBAction func startCapture(_ sender: UIButton)
    {
        captureAnotherPicture()
    }

    func capturePicture() {
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataSampleBuffer, error) in
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                
                // save the photo in self.takenPhoto
                self.takenPhoto = UIImage(data: imageData!)

                                
                    self.pickedImageView.image = self.takenPhoto
                    self.pickedImageView.isHidden = false

                    self.flashButton.isHidden = true
                    self.cameraButton.isHidden = true
                    self.flashButton.isEnabled = false
                    self.cameraButton.isEnabled = false
                
                    self.performSegue(withIdentifier: "CameraToPhotoDestination", sender: nil)
            })
        }
    }

    func captureAnotherPicture()
    {
        if didtakePhoto == true
        {
            //self.previewPicture.pickedImage.isHidden = true
            self.pickedImageView.isHidden = true

            self.flashButton.isHidden = false
            self.cameraButton.isHidden = false
            self.flashButton.isEnabled = true
            self.cameraButton.isEnabled = true

            didtakePhoto = false
        }
        else
        {
            captureSession.startRunning()
            didtakePhoto = true
            capturePicture()
        }

    }


    @IBAction func CancelCaptureSession(_ sender: Any) {
        performSegue(withIdentifier: "CameraToTabBarController", sender: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "CameraToPhotoDestination"
        {
            let photoDestinationViewController = segue.destination as? PhotoDestinationViewController
            
            guard photoDestinationViewController != nil else
            {
                print("Error fetching PhotoDestinationViewController!")
                return
            }
            guard self.takenPhoto != nil else
            {
                print("Error fetching photo!")
                return
            }
            photoDestinationViewController!.takenPhoto = self.takenPhoto
        }
    }

}
