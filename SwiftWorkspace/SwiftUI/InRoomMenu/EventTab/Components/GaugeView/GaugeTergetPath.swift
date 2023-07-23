//
//  EventSupportGaugeNextLevelLine.swift
//  ShowRoomTest
//
//  Created by 山口誠士 on 2023/07/23.
//

import SwiftUI

struct GaugeTergetPathModel {
    let startPoint: CGPoint
    let endPoint: CGPoint
    let isStartXLarger: Bool
    let firstCornerStartAngle: Angle
    let firstCornerEndAngle: Angle
    let secondCornerStartAngle: Angle
    let secondCornerEndAngle: Angle
    let radius: CGFloat

    let firstCornerArcCenterPoint: CGPoint
    let secondCornerArcCenterPoint: CGPoint

    let firstCornerArcStartPoint: CGPoint
    let firstCornerArcEndPoint: CGPoint

    let secondCornerArcStartPoint: CGPoint
    let secondCornerArcEndPoint: CGPoint

    init(
        startX: CGFloat,
        endX: CGFloat,
        gaugeBarheight: CGFloat,
        gaugeBarPaddingBottom: CGFloat
    ) {
        let isStartXLarger = startX > endX
        let defaultRadius: CGFloat = gaugeBarPaddingBottom / 2
        let radius: CGFloat = abs(startX - endX) < defaultRadius ? abs(startX - endX) / 2 : defaultRadius

        let firstCornerArcStartPoint = CGPoint(
            x: startX,
            y: gaugeBarheight + defaultRadius - radius
        )

        let firstCornerArcEndPoint = CGPoint(
            x: isStartXLarger ? startX - radius : startX + radius,
            y: firstCornerArcStartPoint.y + radius
        )

        let secondCornerArcStartPoint = CGPoint(
            x: isStartXLarger ? endX + radius : endX - radius,
            y: firstCornerArcEndPoint.y
        )

        let secondCornerArcEndPoint = CGPoint(
            x: endX,
            y: gaugeBarheight + gaugeBarPaddingBottom - (defaultRadius - radius)
        )

        startPoint = .init(x: startX, y: 0)
        endPoint = .init(x: endX, y: gaugeBarheight + gaugeBarPaddingBottom)
        self.radius = radius
        self.isStartXLarger = isStartXLarger

        self.firstCornerArcStartPoint = firstCornerArcStartPoint
        self.firstCornerArcEndPoint = firstCornerArcEndPoint
        self.secondCornerArcStartPoint = secondCornerArcStartPoint
        self.secondCornerArcEndPoint = secondCornerArcEndPoint

        firstCornerStartAngle = isStartXLarger ? Angle(degrees: 0) : Angle(degrees: 90)
        firstCornerEndAngle = isStartXLarger ? Angle(degrees: 90) : Angle(degrees: 180)
        secondCornerStartAngle = isStartXLarger ? Angle(degrees: 180) : Angle(degrees: 270)
        secondCornerEndAngle = isStartXLarger ? Angle(degrees: 270) : Angle(degrees: 0)

        firstCornerArcCenterPoint = .init(
            x: firstCornerArcEndPoint.x,
            y: firstCornerArcStartPoint.y
        )

        secondCornerArcCenterPoint = .init(
            x: secondCornerArcStartPoint.x,
            y: secondCornerArcEndPoint.y
        )
    }
}

struct GaugeTergetPath: View {

    private let model: GaugeTergetPathModel?

    init(
        startX: CGFloat?,
        endX: CGFloat?,
        gaugeBarheight: CGFloat,
        gaugeBarPaddingBottom: CGFloat
    ) {
        if let startX = startX,
           let endX = endX {
            model = GaugeTergetPathModel(
                startX: startX,
                endX: endX,
                gaugeBarheight: gaugeBarheight,
                gaugeBarPaddingBottom: gaugeBarPaddingBottom
            )
        } else {
            model = nil
        }
    }

    var body: some View {
        if let model = model {
            Path { path in
                path.addLines([
                    model.startPoint,
                    model.firstCornerArcStartPoint
                ])

                if !model.isStartXLarger {
                    path.move(to: model.firstCornerArcEndPoint)
                }

                path.addArc(
                    center: model.firstCornerArcCenterPoint,
                    radius: model.radius,
                    startAngle: model.firstCornerStartAngle,
                    endAngle: model.firstCornerEndAngle,
                    clockwise: false
                )

                path.addLines([
                    model.firstCornerArcEndPoint,
                    model.secondCornerArcStartPoint
                ])

                if model.isStartXLarger {
                    path.move(to: model.secondCornerArcEndPoint)
                }

                path.addArc(
                    center: model.secondCornerArcCenterPoint,
                    radius: model.radius,
                    startAngle: model.secondCornerStartAngle,
                    endAngle: model.secondCornerEndAngle,
                    clockwise: false
                )

                path.addLines([
                    model.secondCornerArcEndPoint,
                    model.endPoint
                ])

            }
            .stroke(
                Color(.black),
                lineWidth: 2
            )
        } else {
            EmptyView()
        }
    }
}
struct EventSupportGaugeNextLevelLine_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            let gaugeBarPaddingBottom: CGFloat = 8
            let gaugeBarHeight: CGFloat = 10
            GaugeTergetPath(
                startX: 260,
                endX: 250,
                gaugeBarheight: gaugeBarHeight,
                gaugeBarPaddingBottom: gaugeBarPaddingBottom
            )
                .frame(height: 40)
        }
    }
}
