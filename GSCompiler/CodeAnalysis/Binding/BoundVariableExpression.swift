//
// Created by Serghei Grigoruta on 21.04.2021.
//

import Foundation

class BoundVariableExpression: BoundExpression
{
    public var variable: VariableSymbol

    override public var kind: BoundNodeKind { .variableExpression }

    init(variable: VariableSymbol) {
        self.variable = variable

        super.init()

        type = variable.type
    }
}
