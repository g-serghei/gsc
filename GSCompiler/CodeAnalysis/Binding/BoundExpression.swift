//
// Created by Serghei Grigoruta on 19.04.2021.
//

class BoundExpression: BoundNode {
    public var type: DataType

    override init() {
        type = .undefined
    }
}
