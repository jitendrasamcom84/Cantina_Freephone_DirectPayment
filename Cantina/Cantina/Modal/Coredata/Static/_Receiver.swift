// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Receiver.swift instead.

import Foundation
import CoreData

public enum ReceiverAttributes: String {
    case amount = "amount"
    case balance = "balance"
    case commission = "commission"
    case dateAdded = "dateAdded"
    case entity_id = "entity_id"
    case free_user_id = "free_user_id"
    case free_user_pass = "free_user_pass"
    case is_deleted = "is_deleted"
    case main_free_user_id = "main_free_user_id"
    case paymentid = "paymentid"
    case paymenttype = "paymenttype"
    case receiver_fname = "receiver_fname"
    case receiver_id = "receiver_id"
    case receiver_lname = "receiver_lname"
    case receiver_name = "receiver_name"
    case total_amout = "total_amout"
    case type = "type"
}

public enum ReceiverRelationships: String {
    case user_id = "user_id"
}

open class _Receiver: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Receiver"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Receiver.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var amount: NSNumber?

    @NSManaged open
    var balance: NSNumber?

    @NSManaged open
    var commission: NSNumber?

    @NSManaged open
    var dateAdded: Date?

    @NSManaged open
    var entity_id: String?

    @NSManaged open
    var free_user_id: String?

    @NSManaged open
    var free_user_pass: String?

    @NSManaged open
    var is_deleted: NSNumber?

    @NSManaged open
    var main_free_user_id: String?

    @NSManaged open
    var paymentid: NSNumber?

    @NSManaged open
    var paymenttype: String?

    @NSManaged open
    var receiver_fname: String?

    @NSManaged open
    var receiver_id: String?

    @NSManaged open
    var receiver_lname: String?

    @NSManaged open
    var receiver_name: String?

    @NSManaged open
    var total_amout: NSNumber?

    @NSManaged open
    var type: String?

    // MARK: - Relationships

    @NSManaged open
    var user_id: User?

}

