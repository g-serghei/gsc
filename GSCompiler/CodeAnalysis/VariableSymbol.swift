//
// Created by Serghei Grigoruta on 21.04.2021.
//

struct VariableSymbol: Hashable {
    var name: String
    var type: DataType

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}