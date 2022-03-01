//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 3/1/22.
//

public protocol NnListRemoteAPI {
    associatedtype Item: NnListItem
    
    func upload(_ list: [Item],
                deletedItem: Item?,
                completion: @escaping (Error?) -> Void)
}
