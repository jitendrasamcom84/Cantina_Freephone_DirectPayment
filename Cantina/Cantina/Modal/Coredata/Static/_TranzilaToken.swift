// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TranzilaToken.swift instead.

import Foundation
import CoreData

public enum TranzilaTokenAttributes: String {
    case card = "card"
    case dateAdded = "dateAdded"
    case entity_id = "entity_id"
    case expdate = "expdate"
    case is_save_card = "is_save_card"
    case token = "token"
}

open class _TranzilaToken: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "TranzilaToken"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _TranzilaToken.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var card: String?

    @NSManaged open
    var dateAdded: Date?

    @NSManaged open
    var entity_id: String?

    @NSManaged open
    var expdate: String?

    @NSManaged open
    var is_save_card: String?

    @NSManaged open
    var token: String?

    // MARK: - Relationships

}

