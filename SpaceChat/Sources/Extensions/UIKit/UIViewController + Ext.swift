//
//  UIViewController + Ext.swift
//  SpaceChat
//
//  Created by User on 26.10.2022.
//

import Foundation
import UIKit

extension UIViewController {

    func configure<T: SelfConfiguringCell, U: Hashable>(collection: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else { fatalError("Unable to dequeue \(cellType)")}
        cell.configure(with: value)
        return cell
    }

}
