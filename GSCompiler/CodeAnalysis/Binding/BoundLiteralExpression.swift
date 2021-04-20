//
// Created by Serghei Grigoruta on 19.04.2021.
//

class BoundLiteralExpression: BoundExpression {
    private(set) var value: Any

    override public var kind: BoundNodeKind { .literalExpression }

    init(value: Any) {
        self.value = value

        super.init()

        type = dataType(of: value)
    }
}
