import UIKit
import CoreLocation
import RxSwift

final class DriverDetailsView: UIView {
  private let driverImageView = UIImageView()..{
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.masksToBounds = true
  }
  
  private let nameLabel = UILabel()..{
    $0.font = UIFont.preferredFont(forTextStyle: .body)
    $0.adjustsFontForContentSizeCategory = true
  }
  
  private let timeLabel = UILabel()..{
    $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
    $0.adjustsFontForContentSizeCategory = true
  }
  
  private let addressInfoStack = UIStackView()..{
    $0.axis = .vertical
  }
  
  private let addressLabel = UILabel()..{
    $0.font = UIFont.preferredFont(forTextStyle: .caption2)
    $0.adjustsFontForContentSizeCategory = true
  }
  
  private let localityLabel = UILabel()..{
    $0.font = UIFont.preferredFont(forTextStyle: .caption2)
    $0.adjustsFontForContentSizeCategory = true
  }
  
  private let countryLabel = UILabel()..{
    $0.font = UIFont.preferredFont(forTextStyle: .caption2)
    $0.adjustsFontForContentSizeCategory = true
  }
  
  private let formtter = DateFormatter()
  private let disposeBag = DisposeBag()
  
  init() {
    super.init(frame: .zero)
    formtter.dateFormat = "dd MMM YYYY HH:mm:ss"
    
    layer.masksToBounds = true
    layer.cornerRadius = 16
    backgroundColor = .white
    
    setupDriveInfoStack()
  }
  
  func update(driverViewModel: DriverViewModel) {
    DispatchQueue.main.async {
        self.driverImageView.image = driverViewModel.image
    }

    let dateString = formtter.string(from: Date())
    
    timeLabel.text = dateString
    nameLabel.text = driverViewModel.driver.firstname + " " + driverViewModel.driver.lastname
    
    driverViewModel.addressInfo.subscribe(onNext: { addressInfo in
      self.addressLabel.text = addressInfo.address
      self.localityLabel.text = addressInfo.locality
      self.countryLabel.text = addressInfo.country
    }).disposed(by: disposeBag)
  }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupDriveInfoStack() {
    let driverInfoStack = UIStackView(frame: .zero)
    driverInfoStack.axis = .vertical
    driverInfoStack.addArrangedSubview(nameLabel)
    driverInfoStack.addArrangedSubview(timeLabel)
    
    let driverViews = [RoundedView(contentView:driverImageView), driverInfoStack, addressInfoStack]
    [addressLabel, localityLabel, countryLabel].forEach { addressInfoStack.addArrangedSubview($0) }
    
    driverViews.forEach { addSubview($0) }
    driverViews.removeAutoresizingMasks()
    
    NSLayoutConstraint.activate([
      driverImageView.heightAnchor.constraint(equalToConstant: 40),
      driverImageView.widthAnchor.constraint(equalToConstant: 40),
      driverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      driverImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      driverInfoStack.leadingAnchor.constraint(equalTo: driverImageView.trailingAnchor, constant: 8),
      driverInfoStack.centerYAnchor.constraint(equalTo: driverImageView.centerYAnchor),
      addressInfoStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      addressInfoStack.topAnchor.constraint(equalTo: driverImageView.bottomAnchor, constant: 8),
      addressInfoStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      addressInfoStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
    ])
  }
  
}
