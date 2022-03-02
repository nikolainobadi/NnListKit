//
//  NnListModifer.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

public protocol NnListModifer {
    associatedtype Item: NnListItem
    
    func addNew(completion: @escaping (Result<[Item], Error>) -> Void)
    func edit(_ item: Item,
              completion: @escaping (Result<[Item], Error>) -> Void)
    func delete(_ item: Item,
                completion: @escaping ([Item]) -> Void)
}
