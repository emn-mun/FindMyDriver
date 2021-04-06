import UIKit
import MapKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit

class FindMyDriverViewController: UIViewController {
    private let introLabel = UILabel(frame: .zero)..{
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .gray
        $0.text = .localized("found-drivers.none.label")
    }
    private let driversStackView = UIStackView()..{
        $0.axis = .vertical
        $0.spacing = 10
    }
    private let driverDetailsView = DriverDetailsView()..{
        $0.isHidden = true
    }
    private lazy var mapView = MKMapView()
    private let driverPickerButton = ItemPickerButton()
    private let driversStackViewHeightConstraint: NSLayoutConstraint

    private let presenter: FindDriverPresentable
    private let disposeBag = DisposeBag()

    init(presenter: FindDriverPresentable) {
        self.presenter = presenter
        driversStackViewHeightConstraint = driversStackView.heightAnchor.constraint(equalToConstant: 0)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = .localized("find.driver")
        view.backgroundColor = .white

        view.addSubview(introLabel) { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualTo(32)
            make.trailing.lessThanOrEqualTo(32)
        }

        setupDriverPickerButton()
        setupMap()
        setupDriversStackView()
        setupDriverDetailsView()

        presenter.selectedDriver
            .subscribe(onNext: { [weak self] driverViewModel in
                guard let strongSelf = self else { return }
                guard let driverViewModel = driverViewModel else { return }

                strongSelf.showMapAnotation(for: driverViewModel)
                strongSelf.driverDetailsView.isHidden = false
                strongSelf.driverDetailsView.update(driverViewModel: driverViewModel)
            }).disposed(by: disposeBag)
    }

    private func setupDriverPickerButton() {
        view.addSubview(driverPickerButton) { make in
            make.trailing.bottomMargin.equalToSuperview().inset(16)
        }

        driverPickerButton.rx.tapGesture().when(.recognized)
            .withLatestFrom(presenter.availableDrivers)
            .subscribe(onNext: { [weak self] drivers in
                guard let strongSelf = self else { return }
                switch strongSelf.driverPickerButton.menuState {
                case .open:
                    strongSelf.driverPickerButton.menuState = .closed
                    strongSelf.hideAvailableDrivers()
                case .closed:
                    strongSelf.driverPickerButton.menuState = .open
                    strongSelf.showAvailable(drivers: drivers)
                }
            }).disposed(by: disposeBag)
    }

    private func setupMap() {
        view.addSubview(mapView) { make in
            make.edges.equalToSuperview()
        }
        mapView.isHidden = true
        driverPickerButton.isLoading = true

        presenter.availableDrivers
            .subscribe(onNext: { [weak self] drivers in
                guard let strongSelf = self else { return }
                strongSelf.driverPickerButton.isLoading = false
                strongSelf.mapView.isHidden = drivers.isEmpty
                strongSelf.view.bringSubviewToFront(strongSelf.driverPickerButton)
                }, onError: { [weak self] error in
                    self?.driverPickerButton.isLoading = false
                    self?.showError(with: error.localizedDescription)
            }).disposed(by: disposeBag)
    }

    private func setupDriversStackView() {
        view.addSubview(driversStackView)
        driversStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([driversStackView.bottomAnchor.constraint(equalTo: driverPickerButton.topAnchor, constant: -20),
                                     driversStackView.trailingAnchor.constraint(equalTo: driverPickerButton.trailingAnchor)
            ])
    }

    private func setupDriverDetailsView() {
      view.addSubview(driverDetailsView) { make in
        make.topMargin.equalTo(20)
        make.leading.equalTo(10)
        make.trailing.equalTo(-10)
      }
    }

    private func showAvailable(drivers: [DriverViewModel]) {
        guard driversStackView.arrangedSubviews.isEmpty else {
            driversStackViewHeightConstraint.isActive = false
            return
        }

        let pickerItems = drivers.map { (driverViewModel: DriverViewModel) -> ItemPickerItemView in
            let itemPickerView = ItemPickerItemView(item: Pickable(value: driverViewModel, title: driverViewModel.driver.firstname, image: driverViewModel.image ?? UIImage()))
            _ = itemPickerView.rx.tapGesture().when(.recognized).subscribe { item in
                driverViewModel.action?()
                }.disposed(by: disposeBag)
            return itemPickerView
        }

        pickerItems.forEach {
            driversStackView.addArrangedSubview($0)
        }
    }

    private func hideAvailableDrivers() {
        driversStackViewHeightConstraint.isActive = true
    }

    private func showMapAnotation(for driverViewModel: DriverViewModel) {
        let location = CLLocationCoordinate2D(latitude: driverViewModel.driver.coordinates.latitude,
                                              longitude: driverViewModel.driver.coordinates.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = mapView.annotations.first as? MKPointAnnotation ?? MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = driverViewModel.driver.firstname

        mapView.addAnnotation(annotation)
    }

    func showError(with message: String) {
        let alert = UIAlertController(title: message, message: .localized("retry.message"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .localized("ok.message"), style: .default))
        present(alert, animated: true)
    }
}
