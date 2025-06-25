//
//  BottomTabView.swift
//
//
//  Created by Gustavo Adolfo Villada Molina on 25/06/25.
//

import Foundation
import SwiftUI

/// A reusable bottom tab view that displays a customizable tab bar and renders the selected tab's content.
///
/// This view is generic over a type `Tab` that conforms to `BottomTabItemProtocol`.
/// Each tab must provide an icon and a corresponding view to render.
///
/// - Note: The tab bar uses a rounded rectangle with shadow and is pinned to the bottom of the screen.

public struct BottomTabView<Tab: BottomTabItemProtocol>: View {
    @State private var selectedTab: Tab = Tab.allCases.first!

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            selectedTab.view
                .ignoresSafeArea()

            BottomTabBar(selectedTab: $selectedTab)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

/// A reusable bottom tab bar with rounded corners and a modern shadowed appearance.
///
/// This component displays all cases of the provided `Tab` enum, showing icons only (no text).
/// The selected icon is highlighted with a custom color (default: green).
///
/// - Parameters:
///   - selectedTab: A binding to the currently selected tab item.
///
/// - Note: Typically used inside `BottomTabView`.
public struct BottomTabBar<Tab: BottomTabItemProtocol>: View {
    @Binding var selectedTab: Tab

    public init(selectedTab: Binding<Tab>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        HStack {
            ForEach(Array(Tab.allCases), id: \.self) { tab in
                Spacer()
                Button {
                    selectedTab = tab
                } label: {
                    Image(systemName: tab.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(selectedTab == tab ? .green : .gray)
                }
                Spacer()
            }
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }
}

// MARK: Demonstration
#Preview {
    BottomTabViewPreviewWrapper()
}

enum TabItem: BottomTabItemProtocol {
    case yellowScreen, blueScreen, redScreen

    var label: String {
        switch self {
        case .yellowScreen: "Yellow"
        case .blueScreen: "Blue"
        case .redScreen: "Red"
        }
    }

    var icon: String {
        switch self {
        case .yellowScreen: "house.fill"
        case .blueScreen: "books.vertical.fill"
        case .redScreen: "person.crop.circle.fill"
        }
    }

    var view: AnyView {
        switch self {
        case .yellowScreen: AnyView(Color.yellow)
        case .blueScreen: AnyView(Color.blue)
        case .redScreen: AnyView(Color.red)
        }
    }
}

struct BottomTabViewPreviewWrapper: View {
    
    var body: some View {
        VStack {
            BottomTabView<TabItem>()
        }
    }
}
