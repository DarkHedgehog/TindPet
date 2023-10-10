//
//  QuoteView.swift
//  TindPet
//
//  Created by Алексей on 18.07.2023.
//

import UIKit

class QuoteView: UIView {
    var didRate: (() -> Void)?
    var presenter: SwipesPresenterProtocol?
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 3
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.systemGray6
        label.textAlignment = .justified
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    let thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.alpha = 0
        imageView.image = UIImage(systemName: "hand.thumbsup.fill")
        imageView.tintColor = UIColor.green
        return imageView
    }()

    lazy var petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.alpha = 1
        imageView.layer.cornerRadius = 20
        imageView.tintColor = UIColor.green
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        return spinner
    }()
    
    lazy var loadingView: UIView = {
        let loadingView = UIView()
        return loadingView
    }()

    private var animator: UIViewPropertyAnimator?
    private var like = true
    // MARK: - Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if animator == nil {
            thumbImageView.frame = bounds.insetBy(dx: 20, dy: 10)
            petImageView.frame = bounds.insetBy(dx: 20, dy: 10)
        }
    }
    private func setup() {
        addSubview(petImageView)
        petImageView.addSubview(label)
        addSubview(thumbImageView)

        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: petImageView.bottomAnchor, constant: -10),
            label.leftAnchor.constraint(equalTo: petImageView.leftAnchor, constant: 10),
            label.rightAnchor.constraint(equalTo: petImageView.rightAnchor, constant: -10)
        ])

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        self.addGestureRecognizer(panRecognizer)
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
        self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y: self.loadingView.bounds.size.height / 2)

        self.loadingView.addSubview(self.spinner)
        self.addSubview(self.loadingView)
        self.spinner.startAnimating()
    }

    func hideActivityIndicator() {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
    }

    enum Constants {
        static let likeHandImage = UIImage(systemName: "hand.thumbsup.fill")
        static let dislikeHandImage = UIImage(systemName: "hand.thumbsdown.fill")
        static let likeHandColor = UIColor.systemGreen
        static let dislikeHandColor = UIColor.systemRed
    }
}


extension QuoteView {
    @objc private func swipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            thumbImageView.frame.origin.x -= 100
            thumbImageView.tintColor = Constants.dislikeHandColor
            thumbImageView.image = Constants.dislikeHandImage
            thumbImageView.alpha = 1

            petImageView.frame.origin.x -= 100
            petImageView.alpha = 0

        case .right:
            thumbImageView.frame.origin.x += 100
            thumbImageView.tintColor = Constants.likeHandColor
            thumbImageView.image = Constants.likeHandImage
            thumbImageView.alpha = 1

            petImageView.frame.origin.x -= 100
            petImageView.alpha = 0
        default:
            break
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.thumbImageView.frame = self.bounds
            self.thumbImageView.image = nil
            self.thumbImageView.alpha = 0
            self.didRate?()
        }
    }

    @objc private func pan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self).x
        switch sender.state {
        case .began:
            like = translation > 0

            let endX = like ? 3 * bounds.width / 2 + 50: -bounds.width / 2 - 50
            let angle = like ? CGFloat.pi / 4 : -CGFloat.pi / 4

            thumbImageView.image = like ? Constants.likeHandImage : Constants.dislikeHandImage
            thumbImageView.tintColor = like ? Constants.likeHandColor : Constants.dislikeHandColor

            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
                [self.thumbImageView, self.petImageView].forEach {
                    $0.center = CGPoint(x: endX, y: self.bounds.height / 2)
                    $0.transform = CGAffineTransform(rotationAngle: angle)
                }
                self.thumbImageView.alpha = 1
                self.petImageView.alpha = 0
            }

            animator?.addCompletion { [weak self] _ in
                guard let self = self, let animator = animator else { return }

                [self.thumbImageView, self.petImageView].forEach {
                    $0.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
                    $0.transform = .identity
                }
                self.thumbImageView.alpha = 0
                self.petImageView.alpha = 1

                self.didRate?()

                if !animator.isReversed {
                    self.alpha = 0
                    UIView.animate(withDuration: 0.5) {
                        self.alpha = 1
                    }
                    if like {
                        self.presenter?.likeButtonAction()
                    } else {
                        self.presenter?.dislikeButtonAction()
                    }
                }
            }

        case .changed:
            let slide = like ? max(translation, 0) : min(translation, 0)
            animator?.fractionComplete = abs(slide) / bounds.width
        case .ended:
            let edge = 100.0
            if (like && translation >= edge) || (!like && translation <= -edge) {
                animator?.startAnimation()
            } else {
                animator?.isReversed = true
                animator?.startAnimation()
            }
        default:
            break
        }
    }
}
