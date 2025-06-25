//
//  BottomTabItemProtocol.swift
//  
//
//  Created by Gustavo Adolfo Villada Molina on 25/06/25.
//

import Foundation
import SwiftUI

public protocol BottomTabItemProtocol: Hashable & CaseIterable {
    var label: String { get }
    var icon: String { get }
    var view: AnyView { get }
}
