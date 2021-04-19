//
// Created by Serghei Grigoruta on 19.04.2021.
//

class BoundUnaryExpression: BoundExpression {
    public var operatorKind: BoundUnaryOperatorKind
    public var operand: BoundExpression

    override public var nodeType: Any { operand.nodeType }
    override public var kind: BoundNodeKind { .unaryExpression }

    init(operatorKind: BoundUnaryOperatorKind, operand: BoundExpression) {
        self.operatorKind = operatorKind
        self.operand = operand
    }
}