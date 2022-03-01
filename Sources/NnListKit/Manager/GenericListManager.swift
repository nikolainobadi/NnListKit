//
//  GenericListManager.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

public final class GenericListManager<Remote: NnListRemoteAPI> {
    
    // MARK: - Properties
    private let policy: NnListPolicy
    private let alerts: NnListManagerAlerts
    private let remote: Remote
    private let modifier: GenericListModifier<ListItem>
    
    public typealias ListItem = Remote.Item
    
    
    // MARK: - Init
    public init(policy: NnListPolicy,
                alerts: NnListManagerAlerts,
                remote: Remote,
                modifier: GenericListModifier<ListItem>) {
        
        self.policy = policy
        self.alerts = alerts
        self.remote = remote
        self.modifier = modifier
    }
}


// MARK: - Manager
extension GenericListManager: NnListManager {
    
    public func addNew() {
        do {
            try policy.verifyCanAdd()

            modifier.addNew(completion: handleModResult())
        } catch {
            showError(error)
        }
    }
    
    public func edit(_ item: Remote.Item) {
        do {
            try policy.verifyCanEdit()

            modifier.edit(item, completion: handleModResult())
        } catch {
            showError(error)
        }
    }
    
    public func delete(_ item: Remote.Item) {
        do {
            try policy.verifyCanEdit()

            modifier.delete(item) { [weak self] newList in
                self?.upload(newList, deletedItem: item)
            }
        } catch {
            showError(error)
        }
    }
    
    public func uploadReorderedList(_ list: [Remote.Item]) {
        upload(list)
    }
}


// MARK: - Private Methods
private extension GenericListManager {
    
    func handleModResult() -> (Result<[ListItem], Error>) -> Void {
        return { [weak self] result in
            switch result {
            case .success(let list):
                self?.upload(list)
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
    
    func upload(_ items: [ListItem],
                deletedItem: ListItem? = nil) {
        
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
}

public protocol NnListManagerAlerts {
    func showError(_ error: Error)
}
