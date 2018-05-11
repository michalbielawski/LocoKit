//
//  PersistentObject.swift
//  LocoKit
//
//  Created by Matt Greenfield on 9/01/18.
//  Copyright © 2018 Big Paua. All rights reserved.
//

import os.log
import GRDB

public typealias PersistentItem = PersistentObject & TimelineItem

public protocol PersistentObject: TimelineObject, PersistableRecord {

    var persistentStore: PersistentTimelineStore? { get }
    var transactionDate: Date? { get set }
    var lastSaved: Date? { get set }
    var unsaved: Bool { get }
    var hasChanges: Bool { get set }
    var needsSave: Bool { get }

    func save(immediate: Bool)
    func save(in db: Database) throws

}

public extension PersistentObject {
    public var unsaved: Bool { return lastSaved == nil }
    public var needsSave: Bool { return unsaved || hasChanges }
    public func save(immediate: Bool = false) { persistentStore?.save(self, immediate: immediate) }
    public func save(in db: Database) throws {
        if unsaved { try insert(db) } else if hasChanges { try update(db) }
        hasChanges = false
    }
}

public extension PersistentObject where Self: TimelineItem {
    public var persistentStore: PersistentTimelineStore? { return store as? PersistentTimelineStore }
}

