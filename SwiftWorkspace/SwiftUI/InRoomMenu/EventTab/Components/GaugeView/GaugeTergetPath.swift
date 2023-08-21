//
//  Created by masashi.yamaguchi on 2023/07/24
//  Copyright © 2023 SHOWROOM Inc. All rights reserved.
//

import SwiftUI

struct NextLevelTargetPathModel {

    // 始点
    let startPoint: CGPoint

    // 最初の角丸
    let firstCornerArcCenterPoint: CGPoint
    let firstCornerStartAngle: Angle
    let firstCornerEndAngle: Angle
    let firstCornerArcEndPoint: CGPoint

    // ２番目の角丸
    let secondCornerArcStartPoint: CGPoint
    let secondCornerArcCenterPoint: CGPoint
    let secondCornerStartAngle: Angle
    let secondCornerEndAngle: Angle
    let secondCornerArcEndPoint: CGPoint

    // 終点
    let endPoint: CGPoint

    let radius: CGFloat
    let isStartXLarger: Bool

    init(
        startPoint: CGPoint,
        endX: CGFloat,
        gaugeBarHeight: CGFloat,
        gaugeBarPaddingBottom: CGFloat
    ) {
        let isStartXLarger = startPoint.x > endX
        let defaultRadius: CGFloat = gaugeBarPaddingBottom / 2
        let radius: CGFloat = abs(startPoint.x - endX) < defaultRadius * 2 ? abs(startPoint.x - endX) / 2 : defaultRadius

        let firstCornerArcEndPoint = CGPoint(
            x: isStartXLarger ? startPoint.x - radius : startPoint.x + radius,
            y: startPoint.y + radius
        )

        let secondCornerArcStartPoint = CGPoint(
            x: isStartXLarger ? endX + radius : endX - radius,
            y: firstCornerArcEndPoint.y
        )

        let secondCornerArcEndPoint = CGPoint(
            x: endX,
            y: firstCornerArcEndPoint.y + radius
        )

        endPoint = .init(x: endX, y: secondCornerArcEndPoint.y + gaugeBarHeight)
        self.radius = radius
        self.isStartXLarger = isStartXLarger

        self.firstCornerArcEndPoint = firstCornerArcEndPoint
        self.secondCornerArcStartPoint = secondCornerArcStartPoint
        self.secondCornerArcEndPoint = secondCornerArcEndPoint

        firstCornerStartAngle = isStartXLarger ? Angle(degrees: 0) : Angle(degrees: 90)
        firstCornerEndAngle = isStartXLarger ? Angle(degrees: 90) : Angle(degrees: 180)
        secondCornerStartAngle = isStartXLarger ? Angle(degrees: 180) : Angle(degrees: 270)
        secondCornerEndAngle = isStartXLarger ? Angle(degrees: 270) : Angle(degrees: 0)

        firstCornerArcCenterPoint = .init(
            x: firstCornerArcEndPoint.x,
            y: startPoint.y
        )

        secondCornerArcCenterPoint = .init(
            x: secondCornerArcStartPoint.x,
            y: secondCornerArcEndPoint.y
        )
        self.startPoint = startPoint
    }
}

struct NextLevelTargetPath: View {

    static let coordinateSpaceName = "NextLevelTargetPathCoordinateSpaceName"
    private let model: NextLevelTargetPathModel?

    init(
        startPoint: CGPoint?,
        endX: CGFloat?,
        gaugeBarHeight: CGFloat,
        gaugeBarPaddingBottom: CGFloat
    ) {
        if let startPoint = startPoint,
           let endX = endX {
            model = NextLevelTargetPathModel(
                startPoint: startPoint,
                endX: endX,
                gaugeBarHeight: gaugeBarHeight,
                gaugeBarPaddingBottom: gaugeBarPaddingBottom
            )
        } else {
            model = nil
        }
    }

    var body: some View {
        if let model = model {
            Path { path in

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

                path.move(to: model.firstCornerArcEndPoint)

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
                .black,
                lineWidth: 2
            )
        } else {
            EmptyView()
        }
    }
}
struct NextLevelTargetPath_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            let gaugeBarPaddingBottom: CGFloat = 8
            let gaugeBarHeight: CGFloat = 10
            NextLevelTargetPath(
                startPoint: .init(x: 165, y: 10),
                endX: 190,
                gaugeBarHeight: gaugeBarHeight,
                gaugeBarPaddingBottom: gaugeBarPaddingBottom
            )
                .frame(height: 40)
        }
    }
}
