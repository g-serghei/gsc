//
// Created by Serghei Grigoruta on 19.04.2021.
//

import Foundation

class BoundBinaryExpression: BoundExpression {
    public var left: BoundExpression
    public var operatorKind: BoundBinaryOperatorKind
    public var right: BoundExpression

    override public var nodeType: Any { left.nodeType }
    override public var kind: BoundNodeKind { .binaryExpression }

    init(left: BoundExpression, operatorKind: BoundBinaryOperatorKind, right: BoundExpression) {
        self.left = left
        self.operatorKind = operatorKind
        self.right = right
    }
}
