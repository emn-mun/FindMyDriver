import UIKit

public final class ItemPickerButton: UIControl {

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        loadingIndicator.color = tintColor

        contentMode = .redraw
        isOpaque = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.25
        layer.masksToBounds = false

        menuStateLayer.strokeColor = tintColor.cgColor
        menuStateLayer.fillColor = nil
        layer.addSublayer(menuStateLayer)
        addSubview(loadingIndicator)

        menuState = .closed
    }

    // MARK: - Loading State

    private let loadingIndicator = UIActivityIndicatorView(style: .white)

    public var isLoading: Bool = false {
        didSet {
            if isLoading {
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
            }
            loadingIndicator.isHidden = !isLoading
            menuStateLayer.isHidden = isLoading
        }
    }

    // MARK: - Menu State

    private let menuStateLayer = CAShapeLayer()

    public enum MenuState {
        case open, closed
    }

    public var menuState: MenuState = .closed {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
            layoutIfNeeded()
            menuStateLayer.path = iconPath.cgPath
        }
    }

    private var iconFrame: CGRect {
        let inset = backgroundSize * 0.30
        let frame = backgroundFrame.insetBy(dx: inset, dy: inset).integral
        switch menuState {
        case .open:
            return frame
        case .closed:
            return frame.insetBy(dx: 0, dy: frame.height * 0.15).integral
        }
    }

    private var iconPath: UIBezierPath {
        let icon = UIBezierPath()

        func addLine(from: (x: CGFloat, y: CGFloat), to: (x: CGFloat, y: CGFloat)) {
            icon.move(to: CGPoint(x: from.x, y: from.y))
            icon.addLine(to: CGPoint(x: to.x, y: to.y))
        }

        switch menuState {
        case .open:
            addLine(from: (iconFrame.minX, iconFrame.minY), to: (iconFrame.maxX, iconFrame.maxY))
            addLine(from: (iconFrame.midX, iconFrame.midY), to: (iconFrame.midX, iconFrame.midY))
            addLine(from: (iconFrame.minX, iconFrame.maxY), to: (iconFrame.maxX, iconFrame.minY))
        case .closed:
            addLine(from: (iconFrame.minX, iconFrame.minY), to: (iconFrame.maxX, iconFrame.minY))
            addLine(from: (iconFrame.minX, iconFrame.midY), to: (iconFrame.maxX, iconFrame.midY))
            addLine(from: (iconFrame.minX, iconFrame.maxY), to: (iconFrame.maxX, iconFrame.maxY))
        }

        icon.lineWidth = max(1, (backgroundSize * 0.05).rounded(.up))

        return icon
    }

    // MARK: - Background

    private var backgroundSize: CGFloat {
        return min(bounds.width, bounds.height)
    }

    private var backgroundFrame: CGRect {
        return CGRect(
            x: bounds.midX - backgroundSize / 2,
            y: bounds.midY - backgroundSize / 2,
            width: backgroundSize,
            height: backgroundSize
            ).integral
    }

    private var backgroundPath: UIBezierPath {
        return UIBezierPath(ovalIn: backgroundFrame)
    }

    // MARK: - UIControl

    public override var isHighlighted: Bool {
        didSet { setNeedsLayout() }
    }

    // MARK: - UIView

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 56, height: 56)
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        menuStateLayer.strokeColor = tintColor.cgColor
        loadingIndicator.color = tintColor
    }

    public override func draw(_ rect: CGRect) {
        (backgroundColor ?? .white).setFill()
        backgroundPath.fill()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        loadingIndicator.sizeToFit()
        loadingIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
        transform = isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity

        if menuStateLayer.frame != layer.bounds {
            menuStateLayer.frame = layer.bounds
            let iconPath = self.iconPath
            menuStateLayer.path = iconPath.cgPath
            menuStateLayer.lineWidth = iconPath.lineWidth
            layer.shadowPath = backgroundPath.cgPath
        }
    }

}
