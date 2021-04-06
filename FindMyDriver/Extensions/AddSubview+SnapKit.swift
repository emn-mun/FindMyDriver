import UIKit
import SnapKit

extension UIView {
    public func addSubview(_ view: UIView, makeConstraints: (ConstraintMaker) -> Void) {
        addSubview(view)
        view.snp.makeConstraints(makeConstraints)
    }
}
