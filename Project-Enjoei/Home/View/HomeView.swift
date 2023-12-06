import UIKit

protocol HomeViewDisplayLogic: AnyObject {
    func displayProducts(by model: Home.Products.ViewModel)
}

protocol HomeViewDelegate: AnyObject {
    func requestData()
}

final class HomeView: UIView {
    private lazy var homeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.register(HomeCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.collectionViewLayout = generateLayout()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var homeHeader: HomeHeaderView = {
        let header = HomeHeaderView()
        header.delegate = self
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    private lazy var homeStackView: UIStackView = {
        let scrollView = UIStackView()
        scrollView.axis = .vertical
        scrollView.addArrangedSubview(homeCollectionView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var productsData: [ProductsModel] = []
    private var filterProductsData: [[Product]] = []
    private var sectionIndex = 0
    private var filterSectionIndex = 0
    private var hideHeader = false
    private var isSearchActive = false
    private var isScrolling = false
    private var numberOfIndex = 0
    private var isLoading = false
    
    var products: ProductsModel? = nil {
        didSet {
            productsData.append(products!)
            homeCollectionView.reloadData()
        }
    }
    
    weak var delegate: HomeViewDelegate?
    
    
    init(delegate: HomeViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        errorView.isHidden = true
        
        addSubview(homeHeader)
        addSubview(homeStackView)
        setupContraints()
    }
    
    private func setupContraints() {
        NSLayoutConstraint.activate([
            homeHeader.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            homeHeader.leadingAnchor.constraint(equalTo: leadingAnchor),
            homeHeader.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            homeStackView.topAnchor.constraint(equalTo: homeHeader.bottomAnchor),
            homeStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            homeStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            homeStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalWidth(0.4))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: fullPhotoItem,
            count: 2)
        
        group.interItemSpacing = .fixed(30)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 40, bottom: 5, trailing: 5)
        
        let layoutHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .estimated(60)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        layoutHeader.pinToVisibleBounds = true
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [layoutHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension HomeView: HomeViewDisplayLogic {
    func displayProducts(by model: Home.Products.ViewModel) {
        products = model.model
    }
}

extension HomeView: UICollectionViewDelegate,
                    UICollectionViewDataSource,
                    UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if isSearchActive {
            if filterProductsData.isEmpty {
                filterSectionIndex = 0
                return 0
            } else {
                filterSectionIndex = section
                return filterProductsData[filterSectionIndex].count
            }
        } else {
            if productsData.isEmpty {
                return 0
            } else {
                sectionIndex = section
                return productsData[section].products.count
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isSearchActive {
            return 1
        } else {
            return productsData.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier,
                                                      for: indexPath) as! HomeCollectionViewCell
        
        if isSearchActive {
            guard !filterProductsData.isEmpty, numberOfIndex != 0 else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                              for: indexPath)
                return cell
            }
            
            ServiceImageDownload.shared.downloadImage(.endpointImage(slug: filterProductsData[filterSectionIndex][indexPath.row].slug ,
                                                                     identifier: filterProductsData[filterSectionIndex][indexPath.row].id,
                                                                     publicId: filterProductsData[filterSectionIndex][indexPath.row].imagePublicID)) {
                [weak self]
                result in
                
                if self!.filterProductsData.isEmpty {
                    return
                }
                
                cell.cellData(result,
                              listed: self?.filterProductsData[self!.filterSectionIndex][indexPath.row].price.sale ?? 0.0,
                              sale: self?.filterProductsData[self!.filterSectionIndex][indexPath.row].price.listed ?? 0.0)
            }
        }
        else {
            ServiceImageDownload.shared.downloadImage(.endpointImage(slug: productsData[sectionIndex].products[indexPath.row].slug ,
                                                                     identifier: productsData[sectionIndex].products[indexPath.row].id ,
                                                                     publicId: productsData[sectionIndex].products[indexPath.row].imagePublicID )) {
                [weak self]
                result in
                
                cell.cellData(result,
                              listed: self?.productsData[self!.sectionIndex].products[indexPath.row].price.sale ?? 0.0,
                              sale: self?.productsData[self!.sectionIndex].products[indexPath.row].price.listed ?? 0.0)
            }
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            print("End reached")
            if !isSearchActive {
                UIView.transition(with: homeHeader.textSearchBar, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.homeHeader.textSearchBar.isHidden = false
                }) { _ in
                    self.homeHeader.textSearchBar.alpha = 1
                }
                
                delegate?.requestData()
            }
        }
        
        if scrollView.contentOffset.y <= 0 {
            
        }
        
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            
        }
        
        UIView.transition(with: homeHeader.textSearchBar, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.homeHeader.textSearchBar.isHidden = false
        }) { _ in
            self.homeHeader.textSearchBar.alpha = 1
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.transition(with: homeHeader.textSearchBar, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.homeHeader.textSearchBar.isHidden = true
        }) { _ in
            self.homeHeader.textSearchBar.alpha = 0
        }
    }
}

extension HomeView: HeaderReusableViewDelegate {
    func searchData(_ searchText: String) {
        if searchText.isEmpty {
            homeCollectionView.restoreBackgroundView()
            isSearchActive = false
            numberOfIndex = 0
            filterProductsData = []
            
            DispatchQueue.main.async {
                self.homeCollectionView.reloadData()
            }
            
            return
        }
        
        isSearchActive = true
        filterProductsData = []
        
        let filtered = productsData.compactMap {
            $0.products.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
        
        for filteredData in filtered {
            if !filteredData.isEmpty {
                numberOfIndex += 1
                filterProductsData.append(filteredData)
            }
        }
        
        if filterProductsData.isEmpty {
            DispatchQueue.main.async {
                self.homeCollectionView.reloadData()
            }
            numberOfIndex = 0
            homeCollectionView.setEmptyMessage("Nenhum dado encontrado", UIImage(systemName: "figure.wave")!)
        } else {
            homeCollectionView.restoreBackgroundView()
            DispatchQueue.main.async {
                self.homeCollectionView.reloadData()
            }
        }
    }
}


extension UILabel {
    func strikeThrough(_ isStrikeThrough:Bool) {
        if isStrikeThrough {
            if let lblText = self.text {
                let attributeString =  NSMutableAttributedString(string: lblText)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
                self.attributedText = attributeString
            }
        } else {
            if let attributedStringText = self.attributedText {
                let txt = attributedStringText.string
                self.attributedText = nil
                self.text = txt
                return
            }
        }
    }
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String,_ img:UIImage) {
        
        var errorView = ErrorView()
        errorView.delegate = self
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainView = UIView()
        mainView.addSubview(errorView)
      
        errorView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        errorView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        errorView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        errorView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        
        self.backgroundView = mainView
    }
    
    func restoreBackgroundView() {
        self.backgroundView = nil
    }
}

extension UICollectionView: ErrorViewDelegate {
  
    func cleanButton() {
        restoreBackgroundView()
        
    }
}
