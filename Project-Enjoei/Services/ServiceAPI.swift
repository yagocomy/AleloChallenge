import Foundation
import UIKit.UIImage
import Alamofire

enum ServiceURL {
    case endpoint(_ page: Int)
    case endpointImage(slug: String, identifier: Int, publicId: String)
}

extension ServiceURL {
    var path: String {
        switch self {
        case .endpoint(let page):
            return "https://www.enjoei.com.br/api/v5/users/enjoei-pro/products/liked?page=\(page)"
        case .endpointImage(let slug, let identifier, let publicId):
            return "https://photos.enjoei.com.br/\(slug)-\(identifier)/1200xN/\(publicId)"
            
        }
    }
}

final class ServiceAPI {
    func fetchData<T: Codable>(_ endpoint: ServiceURL, 
                               dataType: T.Type,
                               completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(
            endpoint.path,
            method: .get,
            parameters: .none,
            requestModifier: {
                urlRequest in
                urlRequest.timeoutInterval = 15
                urlRequest.allowsConstrainedNetworkAccess = false
            })
        .responseDecodable(of: T.self) {
            response in
            
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class ServiceImageDownload {
    static var shared = ServiceImageDownload()
    
    private init() { }
    
    func downloadImage(_ endpoint: ServiceURL, imageResponse: @escaping (UIImage) -> Void) {
        let url = endpoint.path
        AF.download(url, requestModifier: {
            urlRequest in
            
            urlRequest.timeoutInterval = 15
        })
        .downloadProgress {
            progress in
            
        }
        .responseData { response in
            if let data = response.value {
                imageResponse(UIImage(data: data)!)
            } else {
                imageResponse(UIImage(named: "img")!)
            }
        }
    }
}
