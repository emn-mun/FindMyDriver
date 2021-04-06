import Foundation

private class BundleIdentifier: NSObject {}
public var localizationsBundle: Bundle = Bundle(for: BundleIdentifier.self)

extension String {
    public static func localized(
        _ key: String,
        with args: CVarArg...,
        in bundle: Bundle = localizationsBundle,
        table: String? = nil,
        fallback: String? = nil) -> String {

        let format = bundle.localizedString(forKey: key, value: fallback, table: table)
        let localizedString = NSString(format: format, locale: Locale.current, arguments: getVaList(args)) as String
        return localizedString
    }
}
