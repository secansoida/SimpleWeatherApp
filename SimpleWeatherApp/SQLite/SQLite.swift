//
//  SQLite.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import Foundation

final class SQLite {
    
    private var connection: OpaquePointer!
    
    init?(path: String) {
        var connection: OpaquePointer?
        if sqlite3_open(path, &connection) != SQLITE_OK {
            return nil
        }
        self.connection = connection
    }
    
    func close() {
        sqlite3_close(connection)
    }
    
    func fetchAll(query: String) -> [[String: Any]]? {
        var results: [[String: Any]] = []
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(connection, query, -1, &statement, nil) != SQLITE_OK {
            return nil
        }
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            var result: [String: Any] = [:]
            
            let columnsCount = sqlite3_column_count(statement)
            for column in 0 ..< columnsCount {
                let type = sqlite3_column_type(statement, column)
                let name = String(cString: sqlite3_column_name(statement, column))
                
                switch type {
                    case SQLITE_TEXT:
                        result[name] = String(cString: sqlite3_column_text(statement, column))
                    case SQLITE_INTEGER:
                        result[name] = Int(sqlite3_column_int(statement, column))
                    case SQLITE_FLOAT:
                        result[name] = Float(sqlite3_column_double(statement, column))
                    default:
                        print("Couldn't decode \(name): \(type)")
                }
            }
            
            results.append(result)
        }
        
        return results
    }

    deinit {
        close()
    }
}
