import Foundation

// MARK: - Products
struct ProductsModel: Codable {
    var products: [Product]
    let pagination: Pagination
    let title: String
    let emptyState: EmptyState

    enum CodingKeys: String, CodingKey {
        case products, pagination, title
        case emptyState = "empty_state"
    }
}

// MARK: - EmptyState
struct EmptyState: Codable {
    let icon, title, subtitle: String
}

// MARK: - Pagination
struct Pagination: Codable {
    let totalEntries, pageSize, currentPage, prevPage: Int?
    let nextPage: Int?

    enum CodingKeys: String, CodingKey {
        case totalEntries = "total_entries"
        case pageSize = "page_size"
        case currentPage = "current_page"
        case prevPage = "prev_page"
        case nextPage = "next_page"
    }
}

// MARK: - Product
struct Product: Codable {
    let context: Context
    let id: Int
    let imagePublicID, title, slug: String
    let price: Price

    enum CodingKeys: String, CodingKey {
        case context, id
        case imagePublicID = "image_public_id"
        case title, slug, price
    }
}

enum Context: String, Codable {
    case lojaYeyezadosProduto = "loja_yeyezados_produto"
}

// MARK: - Price
struct Price: Codable {
    var listed: Double? = nil
    var sale: Double? = nil
}

// MARK: - Encode/decode helpers

