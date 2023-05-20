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
    
    func secondsFormat(seconds: Int) -> String {
        var result = self
        
        let time = seconds / 3600
        result += "\(time):"
        
        let min = (Double(seconds) / Double(3600)) - Double(time)
        result += "\(Int(min * 60)):"
        
        let sec = (min * 60) - Double(Int(min * 60))
        result += "\(Int(ceil(sec * 60)))"
        
        return result
    }
}
