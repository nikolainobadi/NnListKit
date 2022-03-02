//
//  GenericListModifier.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

public final class GenericListModifier<Factory: NnListItemFactory> {
    
    // MARK: - Properties
    private let factory: Factory
    private let alerts: NnListModifierAlerts
    private let validator: NnListNameValidator
    
    public typealias Item = Factory.Item
    
    private var items: [Item] { factory.itemList }
    
    
    // MARK: - Init
    public init(factory: Factory,
                alerts: NnListModifierAlerts,
                validator: NnListNameValidator) {
        
        self.factory = factory
        self.alerts = alerts
        self.validator = validator
    }
}


// MARK: - Modifier
extension GenericListModifier: NnListModifer {
    
    public func addNew(completion: @escaping (Result<[Factory.Item], Error>) -> Void) {
        
        alerts.showAddAlert { [weak self] name in
            self?.handleName(name, completion: completion)
        }
    }
    
    public func edit(_ item: Factory.Item,
                     completion: @escaping (Result<[Factory.Item], Error>) -> Void) {
        
        alerts.showEditAlert(item.name) { [weak self] newName in
            self?.handleName(newName,
                             oldItem: item,
                             completion: completion)
        }
    }
    
    public func delete(_ item: Factory.Item,
                       completion: @escaping ([Factory.Item]) -> Void) {
        
        alerts.showDeleteAlert(itemName: item.name) { [weak self] in
            
            self?.removeItemFromList(item, completion: completion)
        }
    }
}


// MARK: - Private Methods
private extension GenericListModifier {

    func handleName(_ name: String,
                    oldItem: Item? = nil,
                    completion: @escaping (Result<[Item], Error>) -> Void) {
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
//
    func changeNameOfItemInList(_ item: Item, name: String) throws -> [Item] {
        guard
            items.contains(where: { $0.id == item.id })
        else {
            throw NnListError.itemNotFound
        }

        return items.map {
            $0.id == item.id ? makeItem(id: item.id, name: name) : $0
        }
    }

    func makeItem(id: String? = nil, name: String) -> Item {
        factory.makeNewItem(id: id, name: name)
    }

    func removeItemFromList(_ item: Item,
                            completion: @escaping ([Item]) -> Void) {
        completion(
            items.filter { $0.id != item.id }
        )
    }
}


// MARK: - Dependencies
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
