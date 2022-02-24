//
//  TestItem.swift
//  
//
//  Created by Nikolai Nobadi on 2/23/22.
//

import NnListKit

struct TestItem: NnListItem {
    var id: String = ""
    var name: String = ""
}

enum TestError: Error {
    case addError
    case editError
    case deleteError
    case addModError
    case editModError
    case remoteError
}
