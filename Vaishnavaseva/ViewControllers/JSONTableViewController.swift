import UIKit

class JSONTableViewController: BaseTableViewController
  {
  var isBeforeResponseSucsess = false
  var sections: [Section] = []
  var entries: Array<SadhanaEntry> = [] {
    didSet {
      var lastDate = ""
      if sections.count != 0 {
        sections = []
      }
      for var i = 0; i < entries.count; ++i {
        let currentDate = entries[i].date!
        if lastDate != currentDate {
          lastDate = currentDate
          sections.append(Section(date: lastDate, firstIndex: i, count: 0))
        }
        ++sections[sections.count - 1].count
      }
    }
    
  }
}
