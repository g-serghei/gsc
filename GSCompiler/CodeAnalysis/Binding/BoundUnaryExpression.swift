//
// Created by Serghei Grigoruta on 19.04.2021.
//

class BoundUnaryExpression: BoundExpression {
    public var op: BoundUnaryOperator
    public var operand: BoundExpression

    override public var type: DataType { op.type }
    override public var kind: BoundNodeKind { .unaryExpression }

    init(op: BoundUnaryOperator, operand: BoundExpression) {
        self.op = op
        self.operand = operand
    }
}