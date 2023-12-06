import UIKit

protocol HomeBusinessLogic {
    func fetchProducts(request: Home.Products.Request)
}

protocol HomeDataStore {
    //var name: String { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?

    func fetchProducts(request: Home.Products.Request) {
        worker = HomeWorker()
        worker?.requestProducts(request.page) { [weak self]
            response in
            
            switch response {
            case .success(let data):
                self?.presenter?.presentProducts(response: .init(model: data))
            case .failure(let error):
                print(error)
            }
        }
    }
}
