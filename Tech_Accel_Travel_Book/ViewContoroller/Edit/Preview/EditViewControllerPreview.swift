import Foundation
import SwiftUI

enum EditViewControllerPreview: PreviewProvider {
    static let previews = PreviewGroup.viewController {
        Preview("EditViewController") {
            let viewController = EditViewController()
            return viewController
        }
    }
        .previewWidth(.full)
        .previewHeight(.constant(44))
}
