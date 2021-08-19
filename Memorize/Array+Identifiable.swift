//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Nguyen Tran Duy Khang on 4/5/21.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching item: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == item.id {
                return index
            }
        }
        return nil
    }
}
