//
// Created by Serghei Grigoruta on 20.04.2021.
//

enum DataType {
    case string
    case int
    case int64
    case double
    case bool
    case undefined

    func isSame(type: DataType) -> Bool {
        self == type
    }
}

func dataType(of: Any) -> DataType {
    if of is String {
        return .string
    } else if of is Int {
        return .int
    } else if of is Int64 {
        return .int64
    } else if of is Double {
        return .double
    } else if of is Bool {
        return .bool
    } else {
        return .undefined
    }
}
