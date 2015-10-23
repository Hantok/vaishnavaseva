import UIKit

class JSONTableViewController: BaseTableViewController
  {
  var isBeforeResponseSucsess = false
  var sections: [Section] = []
  var json: JSON = JSON.null
    {
    didSet
    {
      switch self.json.type
      {
      case Type.Array:
        var lastDate = ""
        if sections.count != 0
        {
          sections = []
        }
        for var i = 0; i < json.count; ++i
        {
          let currentDate = json[i]["date"].description
          if lastDate != currentDate
          {
            lastDate = currentDate
            sections.append(Section(date: lastDate, firstIndex: i, count: 0))
          }
          ++sections[sections.count - 1].count
        }
      default:
        break
      }
    }
  }
}
