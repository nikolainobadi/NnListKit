//
//  ListKitComposite.swift
//  
//
//  Created by Nikolai Nobadi on 2/25/22.
//

public final class ListKitComposite { }


// MARK: - Composer
public extension ListKitComposite {
    
//    static func makeManager<T>(cache: NnListItemCache,
//                               factory: NnListItemFactory,
//                               policy: NnListPolicy,
//                               alerts: ListKitAlerts,
//                               remote: ooldNnListRemoteAPI<T>,
//                               validator: NnListNameValidator) -> GenericListManager<T> where T: NnListItem {
//        
//        let modifier = GenericListModifier<T>(
//            cache: cache,
//            factory: factory,
//            alerts: alerts,
//            validator: validator)
//        
//        return GenericListManager<T>(policy: policy,
//                                alerts: alerts,
//                                remote: remote,
//                                modifier: modifier)
//    }
}


// MARK: - Typealiases
public extension ListKitComposite {
    
    typealias ListKitAlerts = NnListManagerAlerts & NnListModifierAlerts
    typealias UploadCompletion<T: NnListItem> = ([T], @escaping (Error?) -> Void) -> Void
    typealias DeleteCompletion<T: NnListItem> = ([T], T, @escaping (Error?) -> Void) -> Void
}
