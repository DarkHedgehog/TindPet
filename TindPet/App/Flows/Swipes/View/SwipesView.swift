//
//  SwipesView.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 21.06.2023.
//

import UIKit

class SwipesView: UIView {
    // MARK: - Properties
    var presenter: SwipesPresenterProtocol? {
        didSet {
            swipeView.presenter = presenter
        }
    }
    
    lazy var swipeView: QuoteView = {
        let view = QuoteView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var dislikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.7, 1.7, 1.7)
        button.tintColor = .red
        button.backgroundColor = UIColor.systemGray4
        button.clipsToBounds = true
        button.layer.cornerRadius = 35
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 10.0
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(didTabDislikeButton), for: .touchUpInside)
        return button
    }()
    
   lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        button.tintColor = .green
        button.backgroundColor = UIColor.systemGray4
        button.clipsToBounds = true
        button.layer.cornerRadius = 35
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 10.0
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(didTabLikeButton), for: .touchUpInside)
        return button
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        return spinner
    }()
    
    lazy var loadingView: UIView = {
        let loadingView = UIView()
        return loadingView
    }()
    // MARK: - Functions
    @objc func didTabLikeButton() {
        presenter?.likeButtonAction()
    }
    
    @objc func didTabDislikeButton() {
        presenter?.dislikeButtonAction()
    }
    
    func showActivityIndicator() {
        self.loadingView = UIView()
        self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        self.loadingView.center = self.center
        self.loadingView.backgroundColor = UIColor.blue
        self.loadingView.alpha = 0.7
        self.loadingView.clipsToBounds = true
        self.loadingView.layer.cornerRadius = 10

        self.spinner = UIActivityIndicatorView(style: .large)
        self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)

        self.loadingView.addSubview(self.spinner)
        self.addSubview(self.loadingView)
        self.spinner.startAnimating()
    }

    func hideActivityIndicator() {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    // MARK: - SetUI
    func configureUI() {
        backgroundColor = .systemBackground
        addSubview(swipeView)
        addSubview(dislikeButton)
        addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            swipeView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            swipeView.leftAnchor.constraint(equalTo: leftAnchor),
            swipeView.rightAnchor.constraint(equalTo: rightAnchor),
            swipeView.heightAnchor.constraint(equalTo: swipeView.widthAnchor, multiplier: 7.0/5.0),
            
            dislikeButton.topAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: 20),
            dislikeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 60),
            dislikeButton.heightAnchor.constraint(equalToConstant: 70),
            dislikeButton.widthAnchor.constraint(equalToConstant: 70),
            
            likeButton.topAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: 20),
            likeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -60),
            likeButton.heightAnchor.constraint(equalToConstant: 70),
            likeButton.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
}
