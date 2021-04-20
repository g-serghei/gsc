//
// Created by Serghei Grigoruta on 20.04.2021.
//

class BoundUnaryOperator {
    public var syntaxKind: SyntaxKind
    public var kind: BoundUnaryOperatorKind
    public var operandType: DataType
    public var type: DataType

    private static var operators: [BoundUnaryOperator] = [
        BoundUnaryOperator(syntaxKind: .bangToken, kind: .logicalNegation, operandType: .bool),
        BoundUnaryOperator(syntaxKind: .plusToken, kind: .identity, operandType: .int),
        BoundUnaryOperator(syntaxKind: .minusToken, kind: .negation, operandType: .int)
    ]

    init(syntaxKind: SyntaxKind, kind: BoundUnaryOperatorKind, operandType: DataType, resultType: DataType) {
        self.syntaxKind = syntaxKind
        self.kind = kind
        self.operandType = operandType
        type = resultType
    }

    convenience init(syntaxKind: SyntaxKind, kind: BoundUnaryOperatorKind, operandType: DataType) {
        self.init(syntaxKind: syntaxKind, kind: kind, operandType: operandType, resultType: operandType)
    }

    static func bind(syntaxKind: SyntaxKind, operandType: DataType) -> BoundUnaryOperator? {
        for op in operators {
            if op.syntaxKind == syntaxKind && op.operandType == operandType {
                return op
            }
        }

        return nil
    }
}
