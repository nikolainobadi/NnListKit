//
//  GenericListModifier.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

public final class GenericListModifier<T: NnListItem> {
    
    // MARK: - Properties
    private let cache: NnListItemCache
    private let factory: NnListItemFactory
    private let alerts: NnListModifierAlerts
    private let validator: NnListNameValidator
    
    private var items: [T] { cache.getItems() }
    
    
    // MARK: - Init
    public init(cache: NnListItemCache,
                factory: NnListItemFactory,
                alerts: NnListModifierAlerts,
                validator: NnListNameValidator) {
        
        self.cache = cache
        self.factory = factory
        self.alerts = alerts
        self.validator = validator
    }
}


// MARK: - Modifier
extension GenericListModifier: NnListModifer {
    
    public func addNew(completion: @escaping (Result<[T], Error>) -> Void) {
        
        alerts.showAddAlert { [weak self] name in
            self?.handleName(name, completion: completion)
        }
    }
    
    public func edit(_ item: T,
                     completion: @escaping (Result<[T], Error>) -> Void) {
    
        alerts.showEditAlert(item.name) { [weak self] newName in
            self?.handleName(newName,
                             oldItem: item,
                             completion: completion)
        }
    }
    
    public func delete(_ item: T,
                       completion: @escaping ([T]) -> Void) {
    
        alerts.showDeleteAlert(itemName: item.name) { [weak self] in
            self?.removeItemFromList(item, completion: completion)
        }
    }
}


// MARK: - Private Methods
private extension GenericListModifier {
    
    typealias Completion = (Result<[T], Error>) -> Void
    
    func handleName(_ name: String,
                    oldItem: T? = nil,
                    completion: @escaping Completion) {
        do {
            try validator.validateName(name)
            
            guard let oldItem = oldItem else {
                return completion(.success(
                    (items + [makeItem(name: name)])
                ))
            }
            
            let newList = try changeNameOfItemInList(oldItem,
                                                     name: name)
            completion(.success(newList))
        } catch {
            completion(.failure(error))
        }
    }
    
    func changeNameOfItemInList(_ item: T, name: String) throws -> [T] {
        guard
            items.contains(where: { $0.id == item.id })
        else {
            throw NnListError.itemNotFound
        }
        
        return items.map {
            $0.id == item.id ? makeItem(id: item.id, name: name) : $0
        }
    }
    
    func makeItem(id: T.ID? = nil, name: String) -> T {
        factory.makeNewItem(id: id, name: name)
    }
    
    func removeItemFromList(_ item: T,
                            completion: @escaping ([T]) -> Void) {
        completion(
            items.filter { $0.id != item.id }
        )
    }
}


// MARK: - Dependencies
public protocol NnListItemCache {
    func getItems<T: NnListItem>() -> [T]
}

public protocol NnListItemFactory {
    func makeNewItem<T: NnListItem>(id: T.ID?, name: String) -> T
}

public protocol NnListNameValidator {
    func validateName(_ name: String) throws
}

public protocol NnListModifierAlerts {
    func showAddAlert(completion: @escaping (String) -> Void)
    func showEditAlert(_ oldName: String,
                       completion: @escaping (String) -> Void)
    func showDeleteAlert(itemName name: String,
                         completion: @escaping () -> Void)
}
