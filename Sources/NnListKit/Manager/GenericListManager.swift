//
//  GenericListManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

public final class GenericListManager<Remote: NnListRemoteAPI, Modifier: NnListModifer> where Remote.Item == Modifier.Item {
    
    // MARK: - Properties
    private let policy: NnListPolicy
    private let alerts: NnListManagerAlerts
    private let remote: Remote
    private let modifier: Modifier
    
    public typealias Item = Remote.Item
    
    
    // MARK: - Init
    public init(policy: NnListPolicy,
                alerts: NnListManagerAlerts,
                remote: Remote,
                modifier: Modifier) {
        
        self.policy = policy
        self.alerts = alerts
        self.remote = remote
        self.modifier = modifier
    }
}


// MARK: - Manager
public extension GenericListManager {
    
    func addNew() {
        do {
            try policy.verifyCanAdd()

            modifier.addNew(completion: handleModResult())
        } catch {
            showError(error)
        }
    }
    
    func edit(_ item: Item) {
        do {
            try policy.verifyCanEdit()

            modifier.edit(item, completion: handleModResult())
        } catch {
            showError(error)
        }
    }
    
    func delete(_ item: Item) {
        do {
            try policy.verifyCanDelete()

            modifier.delete(item) { [weak self] newList in
                self?.upload(newList, deletedItem: item)
            }
        } catch {
            showError(error)
        }
    }
    
    func uploadReorderedList(_ list: [Item]) {
        upload(list)
    }
}


// MARK: - Private Methods
private extension GenericListManager {
    
    func handleModResult() -> (Result<[Item], Error>) -> Void {
        return { [weak self] result in
            switch result {
            case .success(let list):
                self?.upload(list)
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
    
    func upload(_ items: [Item],
                deletedItem: Item? = nil) {
        
        remote.upload(items,
                      deletedItem: deletedItem,
                      completion: handleError())
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
    func verifyCanDelete() throws
}

public protocol NnListManagerAlerts {
    func showError(_ error: Error)
}
