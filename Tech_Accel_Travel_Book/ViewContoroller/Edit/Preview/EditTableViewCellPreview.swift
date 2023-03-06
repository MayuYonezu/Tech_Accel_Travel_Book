import Foundation
import SwiftUI

enum EditTableViewCellPreview: PreviewProvider {
    static let previews = PreviewGroup.view {
        Preview("EditTableViewCell") {
            let view = EditTableViewCell()
            view.backgroundColor = .white
            view.setUp(startedTime: "abcd", finishTime: "efgh", planText: "planning")
            return view
        }
    }
        .previewWidth(.full)
        .previewHeight(.constant(44))
}
