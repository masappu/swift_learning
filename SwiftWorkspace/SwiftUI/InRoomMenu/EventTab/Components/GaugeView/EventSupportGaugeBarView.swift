//
//  EventSupportGaugeBarView.swift
//  ShowRoomTest
//
//  Created by 山口誠士 on 2023/07/22.
//

import SwiftUI

struct EventSupportGaugeBarView: View {

    let maxLevel: Int?
    let delemiterTergetLevel: Int?

    @Binding var delimiterStartX: CGFloat?

    var body: some View {

        if let maxLevel = maxLevel {
            Rectangle()
                .fill(Color(ColorResource.lightGray.rawValue))
                .overlay {
                    GeometryReader { geometry in
                        ForEach(1..<maxLevel, id: \.self) { index in
                            Path { path in
                                let x = geometry.size.width / CGFloat(maxLevel) * CGFloat(index)

                                path.addLines([
                                    .init(x: x, y: 0),
                                    .init(x: x, y: geometry.size.height)
                                ])
                            }
                            .stroke(
                                Color(ColorResource.gray.rawValue),
                                lineWidth: 1
                            )
                        }
                    }
                }
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            if let delemiterTergetLevel = delemiterTergetLevel {
                                delimiterStartX = geometry.size.width / CGFloat(maxLevel) * CGFloat(delemiterTergetLevel)
                            }
                        }
                })
        } else {
            Rectangle()
                .fill(Color(ColorResource.lightGray.rawValue))
        }
    }
}

struct EventSupportGaugeBarView_Previews: PreviewProvider {
    static var previews: some View {
        EventSupportGaugeBarView(maxLevel: 10, delemiterTergetLevel: nil, delimiterStartX: .constant(nil))
            .frame(height: 10)
            .padding(.horizontal)
    }
}
