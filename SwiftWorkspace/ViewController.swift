//
//  ViewController.swift
//  ShowRoomTest
//
//  Created by 山口誠士 on 2023/07/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let eventSupportGaugeView = EventSupportGaugeView(
            maxLevel: 100,
            nextLevel: 46,
            nextLevelPoint: 300000
        )

        let hostingController = UIHostingController(rootView: eventSupportGaugeView)

        // hostingControllerを子として追加
        addChild(hostingController)

        // hostingControllerのviewをMyViewControllerのviewに追加
        view.addSubview(hostingController.view)

        // AutoLayout制約を設定
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // hostingControllerのライフサイクルを管理するためにdidMoveを呼ぶ
        hostingController.didMove(toParent: self)
    }


}

