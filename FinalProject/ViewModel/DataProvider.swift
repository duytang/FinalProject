//
//  DataProvider.swift
//  ATMCard
//
//  Created by Kieu Nhi on 5/17/17.
//  Copyright © 2017 Kieu Nhi. All rights reserved.
//

import UIKit

protocol TableViewProvider {
    func numberOfRow(inSection section: Int) -> Int
    func heighForRow(atIndexPath indexPath: IndexPath) -> CGFloat
}

protocol CollectionViewProvider {
    func numberOfItem() -> Int
    func sizeForItem(atIndexPath indexPath: IndexPath) -> CGSize
}

protocol BaseControllerModelView: class {
    var title: String { get }
    var messageError: Dynamic<String> { get set }
    var isLoading: Dynamic<Bool> { get set }

}
