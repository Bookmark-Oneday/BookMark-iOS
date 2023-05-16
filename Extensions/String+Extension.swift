//
//  String+Extension.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/05/16.
//

import Foundation

extension String {
    func dateFormat(startOffset: Int, endOffset: Int, replacer: String) -> String {
        let startIdx = self.index(self.startIndex, offsetBy: startOffset)
        let endIdx = self.index(self.startIndex, offsetBy: endOffset)
        let sliced = String(self[startIdx..<endIdx]).replacingOccurrences(of: "-", with: replacer)
        return sliced
    }
}
