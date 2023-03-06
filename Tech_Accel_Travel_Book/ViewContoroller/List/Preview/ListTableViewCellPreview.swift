import Foundation
import SwiftUI

enum ListTableViewCellPreview: PreviewProvider {
    static let previews = PreviewGroup.view {
        Preview("ListTableViewCell") {
            let view = ListTableViewCell()
            view.backgroundColor = .white
            view.setUp(titleText: "titleText")
            return view
        }
    }
        .previewWidth(.full)
        .previewHeight(.constant(50))
}
