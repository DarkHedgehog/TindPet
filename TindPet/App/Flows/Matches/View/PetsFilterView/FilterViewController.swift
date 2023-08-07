//
//  PetsFilterViewViewController.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 07.08.2023.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func onFilterChanged(value: Int)
}

class FilterViewController: UIViewController {
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [])
        let attributes =
        [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        segmentControl.setTitleTextAttributes(attributes, for: .normal)
        segmentControl.selectedSegmentTintColor = .topGradientColor
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false

        return segmentControl
    }()

    var delegate: FilterViewControllerDelegate?

    init(values: [String]) {
        super.init(nibName: nil, bundle: nil)
        setFilterButtons(values)
        segmentControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func setFilterButtons(_ values: [String]) {
        segmentControl.removeAllSegments()
        values.forEach {
            segmentControl.insertSegment(withTitle: $0, at: segmentControl.numberOfSegments, animated: false)
        }
        segmentControl.selectedSegmentIndex = 0
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(segmentControl)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: safeArea.topAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            segmentControl.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    @objc private func segmentValueChanged(sender: UISegmentedControl) {
        delegate?.onFilterChanged(value: sender.selectedSegmentIndex)
    }

    enum Constants {
        static let segmentControlHeight: CGFloat = 28
    }
}

extension FilterViewController: PetFilterProtocol {
    func selectedFilterIndex() -> Int {
        return segmentControl.selectedSegmentIndex
    }
}
