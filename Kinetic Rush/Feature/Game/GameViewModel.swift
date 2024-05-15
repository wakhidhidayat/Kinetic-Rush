//
//  GameViewModel.swift
//  Kinetic Rush
//
//  Created by Wahid Hidayat on 24/04/24.
//

import UIKit
import AVFoundation
import Vision
import Combine

enum BugType: String, CaseIterable {
    case pink = "bug_pink"
    case purple = "bug_purple"
    case green = "bug_green"
}

class GameViewModel: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    private let sequenceHandler = VNSequenceRequestHandler()
    @Published var bodyParts = [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]()
    @Published var score = 0
    @Published var objectFrame = CGRect(x: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50), y: CGFloat.random(in: 100...UIScreen.main.bounds.height - 250), width: 80, height: 80)
    @Published var object = BugType.allCases.randomElement()
    @Published var isGoodPosture = false
    @Published var leftWristPosition: CGPoint = .zero
    @Published var rightWristPosition: CGPoint = .zero
    @Published var leftKneePosition: CGPoint = .zero
    @Published var rightKneePosition: CGPoint = .zero
    @Published var leftAnklePosition: CGPoint = .zero
    @Published var rightAnklePosition: CGPoint = .zero
    
    private var subscriptions = Set<AnyCancellable>()
    
    override init() {
        super.init()
        $bodyParts
            .dropFirst()
            .sink(receiveValue: { bodyParts in self.checkIfObjectTouched(bodyParts: bodyParts)})
            .store(in: &subscriptions)
        
        generateObject()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let humanBodyRequest = VNDetectHumanBodyPoseRequest(completionHandler: detectedBodyPose)
        do {
            try sequenceHandler.perform(
                [humanBodyRequest],
                on: sampleBuffer,
                orientation: .right)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func detectedBodyPose(request: VNRequest, error: Error?) {
        guard let bodyPoseResults = request.results as? [VNHumanBodyPoseObservation]
        else { return }
        guard let bodyParts = try? bodyPoseResults.first?.recognizedPoints(.all) else { return }
        DispatchQueue.main.async {
            self.bodyParts = bodyParts
        }
    }
    
    func checkIfObjectTouched(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
        let rightKnee = bodyParts[.rightKnee]!.location
        let leftKnee = bodyParts[.leftKnee]!.location
        let rightAnkle = bodyParts[.rightAnkle]!.location
        let leftAnkle = bodyParts[.leftAnkle]!.location
        let leftWrist = bodyParts[.leftWrist]!.location
        let rightWrist = bodyParts[.rightWrist]!.location
        let rightHip = bodyParts[.rightHip]!.location
        
        // Convert to UIKit frame coordinates
        let leftWristPoint = convertToUIKitCoordinate(from: leftWrist)
        let rightWristPoint = convertToUIKitCoordinate(from: rightWrist)
        let leftAnklePoint = convertToUIKitCoordinate(from: leftAnkle)
        let rightAnklePoint = convertToUIKitCoordinate(from: rightAnkle)
        let leftKneePoint = convertToUIKitCoordinate(from: leftKnee)
        let rightKneePoint = convertToUIKitCoordinate(from: rightKnee)
        
        // check posture
        let firstAngle = atan2(rightHip.y - rightKnee.y, rightHip.x - rightKnee.x)
        let secondAngle = atan2(rightAnkle.y - rightKnee.y, rightAnkle.x - rightKnee.x)
        var angleDiffRadians = firstAngle - secondAngle
        while angleDiffRadians < 0 {
                    angleDiffRadians += CGFloat(2 * Double.pi)
                }
        
        let hipHeight = rightHip.y
        let kneeHeight = rightKnee.y
        
        let kneeDistance = rightKnee.distance(to: leftKnee)
        let ankleDistance = rightAnkle.distance(to: leftAnkle)
        
        if ankleDistance < kneeDistance && hipHeight > kneeHeight {
            self.isGoodPosture = true
            if AudioHelper.backsound == nil {
                AudioHelper.playBacksound()
            }
        }
        
        leftWristPosition = leftWristPoint
        rightWristPosition = rightWristPoint
        leftKneePosition = leftKneePoint
        rightKneePosition = rightKneePoint
        leftAnklePosition = leftAnklePoint
        rightAnklePosition = rightAnklePoint
        
        let intersectionLeftWrist = objectFrame.intersection(CGRect(x: leftWristPoint.x, y: leftWristPoint.y, width: 120, height: 120))
        let intersectionRightWrist = objectFrame.intersection(CGRect(x: rightWristPoint.x, y: rightWristPoint.y, width: 120, height: 120))
        let intersectionLeftAnkle = objectFrame.intersection(CGRect(x: leftAnklePoint.x, y: leftAnklePoint.y, width: 120, height: 120))
        let intersectionRightAnkle = objectFrame.intersection(CGRect(x: rightAnklePoint.x, y: rightAnklePoint.y, width: 120, height: 120))
        let intersectionLeftKnee = objectFrame.intersection(CGRect(x: leftKneePoint.x, y: leftKneePoint.y, width: 120, height: 120))
        let intersectionRightKnee = objectFrame.intersection(CGRect(x: rightKneePoint.x, y: rightKneePoint.y, width: 120, height: 120))
        
        guard let object else { return }
        
        switch object {
        case .green:
            if intersectionLeftAnkle.isEmpty == false || intersectionRightAnkle.isEmpty == false {
                generateObject()
                score += 1
                AudioHelper.playSfx()
            }
        case .purple:
            if intersectionLeftWrist.isEmpty == false || intersectionRightWrist.isEmpty == false {
                generateObject()
                score += 1
                AudioHelper.playSfx()
            }
        case .pink:
            if intersectionRightKnee.isEmpty == false || intersectionLeftKnee.isEmpty == false {
                generateObject()
                score += 1
                AudioHelper.playSfx()
            }
        }
    }
    
    func generateObject() {
        let newObject = BugType.allCases.randomElement()
        
        var objectYPosition: CGFloat = 0
        
        let window = UIApplication.shared.windows.first
        let safeFrame = window?.safeAreaLayoutGuide.layoutFrame
        let screenHeight = safeFrame?.height
        
        guard let newObject, let screenHeight else { return }
        switch newObject {
        case .green:
            objectYPosition = CGFloat.random(in: screenHeight / 2 + 50...screenHeight - screenHeight * 40/100)
        case .purple:
            objectYPosition = CGFloat.random(in: 50...screenHeight - screenHeight * 80/100)
        case .pink:
            objectYPosition = screenHeight / 2
        }
        
        objectFrame = CGRect(x: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50), y: objectYPosition, width: 80, height: 80)
        object = newObject
    }
    
    func convertToUIKitCoordinate(from visionCoordinate: CGPoint) -> CGPoint {
        let x = (1 - visionCoordinate.x) * UIScreen.main.bounds.size.width
        let y = (1 - visionCoordinate.y) * UIScreen.main.bounds.size.height - 60
        return CGPoint(x: x, y: y)
    }
}

