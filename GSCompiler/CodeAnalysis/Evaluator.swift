//
// Created by Serghei Grigoruta on 17.04.2021.
//

class Evaluator {
    private var root: BoundExpression
    private var variables: Dictionary<String, Any>

    init(root: BoundExpression, variables: inout Dictionary<String, Any>) {
        self.root = root
        self.variables = variables
    }

    func evaluate() -> Any {
        try! evaluateExpression(node: root)
    }

    func evaluateExpression(node: BoundExpression) throws -> Any {
        if let n = node as? BoundLiteralExpression {
            return n.value
        }

        if let v = node as? BoundVariableExpression {
            print(v.name)
            return variables[v.name] as Any
        }

        if let a = node as? BoundAssignmentExpression {
            let value = try! evaluateExpression(node: a.expression)
            variables[a.name] = value

            print(variables)

            return value
        }

        if let u = node as? BoundUnaryExpression {
            let operand = try evaluateExpression(node: u.operand)

            switch u.op.kind {
            case .identity:
                return operand as! Int
            case .negation:
                return -(operand as! Int)
            case .logicalNegation:
                return !(operand as! Bool)
            }
        }

        if let b = node as? BoundBinaryExpression {
            let left = try evaluateExpression(node: b.left)
            let right = try evaluateExpression(node: b.right)

            switch b.op.kind {
            case .addition:
                return (left as! Int) + (right as! Int)
            case .subtraction:
                return (left as! Int) - (right as! Int)
            case .multiplication:
                return (left as! Int) * (right as! Int)
            case .division:
                return (left as! Int) / (right as! Int)
            case .logicalAnd:
                return (left as! Bool) && (right as! Bool)
            case .logicalOr:
                return (left as! Bool) || (right as! Bool)
            case .equals:
                return equals(a: left, b: right)
            case .notEquals:
                return !equals(a: left, b: right)
            }
        }

        fatalError("Unexpected node: '\(node.kind)'")
    }
}
