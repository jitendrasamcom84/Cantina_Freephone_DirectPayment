// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FreePhoneCommission.swift instead.

import Foundation
import CoreData

public enum FreePhoneCommissionAttributes: String {
    case total_amount = "total_amount"
}

open class _FreePhoneCommission: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "FreePhoneCommission"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _FreePhoneCommission.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var total_amount: String?

    // MARK: - Relationships

}

