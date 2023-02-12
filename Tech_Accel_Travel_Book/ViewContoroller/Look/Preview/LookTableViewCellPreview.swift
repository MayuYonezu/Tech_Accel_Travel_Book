//
//  LookTableViewCellPreview.swift
//  Tech_Accel_Travel_Book
//
//  Created by 新垣 清奈 on 2023/02/12.
//

import Foundation
import SwiftUI

enum LookTableViewCellPreview: PreviewProvider {
    static let previews = PreviewGroup.view {
        Preview("LookTableViewCell") {
            let view = LookTableViewCell()
            view.backgroundColor = .white
            view.setUp(startedTime: "abcd", finishTime: "efgh", planText: "planning")
            return view
        }
    }
        .previewWidth(.full)
        .previewHeight(.constant(44))
}
