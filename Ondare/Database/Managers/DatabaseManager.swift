//
//  DatabaseManager.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import Foundation
import GRDB

// MARK: DB

class DatabaseManager {
    static let shared = DatabaseManager()
    private var dbQueue: DatabaseQueue!

    private init() {
        setupDatabase()
    }

    private func setupDatabase() {
        do {
            let fileManager = FileManager.default
            let folderURL = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dbURL = folderURL.appendingPathComponent("favorites.sqlite")

            dbQueue = try DatabaseQueue(path: dbURL.path)

            print("DB: \(dbURL.path)")

            try migrator.migrate(dbQueue)
        } catch {
            fatalError("DB Setup Failed: \(error)")
        }
    }

    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

#if DEBUG
        // Speed up development by nuking the database when migrations change
        migrator.eraseDatabaseOnSchemaChange = true
#endif

        migrator.registerMigration("0") { db in
            try db.create(table: "favoriteStation") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("favicon", .text)
                t.column("streamUrl", .text).notNull()
                t.column("tags", .text).notNull()
            }

            try db.create(table: "selectedRegion") { t in
                t.column("iso3166_1", .text).primaryKey()
                t.column("name", .text).notNull()
            }
        }

        return migrator
    }
}

// MARK: - Functions

extension DatabaseManager {
    // MARK: - RadioStation Operations

    func saveFavorite(_ station: FavoriteStation) throws {
        try dbQueue.write { db in
            try station.save(db)
        }
    }

    @discardableResult
    func removeFavorite(withId id: String) throws -> Bool {
        try dbQueue.write { db in
            try FavoriteStation.deleteOne(db, key: id)
        }
    }

    func fetchAllFavorites() throws -> [FavoriteStation] {
        try dbQueue.read { db in
            try FavoriteStation.fetchAll(db)
        }
    }

    func isFavorite(id: String) -> Bool {
        do {
            return try dbQueue.read { db in
                try FavoriteStation.exists(db, key: id)
            }
        } catch {
            return false
        }
    }

    // MARK: - SelectedRegion Operations

    func saveSelectedRegion(_ region: SelectedRegion) throws {
        try dbQueue.write { db in
            try region.save(db)
        }
    }

    @discardableResult
    func removeSelectedRegion(isoCode: String) throws -> Bool {
        try dbQueue.write { db in
            try SelectedRegion.deleteOne(db, key: isoCode)
        }
    }

    @discardableResult
    func removeSelectedRegions() throws -> Int {
        try dbQueue.write { db in
            try SelectedRegion.deleteAll(db)
        }
    }

    func isRegionSelected(isoCode: String) -> Bool {
        do {
            return try dbQueue.read { db in
                try SelectedRegion.exists(db, key: isoCode)
            }
        } catch {
            return false
        }
    }

    func fetchAllSelectedRegions() -> [SelectedRegion] {
        do {
            return try dbQueue.read { db in
                try SelectedRegion.fetchAll(db)
            }
        } catch {
            print("Error fetching selected regions: \(error)")
            return []
        }
    }
}

// MARK: - Additional Convenience Methods

extension DatabaseManager {
    func favoriteCount() -> Int {
        do {
            return try dbQueue.read { db in
                try FavoriteStation.fetchCount(db)
            }
        } catch {
            return 0
        }
    }

    func selectedRegionCount() -> Int {
        do {
            return try dbQueue.read { db in
                try SelectedRegion.fetchCount(db)
            }
        } catch {
            return 0
        }
    }

    func clearAllData() throws {
        try dbQueue.write { db in
            try FavoriteStation.deleteAll(db)
            try SelectedRegion.deleteAll(db)
        }
    }
}
