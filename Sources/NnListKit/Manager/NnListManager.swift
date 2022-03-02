//
//  NnListManager.swift
//  
//
//  Created by Nikolai Nobadi on 3/1/22.
//

public typealias NnListManager<Item: NnListItem> = (
    addNew: () -> Void,
    edit: (Item) -> Void,
    delete: (Item) -> Void,
    uploadReorderedList: ([Item]) -> Void
)
