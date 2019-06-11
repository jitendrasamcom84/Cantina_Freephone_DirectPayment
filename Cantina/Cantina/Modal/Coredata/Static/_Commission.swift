// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Commission.swift instead.

import Foundation
import CoreData

public enum CommissionAttributes: String {
    case total_amount = "total_amount"
}

open class _Commission: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Commission"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Commission.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var total_amount: NSNumber?

    // MARK: - Relationships

}

