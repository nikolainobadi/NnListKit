//
//  ListKitComposite.swift
//  
//
//  Created by Nikolai Nobadi on 2/25/22.
//

public final class ListKitComposite { }


// MARK: - Composer
public extension ListKitComposite {
    
    static func makeManager<T>(cache: NnListItemCache,
                               factory: NnListItemFactory,
                               policy: NnListPolicy,
                               alerts: ListKitAlerts,
                               remote: NnListRemoteAPI<T>,
                               validator: NnListNameValidator) -> NnListManager<T> where T: NnListItem {
        
        let modifier = GenericListModifier<T>(
            cache: cache,
            factory: factory,
            alerts: alerts,
            validator: validator)
        
        return NnListManager<T>(policy: policy,
                                alerts: alerts,
                                remote: remote,
                                modifier: modifier)
    }
    
    static func makeRemote<T: NnListItem>(
        upload: @escaping UploadCompletion<T>,
        delete: @escaping DeleteCompletion<T>) -> NnListRemoteAPI<T> {

        (upload: upload, delete: delete)
    }
}


// MARK: - Typealiases
public extension ListKitComposite {
    
    typealias ListKitAlerts = NnListManagerAlerts & NnListModifierAlerts
    typealias UploadCompletion<T: NnListItem> = ([T], @escaping (Error?) -> Void) -> Void
    typealias DeleteCompletion<T: NnListItem> = ([T], T, @escaping (Error?) -> Void) -> Void
}
