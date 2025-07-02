//
//  Icons.swift
//  
//
//  Created by Gustavo Adolfo Villada Molina on 15/06/25.
//

import Foundation
import SwiftUI

public enum Icons: String, CaseIterable {
    case playFill = "play.circle.fill"
    case pauseFill = "pause.circle.fill"
    case forwardFill = "forward.fill"
    case backwardFill = "backward.fill"
    case search = "magnifyingglass"
    case chevronRigth = "chevron.right"
    case chevronLeft = "chevron.left"
    case personCropCircle = "person.crop.circle"
    
    public var image: Image {
        Image(systemName: self.rawValue)
    }
}
