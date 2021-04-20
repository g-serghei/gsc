//
// Created by Serghei Grigoruta on 19.04.2021.
//

import Foundation

class BoundBinaryExpression: BoundExpression {
    public var left: BoundExpression
    public var op: BoundBinaryOperator
    public var right: BoundExpression

    override public var type: DataType { op.type }
    override public var kind: BoundNodeKind { .binaryExpression }

    init(left: BoundExpression, op: BoundBinaryOperator, right: BoundExpression) {
        self.left = left
        self.op = op
        self.right = right
    }
}
