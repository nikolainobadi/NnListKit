//
//  NnListModifer.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

public protocol NnListModifer {
    associatedtype T: NnListItem
    
    func addNew(completion: @escaping (Result<[T], Error>) -> Void)
    func edit(_ item: T,
              completion: @escaping (Result<[T], Error>) -> Void)
    func delete(_ item: T,
                completion: @escaping ([T]) -> Void)
}
