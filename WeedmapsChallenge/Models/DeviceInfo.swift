//
//  DeviceInfo.swift
//  WeedmapsChallenge
//
//  Created by Sako Hovaguimian on 3/20/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//
import UIKit

struct DeviceInfo {
struct Orientation {
    // indicate current device is in the LandScape orientation
    static var isLandscape: Bool {
        get {
            return UIDevice.current.orientation.isValidInterfaceOrientation
                ? UIDevice.current.orientation.isLandscape
                : UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
    // indicate current device is in the Portrait orientation
    static var isPortrait: Bool {
        get {
            return UIDevice.current.orientation.isValidInterfaceOrientation
                ? UIDevice.current.orientation.isPortrait
                : UIApplication.shared.statusBarOrientation.isPortrait
        }
    }
}}
