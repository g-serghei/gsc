//
// Created by Serghei Grigoruta on 21.04.2021.
//

import Foundation

class BoundAssignmentExpression: BoundExpression {
    public var variable: VariableSymbol
    public var expression: BoundExpression

    override public var kind: BoundNodeKind { .assignmentExpression }

    init(variable: VariableSymbol, expression: BoundExpression) {
        self.variable = variable
        self.expression = expression

        super.init()

        type = expression.type
    }
}
