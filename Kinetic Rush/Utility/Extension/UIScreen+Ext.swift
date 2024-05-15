//
//  UIScreen+Ext.swift
//  Kinetic Rush
//
//  Created by Wahid Hidayat on 27/04/24.
//

import UIKit

extension UIScreen{
    private static let window = UIApplication.shared.windows.first
    private static let safeFrame = UIScreen.window?.safeAreaLayoutGuide.layoutFrame
    static let screenHeight = UIScreen.main.bounds.height + 60
    static let screenWidth = UIScreen.main.bounds.width
    static let screenSize = UIScreen.main.bounds.size
}
