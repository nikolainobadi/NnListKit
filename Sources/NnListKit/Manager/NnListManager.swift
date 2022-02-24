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
    private let remote: NnListRemoteAPI
    private let modifier: GenericListModifier<T>
    
    
    // MARK: - Init
    public init(policy: NnListPolicy,
                alerts: NnListManagerAlerts,
                remote: NnListRemoteAPI,
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
                self?.upload(newList, isDeleting: true)
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
    
    func upload(_ items: [T], isDeleting: Bool = false) {
        remote.upload(items, isDeleting: isDeleting) { [weak self] error in
            
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

public protocol NnListRemoteAPI {
    func upload<T: NnListItem>(_ list: [T],
                               isDeleting: Bool,
                               completion: @escaping (Error?) -> Void)
}

public protocol NnListManagerAlerts {
    func showError(_ error: Error)
}
