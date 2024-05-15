//
//  CGPoint+Ext.swift
//  Kinetic Rush
//
//  Created by Wahid Hidayat on 24/04/24.
//

import Foundation

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
