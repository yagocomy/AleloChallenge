import UIKit

class HomeWorker {
    private let serviceAPI = ServiceAPI()
    
    func requestProducts(_ page: Int, completion: @escaping (Result<ProductsModel, Error>) -> Void) {
        serviceAPI.fetchData(.endpoint(page), dataType: ProductsModel.self) {
            response in
            
            switch response {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
