import UIKit

final class RoundedView<T: UIView>: UIView {

    let contentView: T
    init(contentView: T) {
        self.contentView = contentView
        super.init(frame: .zero)
        addSubview(contentView) { make in
            make.edges.equalToSuperview()
        }
        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) * 0.5
    }
}

