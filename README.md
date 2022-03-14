# NnListKit

My attempt to use generics in order to help automate modifications (add/edit/delete) to a list of named items. 

The sequence handled by this package is as follows:

1. Verify client has permission to modify the list.

2. Present an alert to either request input (item name) or verify a delete.

3. If input is requested, validate the input.

4. Perform the modification to the list.

5. Request the new list to be saved/uploaded.


## ListKitComposite

`static func makeManager()`

This class only has the above method which will request all necessary dependencies create the NnListManager.


## NnListManager

The typealias returned from ListKitComposite that contains the list modifying functions. The associated type Item must conform to NnListItem.

`addNew: () -> Void`

`edit: (Item) -> Void`

`delete: (Item) -> Void`
    
`uploadReorderedList: ([Item]) -> Void`


## NnListItem

A simple protocol that only requires an id: String and a name: String. 
