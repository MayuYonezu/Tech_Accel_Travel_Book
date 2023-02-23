import Foundation
import SwiftUI

enum ListViewControllerPreview: PreviewProvider {
    static let previews = PreviewGroup.viewController {
        Preview("ListViewController") {
            let viewController = ListViewController(presenter: ListPresenter())
            return viewController
        }
    }
        .previewWidth(.full)
        .previewHeight(.constant(44))
}
