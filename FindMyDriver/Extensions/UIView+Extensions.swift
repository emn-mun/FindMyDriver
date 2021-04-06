import UIKit

extension Array where Element: UIView {
  func removeAutoresizingMasks() {
    forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
  }
}
