import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayProducts(viewModel: Home.Products.ViewModel)
}

class HomeViewController: UIViewController {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    var customView: HomeViewDisplayLogic?
    
    var currentPage = 1
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        
        view = HomeView(delegate: self)
        customView = view as? HomeViewDisplayLogic
    }
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    // MARK: Routing
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchProducts(request: .init(page: currentPage))
        currentPage += 1
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
        
        
    }
}

extension HomeViewController: HomeDisplayLogic {
    func displayProducts(viewModel: Home.Products.ViewModel) {
        customView?.displayProducts(by: .init(model: viewModel.model))
    }
}

extension HomeViewController: HomeViewDelegate {
    func requestData() {
        interactor?.fetchProducts(request: .init(page: currentPage))
        currentPage += 1
    }
}
