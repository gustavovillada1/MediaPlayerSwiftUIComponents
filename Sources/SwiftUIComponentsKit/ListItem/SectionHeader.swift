//
//  SectionHeader.swift
//
//
//  Created by Gustavo Adolfo Villada Molina on 25/06/25.
//

import SwiftUI

public struct SectionHeader: View {
    let title: String
    var iconName: String? = nil
    var subtitle: String? = nil
    var action: (() -> Void)? = nil
    var colorScheme: ColorScheme = .dark
    
    public init(
        title: String
    ) {
        self.title = title
    }
    
    public var body: some View {
        HStack {
            Text(title)
                .font(.title)
                .bold()
                .preferredColorScheme(colorScheme)
            Spacer()
            if let subtitleUnwrapped: String = subtitle {
                HStack {
                    Button(
                        subtitleUnwrapped,
                        systemImage: iconName!,
                        action: action!
                    )
                    .preferredColorScheme(colorScheme)
                }
            }
        }
    }
    
    // MARK: Modifiers
    public func addRightAction(
        iconName: String? = "chevron.right", 
        subtitle: String,
        action: @escaping () -> Void = {}
    ) -> SectionHeader {
        var copy: SectionHeader = self
        copy.iconName = iconName
        copy.subtitle = subtitle
        copy.action = action
        return copy
    }
    
    public func setColorScheme(_ colorScheme: ColorScheme) -> SectionHeader {
        var copy: SectionHeader = self
        copy.colorScheme = colorScheme
        return copy
    }
}

#Preview {
    SectionHeader(title: "Titulo")
        .addRightAction(subtitle: "Ver más")
}
