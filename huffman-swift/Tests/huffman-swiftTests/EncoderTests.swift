import XCTest
@testable import huffman_swift

final class EncoderTests: XCTestCase {
    func testEncode() throws {
        let (mapping, bitStr) = huffmanEncode(source: "aabbbcccc") 
        XCTAssertEqual(mapping["a"], "10")
        XCTAssertEqual(mapping["b"], "11")
        XCTAssertEqual(mapping["c"], "0")
        XCTAssertEqual(bitStr, "10101111110000")
    }
}
