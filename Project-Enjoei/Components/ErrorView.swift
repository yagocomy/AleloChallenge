import UIKit


protocol ErrorViewDelegate: AnyObject {
    func cleanButton()
}
class ErrorView: UIView {
    
    weak var delegate: ErrorViewDelegate?
    
    lazy var emptyResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ué, não encontramos \nnadinha"
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32.0)
        return label
    }()
    
    lazy var reTryFromStartLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "que tal recomeçar do começo?"
        label.backgroundColor = .white
        return label
    }()
    
     lazy var cleanSearchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("limpar busca", for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
         button.addTarget(self, action: #selector(cleanButton), for: .touchUpInside)
        if let titleLabel = button.titleLabel {
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "NoResults")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(emptyResultLabel)
        addSubview(reTryFromStartLabel)
        addSubview(cleanSearchButton)
        addSubview(imageView)
        setupConstraints()
    }
    
    @objc
    func cleanButton() {
        delegate?.cleanButton()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            emptyResultLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 38),
            emptyResultLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            emptyResultLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            reTryFromStartLabel.topAnchor.constraint(equalTo: emptyResultLabel.bottomAnchor, constant: 22),
            reTryFromStartLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            reTryFromStartLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            cleanSearchButton.topAnchor.constraint(equalTo: reTryFromStartLabel.bottomAnchor, constant: 43),
            cleanSearchButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            cleanSearchButton.widthAnchor.constraint(equalToConstant: 140),
            cleanSearchButton.heightAnchor.constraint(equalToConstant: 48),
            
            imageView.topAnchor.constraint(equalTo: cleanSearchButton.bottomAnchor, constant: 60),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }
}
