//  ListViewControllerPreview.swift
//  Tech_Accel_Travel_Book
//
//  Created by 新垣 清奈 on 2023/02/10.
//

import Foundation
import SwiftUI

enum ListViewControllerPreview: PreviewProvider {
    static let previews = PreviewGroup.viewController {
        Preview("ListViewController") {
            let viewController = ListViewController()
            return viewController
        }
    }
        .previewWidth(.full)
        .previewHeight(.constant(44))
}
