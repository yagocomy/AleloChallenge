import UIKit.UICollectionViewCell

final class HomeCollectionViewCellError: UICollectionViewCell {
    static var identifier = String(describing: HomeCollectionViewCellError.self)
    
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "figure.wave"))
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(errorImageView)
        setupConstraits()
    }
    
    func setupConstraits() {
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            errorImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}

