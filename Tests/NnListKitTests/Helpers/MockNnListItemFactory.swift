//
//  MockNnListItemFactory.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

import NnListKit

final class MockNnListItemFactory: NnListItemFactory {

    func makeNewItem<T>(id: T.ID?, name: String) -> T where T: NnListItem {

        let id = id as? String ?? "NewTestId"

        return TestItem(id: id, name: name) as! T
    }
}
