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

func equals(a: Any, b: Any) -> Bool {
    let aType: DataType = dataType(of: a)
    let bType: DataType = dataType(of: b)
    if aType != bType {
        return false
    } else {
        switch aType {
        case .string:
            guard let aValue = a as? String, let bValue = b as? String else {
                return false
            }

            return aValue == bValue
        case .int:
            guard let aValue = a as? Int, let bValue = b as? Int else {
                return false
            }

            return aValue == bValue
        case .int64:
            guard let aValue = a as? Int64, let bValue = b as? Int64 else {
                return false
            }

            return aValue == bValue
        case .double:
            guard let aValue = a as? Double, let bValue = b as? Double else {
                return false
            }

            return aValue == bValue
        case .bool:
            guard let aValue = a as? Bool, let bValue = b as? Bool else {
                return false
            }

            return aValue == bValue
        default:
            return false
        }
    }
}