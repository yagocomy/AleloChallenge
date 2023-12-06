import UIKit

protocol HeaderReusableViewDelegate: AnyObject {
    func searchData(_ searchText: String)
}

class HomeHeaderView: UIView {
    
    static let identifier = String(describing: HomeHeaderView.self)
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "enjoei-icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var imageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var clearButtonSearchBar: UIButton = {
        let button = UIButton()
        button.setTitle("limpar busca", for: .normal)
        button.setTitleColor(.purplePromo, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(didTapClearButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var searchBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.addArrangedSubview(textSearchBar)
        stackView.addArrangedSubview(clearButtonSearchBar)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(searchBarStackView)
        return stackView
    }()
    
    weak var delegate: HeaderReusableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .white
        clearButtonSearchBar.isHidden = true
        imageView.addSubview(iconImageView)
        addSubview(contentStackView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            iconImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
//
//            searchBarStackView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 5),
//            searchBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
//            searchBarStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            searchBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)

            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapClearButton(_ sender: UIButton) {
        textSearchBar.text = ""
        delegate?.searchData(textSearchBar.text!)
        clearButtonSearchBar.isHidden = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSearchTextField()
    }
    
    private func setupSearchTextField() {
        let searchTextField = textSearchBar.searchTextField
        searchTextField.backgroundColor = .white
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 8
        
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .gray
        searchTextField.leftView = nil
        searchTextField.rightView = imageView
        searchTextField.rightViewMode = UITextField.ViewMode.always
    }
}

extension HomeHeaderView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            UIView.transition(with: clearButtonSearchBar, duration: 0.3, options: .curveEaseInOut, animations: {
                self.clearButtonSearchBar.isHidden = true
            }) { _ in
                self.clearButtonSearchBar.alpha = 0
            }
        } else {
            UIView.transition(with: clearButtonSearchBar, duration: 0.3, options: .curveEaseOut, animations: {
                self.clearButtonSearchBar.alpha = 1
            }) { _ in
                self.clearButtonSearchBar.isHidden = false
            }
        }
        
        delegate?.searchData(searchText)
    }
}
