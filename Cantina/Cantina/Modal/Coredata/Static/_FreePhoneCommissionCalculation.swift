// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FreePhoneCommissionCalculation.swift instead.

import Foundation
import CoreData

public enum FreePhoneCommissionCalculationAttributes: String {
    case dateAdded = "dateAdded"
    case entity_id = "entity_id"
    case f = "f"
    case is_deleted = "is_deleted"
    case s = "s"
    case w = "w"
    case x = "x"
    case y = "y"
    case z1 = "z1"
    case z2 = "z2"
}

open class _FreePhoneCommissionCalculation: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "FreePhoneCommissionCalculation"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _FreePhoneCommissionCalculation.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var dateAdded: Date?

    @NSManaged open
    var entity_id: String?

    @NSManaged open
    var f: NSNumber?

    @NSManaged open
    var is_deleted: NSNumber?

    @NSManaged open
    var s: NSNumber?

    @NSManaged open
    var w: NSNumber?

    @NSManaged open
    var x: NSNumber?

    @NSManaged open
    var y: NSNumber?

    @NSManaged open
    var z1: NSNumber?

    @NSManaged open
    var z2: NSNumber?

    // MARK: - Relationships

}

