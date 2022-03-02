//
//  ListKitComposite.swift
//  
//
//  Created by Nikolai Nobadi on 2/25/22.
//

public final class ListKitComposite {
    private init() { }
    
}

// MARK: - Composer
public extension ListKitComposite {
    
    typealias ListKitAlerts = NnListManagerAlerts & NnListModifierAlerts
    
    static func makeManager<Remote: NnListRemoteAPI,
                        Factory: NnListItemFactory>(
                            remote: Remote,
                            factory: Factory,
                            policy: NnListPolicy,
                            alerts: ListKitAlerts,
                            validator: NnListNameValidator) -> NnListManager<Remote.Item> where Remote.Item == Factory.Item {

        let modifier = GenericListModifier(factory: factory,
                                           alerts: alerts,
                                           validator: validator)
        let manager = GenericListManager(policy: policy,
                                         alerts: alerts,
                                         remote: remote,
                                         modifier: modifier)

        return (addNew: manager.addNew,
                edit: manager.edit(_:),
                delete: manager.delete(_:),
                uploadReorderedList: manager.uploadReorderedList(_:))

    }
}
