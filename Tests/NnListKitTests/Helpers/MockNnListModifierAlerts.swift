//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

import NnListKit

final class MockNnListModifierAlerts: NnListModifierAlerts {
    
    private var name = ""
    
    init(_ name: String = "") {
        self.name = name
    }
    
    func showAddAlert(completion: @escaping (String) -> Void) {
        
        completion(name)
    }
    
    func showEditAlert(_ oldName: String,
                       completion: @escaping (String) -> Void) {
        completion(name)
    }
    
    func showDeleteAlert(itemName name: String,
                         completion: @escaping () -> Void) {
        completion()
    }
}
