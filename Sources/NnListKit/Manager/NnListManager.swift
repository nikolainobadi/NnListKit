//
//  NnListManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

public final class NnListManager<T: NnListItem> {
    
    // MARK: - Properties
    private let policy: NnListPolicy
    private let alerts: NnListManagerAlerts
    private let remote: NnListRemoteAPI<T>
    private let modifier: GenericListModifier<T>
    
    
    // MARK: - Init
    public init(policy: NnListPolicy,
                alerts: NnListManagerAlerts,
                remote: NnListRemoteAPI<T>,
                modifier: GenericListModifier<T>) {
        
        self.policy = policy
        self.alerts = alerts
        self.remote = remote
        self.modifier = modifier
    }
}


// MARK: - Actions
public extension NnListManager {
    
    func addNew() {
        do {
            try policy.verifyCanAdd()
            
            modifier.addNew(completion: handleModResult())
        } catch {
            showError(error)
        }
    }
    
    func edit(_ item: T) {
        do {
            try policy.verifyCanEdit()
            
            modifier.edit(item, completion: handleModResult())
        } catch {
            showError(error)
        }
    }
    
    func delete(_ item: T) {
        do {
            try policy.verifyCanEdit()
            
            modifier.delete(item) { [weak self] newList in
                self?.upload(newList, deletedItem: item)
            }
        } catch {
            showError(error)
        }
    }
    
    func uploadReorderedList(_ list: [T]) {
        upload(list)
    }
}


// MARK: - Private Methods
private extension NnListManager {
    
    func handleModResult() -> (Result<[T], Error>) -> Void {
        return { [weak self] result in
            switch result {
            case .success(let list):
                self?.upload(list)
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
    
    func upload(_ items: [T], deletedItem: T? = nil) {
        if let deletedItem = deletedItem {
            remote.delete(items, deletedItem, handleError())
        } else {
            remote.upload(items, handleError())
        }
    }
    
    func handleError() -> ((Error?) -> Void) {
        return { [weak self] error in
            if let error = error {
                self?.showError(error)
            }
        }
    }
    
    func showError(_ error: Error) {
        alerts.showError(error)
    }
}


// MARK: - Dependencies
public protocol NnListPolicy {
    func verifyCanAdd() throws
    func verifyCanEdit() throws
}

public typealias NnListRemoteAPI<T: NnListItem> = (
    upload: ([T], @escaping (Error?) -> Void) -> Void,
    delete: ([T], T, @escaping (Error?) -> Void) -> Void
)

public protocol NnListManagerAlerts {
    func showError(_ error: Error)
}
