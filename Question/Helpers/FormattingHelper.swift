//
//  FormattingHelper.swift
//  Ecommunity
//
//  Created by Jack Finnis on 16/12/2021.
//

import Foundation

struct FormattingHelper {
    func singularPlural(singularWord: String, count: Int) -> String {
        (count == 0 ? "No" : String(count)) + " " + singularWord + (count == 1 ? "" : "s")
    }
}
