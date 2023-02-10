import Foundation
import SwiftUI

enum WelcomeViewControllerPreview: PreviewProvider {
    static let previews = PreviewGroup.viewController {
        Preview("WelcomeViewController") {
            let viewController = WelcomeViewController()
            return viewController
        }
    }
        .previewWidth(.full)
        .previewHeight(.constant(44))
}
