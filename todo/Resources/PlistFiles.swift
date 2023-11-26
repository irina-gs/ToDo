import Foundation

enum PlistFiles {
    private static let _document = PlistDocument(path: "Info.plist")

    static let cfApiBaseUrl: String = _document["API_BASE_URL"]
}

private struct PlistDocument {
    let data: [String: Any]

    init(path: String) {
        guard let url = BundleToken.bundle.url(forResource: path, withExtension: nil),
              let data = NSDictionary(contentsOf: url) as? [String: Any] else {
            fatalError("Unable to load PLIST at path: \(path)")
        }
        self.data = data
    }

    subscript<T>(key: String) -> T {
        guard let result = data[key] as? T else {
            fatalError("Property '\(key)' is not of type \(T.self)")
        }
        return result
    }
}

private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BundleToken.self)
        #endif
    }()
}
