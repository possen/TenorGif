//
//  TubiCollectionAdaptor.swift
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit

protocol CollectionViewDataManagerDelegate : class {
    func update()
}

protocol CollectionSectionAdaptor {
    var cellReuseIdentifier: String { get }
    var title: String { get }
    var height : CGFloat { get }
    var itemCount : Int { get }
    func configure(cell: UICollectionViewCell, index: Int)
}

class CollectionViewAdaptorSection<Cell, Model>: CollectionSectionAdaptor {
    internal let cellReuseIdentifier: String
    internal let title: String
    internal let height: CGFloat
    internal var items: [Model]
    
    init(cellReuseIdentifier: String,
         title: String,
         height: CGFloat,
         items: [Model],
         configure: @escaping ( Cell, Model, Int ) -> Void)
    {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.title = title
        self.height = height
        self.items = items
        self.configure = configure
    }
    
    internal var itemCount: Int {
        return items.count
    }
    
    internal func configure(cell: UICollectionViewCell, index: Int) {
        configure(cell as! Cell, items[index], index)
    }
    
    internal var configure: ( Cell, Model, Int ) -> Void
}


class CollectionViewAdaptor: NSObject,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    CollectionViewDataManagerDelegate {
    
    public var headerHeight : CGFloat = 20.0
    public var footerHeight : CGFloat = 20.0
    private let collectionView: UICollectionView
    private let didChangeHandler: () -> Void
    public var sections : [CollectionSectionAdaptor]
    
    init(collectionView: UICollectionView,
         sections: [CollectionSectionAdaptor],
         didChangeHandler: @escaping () -> Void)
    {
        self.collectionView = collectionView
        self.didChangeHandler = didChangeHandler
        self.sections = sections
        super.init()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        return section.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:section.cellReuseIdentifier, for: indexPath)
        section.configure(cell: cell, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].itemCount != 0 ? headerHeight : 0.01
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].itemCount != 0 ? footerHeight : 0.01
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].height
    }
    
    public func update() {
        DispatchQueue.main.async {
            self.didChangeHandler()
        }
    }
}
