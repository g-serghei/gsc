//
// Created by Serghei Grigoruta on 17.04.2021.
//

class Evaluator {
    private var root: BoundExpression

    init(root: BoundExpression) {
        self.root = root
    }

    func evaluate() -> Int {
        try! evaluateExpression(node: root)
    }

    func evaluateExpression(node: BoundExpression) throws -> Int {
        if let n = node as? BoundLiteralExpression {
            return n.value as! Int
        }

        if let u = node as? BoundUnaryExpression {
            let operand = try evaluateExpression(node: u.operand)

            switch u.operatorKind {
            case .identity:
                return operand;
            case .negation:
                return -operand;
            }
        }

        if let b = node as? BoundBinaryExpression {
            let left = try evaluateExpression(node: b.left)
            let right = try evaluateExpression(node: b.right)

            switch b.operatorKind {
            case .addition:
                return left + right
            case .subtraction:
                return left - right
            case .multiplication:
                return left * right
            case .division:
                return left / right
            }
        }

        fatalError("Unexpected node: '\(node.kind)'")
    }
}
