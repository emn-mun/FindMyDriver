import UIKit

public protocol Routable: AnyObject {
  var rootViewController: UINavigationController { get }
}

public protocol FindDriverRoutable: Routable {
  func showFindDriverViewController()
}

class FindDriverRouter: FindDriverRoutable {
  var rootViewController: UINavigationController
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  func showFindDriverViewController() {
    let presenter = FindDriverPresenter(interactor: FindDriverInteractor(service: LoadDriversService()), router: self)
    rootViewController.pushViewController(FindMyDriverViewController(presenter: presenter), animated: false)
  }
}
