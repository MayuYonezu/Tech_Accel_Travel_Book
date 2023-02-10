//
//  LookViewControllerPreview.swift
//  Tech_Accel_Travel_Book
//
//  Created by 新垣 清奈 on 2023/02/10.
//

import Foundation
import SwiftUI

enum LookViewControllerPreview: PreviewProvider {
    static let previews = PreviewGroup.viewController {
        Preview("LookViewController") {
            let viewController = LookViewController()
            return viewController
        }
    }
        .previewWidth(.full)
        .previewHeight(.constant(44))
}
