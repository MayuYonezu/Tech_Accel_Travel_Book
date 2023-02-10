import UIKit
import SwiftUI

// MARK: - Preview Group

@available(iOS 13.0, *)
protocol PreviewProvider: SwiftUI.PreviewProvider {
    static var previews: AnyPreviewGroup { get }
}

protocol Previewable {}
extension UIView: Previewable {}
extension UIViewController: Previewable {}

enum AnyPreviewGroup {
    case view(PreviewGroup<UIView>)
    case viewController(PreviewGroup<UIViewController>)

    var name: String {
        switch self {
        case let .view(group): return group.name
        case let .viewController(group): return group.name
        }
    }
}

struct PreviewGroup<T: Previewable> {
    let name: String

    fileprivate(set) var previews: [Preview<T>]
    fileprivate(set) var width: PreviewSize = .intrinsic
    fileprivate(set) var height: PreviewSize = .intrinsic
    fileprivate(set) var backgroundColor: UIColor = .darkCheckPattern
    fileprivate(set) var device: PreviewDevice = .iPhoneX
}

extension PreviewGroup where T == UIView {

    static func view(
        name: String? = nil,
        file: String = #file,
        @PreviewGroupBuilder builder: () -> [Preview<UIView>]
    ) -> AnyPreviewGroup {
        return .view(self.init(name: name ?? Self.defaultName(file), previews: builder()))
    }
}

extension PreviewGroup where T == UIViewController {

    static func viewController(
        name: String? = nil,
        file: String = #file,
        @PreviewGroupBuilder builder: () -> [Preview<UIViewController>]
    ) -> AnyPreviewGroup {
        return .viewController(self.init(name: name ?? Self.defaultName(file), previews: builder()))
    }
}

extension PreviewGroup {
    private static func defaultName(_ file: String) -> String {
        var fileName = URL(string: file)?.lastPathComponent ?? file
        let suffix = "_Preview.swift"
        if fileName.hasSuffix(suffix) {
            fileName.removeLast(suffix.count)
        }
        return fileName
    }
}

@available(iOS 13.0, *)
extension AnyPreviewGroup: View {
    var body: AnyView {
        switch self {
        case let .view(group):
            return AnyView(ForEach(group.previews, id: \.name) { preview in
                preview.makeView(group: group)
                    .previewDisplayName(preview.name)
                    .previewDevice((preview.device ?? group.device)?.swiftUI)
            })
        case let .viewController(group):
            return AnyView(ForEach(group.previews, id: \.name) { preview in
                preview.makeView(group: group)
                    .previewDisplayName(preview.name)
                    .previewDevice((preview.device ?? group.device)?.swiftUI)
            })
        }
    }
}

@resultBuilder
enum PreviewGroupBuilder {
    static func buildBlock<T: Previewable>(_ previews: Preview<T>...) -> [Preview<T>] { previews }
}

// MARK: - Preview

struct Preview<T: Previewable> {
    let name: String
    let factory: () -> T

    // nilのときPreviewGroupの指定にフォールバック
    fileprivate(set) var width: PreviewSize?
    fileprivate(set) var height: PreviewSize?
    fileprivate(set) var backgroundColor: UIColor?
    fileprivate(set) var device: PreviewDevice?
}

// WORKAROUND: UIViewとUIViewControllerそれぞれで定義しないと推論ができない
// (`where T: Previewable` 指定だと `Preview("name") { ... }` が ambiguous になる)

extension Preview where T == UIView {
    init(_ name: String = "Default", factory: @escaping () -> T) {
        self.name = name
        self.factory = factory
    }
}

extension Preview where T == UIViewController {
    init(_ name: String = "Default", factory: @escaping () -> T) {
        self.name = name
        self.factory = factory
    }
}

// MARK: - SwiftUI

@available(iOS 13.0, *)
fileprivate extension Preview where T: UIView {
    struct SwiftUIView: View, UIViewRepresentable {
        let preview: Preview
        let group: PreviewGroup<UIView>

        func makeUIView(context: Context) -> UIView { UIView() }

        func updateUIView(_ containerView: UIView, context: Context) {
            let previewView = preview.factory()
            previewView.translatesAutoresizingMaskIntoConstraints = false

            containerView.backgroundColor = (preview.backgroundColor ?? group.backgroundColor)
            containerView.addSubview(previewView)

            NSLayoutConstraint.activate([
                previewView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                previewView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                (preview.width ?? group.width).makeConstraint(
                    viewAnchor: previewView.widthAnchor,
                    containerViewAnchor: containerView.widthAnchor
                ),
                (preview.height ?? group.height).makeConstraint(
                    viewAnchor: previewView.heightAnchor,
                    containerViewAnchor: containerView.heightAnchor
                ),
            ].compactMap { $0 })
        }
    }

    func makeView(group: PreviewGroup<UIView>) -> SwiftUIView {
        SwiftUIView(preview: self, group: group)
    }
}

@available(iOS 13.0, *)
fileprivate extension Preview where T: UIViewController {
    struct SwiftUIViewController: View, UIViewControllerRepresentable {
        let preview: Preview
        let group: PreviewGroup<UIViewController>

        func makeUIViewController(context: Context) -> UIViewController {
            preview.factory()
        }

        func updateUIViewController(_: UIViewController, context: Context) {}
    }

    func makeView(group: PreviewGroup<UIViewController>) -> SwiftUIViewController {
        SwiftUIViewController(preview: self, group: group)
    }
}

// MARK: - Preview Configuration

enum PreviewSize {
    // 固定のサイズ (pt)
    case constant(CGFloat)

    // 親ビューのサイズに対する割合
    case multiplier(CGFloat)

    // Auto Layoutに従ったサイズ (制約を作らない)
    case intrinsic

    // 親ビューと一致させる
    static var full: Self { .multiplier(1) }

    func makeConstraint(viewAnchor: NSLayoutDimension,
                        containerViewAnchor: NSLayoutDimension) -> NSLayoutConstraint? {
        switch self {
        case .constant(let constant):
            return viewAnchor.constraint(equalToConstant: constant)
        case .multiplier(let multiplier):
            return viewAnchor.constraint(equalTo: containerViewAnchor, multiplier: multiplier)
        case .intrinsic:
            return nil
        }
    }
}

extension Preview {
    func previewWidth(_ size: PreviewSize) -> Self {
        var preview = self
        preview.width = size
        return preview
    }

    func previewHeight(_ size: PreviewSize) -> Self {
        var preview = self
        preview.height = size
        return preview
    }

    func previewSize(width: PreviewSize, height: PreviewSize) -> Self {
        return self.previewWidth(width).previewHeight(height)
    }

    func previewBackground(_ color: UIColor) -> Self {
        var preview = self
        preview.backgroundColor = color
        return preview
    }

    func previewDevice(_ device: PreviewDevice?) -> Self {
        var preview = self
        preview.device = device
        return preview
    }
}

extension AnyPreviewGroup {
    func previewWidth(_ size: PreviewSize) -> Self {
        switch self {
        case var .view(group):
            group.width = size
            return .view(group)
        case var .viewController(group):
            group.width = size
            return .viewController(group)
        }
    }

    func previewHeight(_ size: PreviewSize) -> Self {
        switch self {
        case var .view(group):
            group.height = size
            return .view(group)
        case var .viewController(group):
            group.height = size
            return .viewController(group)
        }
    }

    func previewSize(width: PreviewSize, height: PreviewSize) -> Self {
        return self.previewWidth(width).previewHeight(height)
    }

    func previewBackground(_ color: UIColor) -> Self {
        switch self {
        case var .view(group):
            group.backgroundColor = color
            return .view(group)
        case var .viewController(group):
            group.backgroundColor = color
            return .viewController(group)
        }
    }

    func previewDevice(_ device: PreviewDevice) -> Self {
        switch self {
        case var .view(group):
            group.device = device
            return .view(group)
        case var .viewController(group):
            group.device = device
            return .viewController(group)
        }
    }
}

// MARK: Preview Device

/// - seealso: https://developer.apple.com/documentation/swiftui/securefield/3289399-previewdevice
enum PreviewDevice: String {
    case iPhone7 = "iPhone 7"
    case iPhone7Plus = "iPhone 7 Plus"
    case iPhone8 = "iPhone 8"
    case iPhone8Plus = "iPhone 8 Plus"
    case iPhoneSE = "iPhone SE"
    case iPhoneX = "iPhone X"
    case iPhoneXs = "iPhone Xs"
    case iPhoneXsMax = "iPhone Xs Max"
    case iPhoneXR = "iPhone Xʀ"
    case iPadmini4 = "iPad mini 4"
    case iPadAir2 = "iPad Air 2"
    case iPadPro97 = "iPad Pro (9.7-inch)"
    case iPadPro129 = "iPad Pro (12.9-inch)"
    case iPad5G = "iPad (5th generation)"
    case iPadPro1292G = "iPad Pro (12.9-inch) (2nd generation)"
    case iPadPro105 = "iPad Pro (10.5-inch)"
    case iPad6G = "iPad (6th generation)"
    case iPadPro11 = "iPad Pro (11-inch)"
    case iPadPro1293G = "iPad Pro (12.9-inch) (3rd generation)"
    case iPadmini5G = "iPad mini (5th generation)"
    case iPadAir3G = "iPad Air (3rd generation)"

    @available(iOS 13.0, *)
    var swiftUI: SwiftUI.PreviewDevice {
        .init(rawValue: rawValue)
    }
}

// MARK: - Utility Extentions

extension UIColor {
    private static func makeCheckPattern(size: CGFloat = 20, base: CGFloat, delta: CGFloat) -> UIColor {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let image = renderer.image { context in
            context.cgContext.setFillColor(gray: base, alpha: 1.0)
            context.fill(CGRect(x: 0, y: 0, width: size, height: size))

            context.cgContext.setFillColor(gray: base + delta, alpha: 1.0)
            context.fill(CGRect(x: 0, y: 0, width: size / 2, height: size / 2))
            context.fill(CGRect(x: size / 2, y: size / 2, width: size / 2, height: size / 2))
        }
        return UIColor(patternImage: image)
    }

    static var lightCheckPattern = makeCheckPattern(base: 1, delta: -0.05)
    static var darkCheckPattern = makeCheckPattern(base: 0, delta: 0.05)
}
