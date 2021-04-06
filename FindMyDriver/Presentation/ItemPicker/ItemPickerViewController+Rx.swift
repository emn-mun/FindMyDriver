import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: ItemPickerViewController<Any> {
    public static func pick<T>(among items: [Pickable<T>], presenter: UIViewController, source: ItemPickerButton) -> Maybe<T> {
        fatalError("TODO")
    }
}
