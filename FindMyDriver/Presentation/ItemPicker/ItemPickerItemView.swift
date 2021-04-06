import UIKit

final class ItemPickerItemView : UIView {

    private let stack = UIStackView()..{
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }

    private let imageView = UIImageView()..{
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
    }

    private let label = UILabel()..{
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.adjustsFontForContentSizeCategory = true
        $0.setContentHuggingPriority(.required, for: .vertical)
    }

    init<T>(item: Pickable<T>) {
        super.init(frame: .zero)

        imageView.image = item.image
        label.text = item.title

        layer.masksToBounds = true
        layer.cornerRadius = 16

        backgroundColor = .white

        stack.addArrangedSubview(RoundedView(contentView: imageView))
        stack.addArrangedSubview(label)

        addSubview(stack) { make in
            make.edges.equalToSuperview().inset(8)
        }
        imageView.snp.makeConstraints { make in
            make.width.equalTo(imageView.snp.height)
            make.height.equalTo(label).multipliedBy(2)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
