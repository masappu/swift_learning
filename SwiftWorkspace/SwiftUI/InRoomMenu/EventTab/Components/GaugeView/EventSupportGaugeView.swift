//
//  EventSupportGaugeView.swift
//  ShowRoomTest
//
//  Created by 山口誠士 on 2023/07/22.
//

import SwiftUI

struct EventSupportGaugeView: View {

    let maxLevel: Int?
    let nextLevel: Int?
    let nextLevelPoint: Int

    static let delimiterCoordinateSpace = "delimiterCoordinateSpace"

    @State private var delimiterStartX: CGFloat? = nil
    @State private var delimiterEndX: CGFloat? = nil

    func convertStringFormatter(
        _ value: Int
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        return formatter.string(from: NSNumber(value: value)) ?? ""
    }

    var body: some View {
        VStack(spacing: 8) {
            EventSupportGaugeBarView(
                maxLevel: maxLevel,
                delemiterTergetLevel: nextLevel,
                delimiterStartX: $delimiterStartX
            )
                .frame(height: 10)


            HStack(spacing: 2) {
                Text("目標")
                    .font(.system(size: 13, weight: .semibold))

                if let nextLevel = nextLevel {
                    let nextLevelString = convertStringFormatter(nextLevel)
                    Text(nextLevelString + "Lv")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.all, 2)
                        .background(Color.black)
                        .cornerRadius(2)
                        .background {
                            GeometryReader { geometory in
                                Color.clear
                                    .onAppear {
                                        delimiterEndX = geometory.frame(in: .named(EventSupportGaugeView.delimiterCoordinateSpace)).midX
                                    }
                            }
                        }
                }

                let goalPointString = convertStringFormatter(nextLevelPoint)
                Text(goalPointString + "pt")
                    .font(.system(size: 13, weight: .semibold))
            }
        }
        .coordinateSpace(name: EventSupportGaugeView.delimiterCoordinateSpace)
        .overlay {
            GaugeTergetPath(
                startX: delimiterStartX,
                endX: delimiterEndX,
                gaugeBarheight: 10,
                gaugeBarPaddingBottom: 8
            )
        }
    }
}

struct EventSupportGaugeView_Previews: PreviewProvider {
    static var previews: some View {
        EventSupportGaugeView(
            maxLevel: nil,
            nextLevel: nil,
            nextLevelPoint: 300000
        )
            .padding(.horizontal)
    }
}
