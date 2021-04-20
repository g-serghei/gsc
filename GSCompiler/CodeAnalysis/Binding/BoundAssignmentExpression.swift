//
// Created by Serghei Grigoruta on 21.04.2021.
//

import Foundation

class BoundAssignmentExpression: BoundExpression {
    public var name: String
    public var expression: BoundExpression

    override public var kind: BoundNodeKind { .assignmentExpression }

    init(name: String, expression: BoundExpression) {
        self.name = name
        self.expression = expression

        super.init()

        type = expression.type
    }
}
