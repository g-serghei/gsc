//
// Created by Serghei Grigoruta on 20.04.2021.
//

struct TextSpan {
    public var start: Int
    public var length: Int

    init(start: Int, length: Int) {
        self.start = start
        self.length = length
    }

    public var end: Int {
        start + length
    }
}
