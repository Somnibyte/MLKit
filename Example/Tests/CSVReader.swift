//
//  CSVReader.swift
//
//  Copyright (c) 2016 Peter Entwistle
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

open class CSVReader {

    fileprivate var _numberOfColumns: Int = 0
    fileprivate var _numberOfRows: Int = 0
    fileprivate var _delimiter: String
    fileprivate var _lines = [String]()
    open var headers = [String]()
    open var columns = [String: [String]]()
    open var rows = [[String: String]]()

    open var numberOfColumns: Int {
        get {
            return _numberOfColumns
        }
    }

    open var numberOfRows: Int {
        get {
            return _numberOfRows
        }
    }

    public init(with: String, delimiter: String) {
        let csv = with.replacingOccurrences(of: "\r", with: "", options: NSString.CompareOptions.literal, range: nil)
        _delimiter = delimiter
        processLines(csv)
        _numberOfColumns = _lines[0].components(separatedBy: _delimiter).count
        _numberOfRows = _lines.count - 1
        headers = _lines[0].components(separatedBy: _delimiter)
        setRows()
        setColumns()
    }

    public convenience init(with: String) {
        self.init(with: with, delimiter: ",")
    }

    fileprivate func processLines(_ csv: String) {
        _lines = csv.components(separatedBy: "\n")
        // Remove blank lines
        var i = 0
        for line in _lines {
            if line.isEmpty {
                _lines.remove(at: i)
                i -= 1
            }
            i += 1
        }
    }

    fileprivate func setRows() {
        var rows = [[String: String]]()
        for i in 1..._numberOfRows {
            var row = [String: String]()
            let vals = _lines[i].components(separatedBy: _delimiter)
            var i = 0
            for header in headers {
                row[header] = vals[i]
                i+=1
            }
            rows.append(row)
        }
        self.rows = rows
    }

    fileprivate func setColumns() {
        var columns = [String: [String]]()
        for header in headers {
            var colValue = [String]()
            for row in rows {
                colValue.append(row[header]!)
            }
            columns[header] = colValue
        }
        self.columns = columns
    }

}
