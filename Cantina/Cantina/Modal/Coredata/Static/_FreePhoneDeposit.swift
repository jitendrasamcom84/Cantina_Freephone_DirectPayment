// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FreePhoneDeposit.swift instead.

import Foundation
import CoreData

public enum FreePhoneDepositAttributes: String {
    case amount = "amount"
    case commission = "commission"
    case dateAdded = "dateAdded"
    case entity_id = "entity_id"
    case is_deleted = "is_deleted"
    case is_pay = "is_pay"
    case name = "name"
    case paymentid = "paymentid"
    case phone = "phone"
    case rec_id = "rec_id"
    case status = "status"
    case total_amount = "total_amount"
    case transaction_id = "transaction_id"
    case tranzilapara = "tranzilapara"
    case updated_date = "updated_date"
    case user = "user"
    case user_id = "user_id"
}

open class _FreePhoneDeposit: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "FreePhoneDeposit"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _FreePhoneDeposit.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var amount: NSNumber?

    @NSManaged open
    var commission: NSNumber?

    @NSManaged open
    var dateAdded: Date?

    @NSManaged open
    var entity_id: String?

    @NSManaged open
    var is_deleted: NSNumber?

    @NSManaged open
    var is_pay: NSNumber?

    @NSManaged open
    var name: String?

    @NSManaged open
    var paymentid: NSNumber?

    @NSManaged open
    var phone: String?

    @NSManaged open
    var rec_id: String?

    @NSManaged open
    var status: NSNumber?

    @NSManaged open
    var total_amount: NSNumber?

    @NSManaged open
    var transaction_id: String?

    @NSManaged open
    var tranzilapara: String?

    @NSManaged open
    var updated_date: Date?

    @NSManaged open
    var user: NSNumber?

    @NSManaged open
    var user_id: String?

    // MARK: - Relationships

}

