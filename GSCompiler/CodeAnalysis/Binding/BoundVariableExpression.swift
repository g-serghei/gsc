//
// Created by Serghei Grigoruta on 21.04.2021.
//

import Foundation

class BoundVariableExpression: BoundExpression
{
    public var name: String

    override public var kind: BoundNodeKind { .variableExpression }

    init(name: String, type: DataType) {
        self.name = name

        super.init()

        self.type = type
    }
}
