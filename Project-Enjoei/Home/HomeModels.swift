import UIKit

enum Home {
    // MARK: Use cases
    
    enum Products {
        struct Request {
            let page: Int
        }
        
        struct Response {
            let model: ProductsModel
        }
        
        struct ViewModel {
            let model: ProductsModel
        }
    }
    
}
