//
//  NnListManager.swift
//  
//
//  Created by Nikolai Nobadi on 3/1/22.
//

public protocol NnListManager {
    associatedtype Remote: NnListRemoteAPI
    
    func addNew()
    func edit(_ item: Remote.Item)
    func delete(_ item: Remote.Item)
    func uploadReorderedList(_ list: [Remote.Item])
}
