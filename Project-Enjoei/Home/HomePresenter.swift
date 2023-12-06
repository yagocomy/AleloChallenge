import UIKit

protocol HomePresentationLogic {
    func presentProducts(response: Home.Products.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    func presentProducts(response: Home.Products.Response) {
        viewController?.displayProducts(viewModel: .init(model: response.model))
    }
}
