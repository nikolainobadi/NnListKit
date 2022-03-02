//
//  NnListItemFactory.swift
//  
//
//  Created by Nikolai Nobadi on 3/1/22.
//

public protocol NnListItemFactory {
    associatedtype Item: NnListItem
    
    var itemList: [Item] { get }
    
    func makeNewItem(id: String?, name: String) -> Item
}
