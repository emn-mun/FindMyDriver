import UIKit

final class DriverView : UIView {

    let nameLabel = UILabel()..{
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.adjustsFontForContentSizeCategory = true
        $0.setContentHuggingPriority(.required, for: .vertical)
    }

    let dateLabel = UILabel()..{
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.textColor = .gray
        $0.adjustsFontForContentSizeCategory = true
        $0.setContentHuggingPriority(.required, for: .vertical)
    }

    let addressLabel = UILabel()..{
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
    }

    let profileImageView = UIImageView()..{
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    init() {
        super.init(frame: .zero)

        let labelsStack = UIStackView(arrangedSubviews: [nameLabel, dateLabel])..{
            $0.axis = .vertical
        }

        let headerStack = UIStackView(arrangedSubviews: [RoundedView(contentView: profileImageView), labelsStack])..{
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 16
        }

        let contentStack = UIStackView(arrangedSubviews: [headerStack, addressLabel])..{
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 8
        }

        addSubview(contentStack) { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(profileImageView.snp.height)
            make.height.equalTo(labelsStack.snp.height).multipliedBy(1.2)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
