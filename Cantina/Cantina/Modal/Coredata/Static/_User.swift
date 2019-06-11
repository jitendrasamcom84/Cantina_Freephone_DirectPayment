// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.swift instead.

import Foundation
import CoreData

public enum UserAttributes: String {
    case active = "active"
    case date_add = "date_add"
    case email = "email"
    case entity_id = "entity_id"
    case fcmRegId = "fcmRegId"
    case is_deleted = "is_deleted"
    case last_mod = "last_mod"
    case name = "name"
    case phone = "phone"
    case provider = "provider"
    case type = "type"
}

open class _User: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "User"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _User.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var active: NSNumber?

    @NSManaged open
    var date_add: Date?

    @NSManaged open
    var email: String?

    @NSManaged open
    var entity_id: String?

    @NSManaged open
    var fcmRegId: String?

    @NSManaged open
    var is_deleted: NSNumber?

    @NSManaged open
    var last_mod: Date?

    @NSManaged open
    var name: String?

    @NSManaged open
    var phone: String?

    @NSManaged open
    var provider: String?

    @NSManaged open
    var type: String?

    // MARK: - Relationships

}

