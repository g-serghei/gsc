//
// Created by Serghei Grigoruta on 20.04.2021.
//

class BoundBinaryOperator {
    public var syntaxKind: SyntaxKind
    public var kind: BoundBinaryOperatorKind
    public var leftType: DataType
    public var rightType: DataType
    public var type: DataType

    private static var operators: [BoundBinaryOperator] = [
        BoundBinaryOperator(syntaxKind: .plusToken, kind: .addition, type: .int),
        BoundBinaryOperator(syntaxKind: .minusToken, kind: .subtraction, type: .int),
        BoundBinaryOperator(syntaxKind: .startToken, kind: .multiplication, type: .int),
        BoundBinaryOperator(syntaxKind: .slashToken, kind: .division, type: .int),
        BoundBinaryOperator(syntaxKind: .equalsEqualsToken, kind: .equals, operandType: .int, resultType: .bool),
        BoundBinaryOperator(syntaxKind: .bangEqualsToken, kind: .notEquals, operandType: .int, resultType: .bool),

        BoundBinaryOperator(syntaxKind: .ampersandAmpersandToken, kind: .logicalAnd, type: .bool),
        BoundBinaryOperator(syntaxKind: .pipePipeToken, kind: .logicalOr, type: .bool),
        BoundBinaryOperator(syntaxKind: .equalsEqualsToken, kind: .equals, type: .bool),
        BoundBinaryOperator(syntaxKind: .bangEqualsToken, kind: .notEquals, type: .bool),
    ]

    init(syntaxKind: SyntaxKind, kind: BoundBinaryOperatorKind, leftType: DataType, rightType: DataType, resultType: DataType) {
        self.syntaxKind = syntaxKind
        self.kind = kind
        self.leftType = leftType
        self.rightType = rightType
        type = resultType
    }

    convenience init(syntaxKind: SyntaxKind, kind: BoundBinaryOperatorKind, type: DataType) {
        self.init(syntaxKind: syntaxKind, kind: kind, leftType: type, rightType: type, resultType: type)
    }

    convenience init(syntaxKind: SyntaxKind, kind: BoundBinaryOperatorKind, operandType: DataType, resultType: DataType) {
        self.init(syntaxKind: syntaxKind, kind: kind, leftType: operandType, rightType: operandType, resultType: resultType)
    }
    static func bind(syntaxKind: SyntaxKind, leftType: DataType, rightType: DataType) -> BoundBinaryOperator? {
        for op in operators {
            if op.syntaxKind == syntaxKind && op.leftType == leftType && op.rightType == rightType {
                return op
            }
        }

        return nil
    }
}
