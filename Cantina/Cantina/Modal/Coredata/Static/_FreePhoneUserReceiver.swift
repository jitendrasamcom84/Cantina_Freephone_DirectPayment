// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FreePhoneUserReceiver.swift instead.

import Foundation
import CoreData

public enum FreePhoneUserReceiverAttributes: String {
    case balance = "balance"
    case dateAdded = "dateAdded"
    case entity_id = "entity_id"
    case free_receiver_fname = "free_receiver_fname"
    case free_receiver_lname = "free_receiver_lname"
    case free_receiver_name = "free_receiver_name"
    case free_user_id = "free_user_id"
    case free_user_pass = "free_user_pass"
    case is_deleted = "is_deleted"
}

open class _FreePhoneUserReceiver: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "FreePhoneUserReceiver"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _FreePhoneUserReceiver.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var balance: NSNumber?

    @NSManaged open
    var dateAdded: Date?

    @NSManaged open
    var entity_id: String?

    @NSManaged open
    var free_receiver_fname: String?

    @NSManaged open
    var free_receiver_lname: String?

    @NSManaged open
    var free_receiver_name: String?

    @NSManaged open
    var free_user_id: String?

    @NSManaged open
    var free_user_pass: String?

    @NSManaged open
    var is_deleted: NSNumber?

    // MARK: - Relationships

}

