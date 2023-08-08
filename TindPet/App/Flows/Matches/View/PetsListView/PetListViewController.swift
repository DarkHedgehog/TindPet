//
//  PetListViewController1CollectionViewController.swift
//  TindPet
//
//  Created by Aleksandr Derevenskih on 07.08.2023.
//

import UIKit

protocol PetListDelegate: AnyObject {
    func onPetSelected(value: PetInfo)
}

final class PetListViewController: UICollectionViewController {
    var delegate: PetListDelegate?
    private let layout = UICollectionViewFlowLayout()
    private var values: [PetInfo] = []

    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: Constants.reuseIdentifier)
    }

    public func reloadData(_ values: [PetInfo]) {
        self.values = values
        collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.reuseIdentifier,
            for: indexPath
        ) as? PetCollectionViewCell else {
            preconditionFailure("Error cast to PetCollectionViewCell")
        }
        let model = PetInfoModel(values[indexPath.row])
        cell.setPetModel(pet: model)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("select at \(indexPath.row)")
        delegate?.onPetSelected(value: values[indexPath.row])
    }
    
    enum Constants {
        static let reuseIdentifier = "PetListCell"
    }
}

extension PetListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
