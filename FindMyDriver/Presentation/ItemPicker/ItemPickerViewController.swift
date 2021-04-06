import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit

public final class ItemPickerViewController<T>: UIViewController {

    private let items: [Pickable<T>]
    private let source: ItemPickerButton

    public init(items: [Pickable<T>], source: ItemPickerButton) {
        self.items = items
        self.source = source
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
