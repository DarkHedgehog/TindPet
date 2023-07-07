//
//  GradientView.swift
//  TindPet
//
//  Created by Артур Кондратьев on 03.07.2023.
//

import UIKit

class GradientView: UIView {
    // MARK: - Properties
    let topColor = UIColor.topGradientColor
    let bottomColor = UIColor.buttomGradientColor
    let gradientLayer = CAGradientLayer()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - UI
    private func commonInit() {
        gradientLayer.colors = [bottomColor.cgColor, topColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)

        layer.addSublayer(gradientLayer)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        if gradientLayer.frame != bounds {
            gradientLayer.frame = bounds
        }
    }
}
