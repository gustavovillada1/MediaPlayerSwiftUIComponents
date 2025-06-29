//
//  MusicBarsView.swift
//
//
//  Created by Gustavo Adolfo Villada Molina on 29/06/25.
//

import Foundation
import SwiftUI

struct MusicBarsView: View {
    @State private var barHeights: [CGFloat] = [20, 40, 30]
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 4) {
            ForEach(barHeights.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .frame(width: 4, height: barHeights[index])
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                barHeights = barHeights.map { _ in
                    CGFloat.random(in: 5...35)
                }
            }
        }
    }
}
