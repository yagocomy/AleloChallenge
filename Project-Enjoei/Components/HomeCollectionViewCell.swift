import UIKit.UICollectionViewCell

final class HomeCollectionViewCell: UICollectionViewCell {
    static var identifier = String(describing: HomeCollectionViewCell.self)
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var discountView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.purplePromo
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var priceView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whitePrice
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.whitePrice
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceOffLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.purplePromo
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.greyDiscount
        label.font = UIFont.systemFont(ofSize: 12)
        label.strikeThrough(true)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackViewPrices: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(priceOffLabel)
        stackView.addArrangedSubview(priceLabel)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        discountView.addSubview(discountLabel)
        priceView.addSubview(stackViewPrices)
        
        backgroundImageView.addSubview(discountView)
        backgroundImageView.addSubview(priceView)
        
        addSubview(backgroundImageView)
        
        setupContraints()
    }
    
    private func setupContraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            discountView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 5),
            discountView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -5),
            
            discountLabel.topAnchor.constraint(equalTo: discountView.topAnchor, constant: 5),
            discountLabel.leadingAnchor.constraint(equalTo: discountView.leadingAnchor, constant: 5),
            discountLabel.bottomAnchor.constraint(equalTo: discountView.bottomAnchor, constant: -5),
            discountLabel.trailingAnchor.constraint(equalTo: discountView.trailingAnchor, constant: -5),
            
            priceView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 5),
            priceView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -5),
            
            stackViewPrices.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 5),
            stackViewPrices.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 5),
            stackViewPrices.bottomAnchor.constraint(equalTo: priceView.bottomAnchor, constant: -5),
            stackViewPrices.trailingAnchor.constraint(equalTo: priceView.trailingAnchor, constant: -5),
        ])
    }

    func cellData(_ image: UIImage, listed: Double?, sale: Double?) {
        if listed == nil {
            discountView.isHidden = true
        } else {
            discountView.isHidden = false
        }
        
        if sale == nil {
            priceLabel.isHidden = true
        } else {
            priceLabel.isHidden = false
        }
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "R$ \(sale ?? 0.0)")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))

        backgroundImageView.image = image
        discountLabel.text = "\((Int(listed ?? 0.0) * 100) / Int(sale ?? 0.0))% off"
        priceOffLabel.text = "R$ \(listed ?? 0.0)"
        priceLabel.attributedText = attributeString
    }
}
