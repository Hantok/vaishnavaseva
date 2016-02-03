//
//  AppControllerStateAbstractUserSadhana.swift
//  Vaishnavaseva
//
//  Created by Roman Slysh on 2/3/16.
//  Copyright © 2016 007. All rights reserved.
//
import UIKit

@objc class AppControllerStateAbstractUserSadhana: AppControllerState {
  func userSadhanaEntries(month:String) {
    preconditionFailure("userSadhanaEntries method must be overridden")
  }
  
  func getAvailableMonths() {
    let jsonTableViewController = self.viewController as! JSONTableViewController
    let userId = jsonTableViewController.sadhanaUser.userId!
    if (jsonTableViewController.year != 0 && jsonTableViewController.year < 2015) {
      jsonTableViewController.totalFound = 0
      jsonTableViewController.isBeforeResponseSucsess = true
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      jsonTableViewController.tableView.infiniteScrollingView.stopAnimating()
      jsonTableViewController.tableView.infiniteScrollingView.enabled = false
      return
    }
    
    if jsonTableViewController.dates[jsonTableViewController.year] == nil {
      "months/\(userId)/\(jsonTableViewController.year)".get()  { response in
        
        if (response.data == nil) {
          self.viewController.showErrorAlert(NSLocalizedString("Server error", comment: "Alert title"))
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
          jsonTableViewController.tableView.infiniteScrollingView.stopAnimating()
          return
        }
        if response.error?.code != nil {
          jsonTableViewController.showErrorAlert(NSLocalizedString("No internet connection", comment: "Alert title"))
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
          jsonTableViewController.tableView.infiniteScrollingView.stopAnimating()
          return
        }
        
        let months = (response.responseJSON as! NSArray).reverse()
        if (months.count == 0) {
          jsonTableViewController.totalFound = 0
          jsonTableViewController.isBeforeResponseSucsess = true
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
          jsonTableViewController.tableView.infiniteScrollingView.stopAnimating()
          jsonTableViewController.tableView.infiniteScrollingView.enabled = false
        }
        jsonTableViewController.dates[jsonTableViewController.year] = months
        self.getEntries(months)
      }
    } else {
      let months = jsonTableViewController.dates[jsonTableViewController.year]
      self.getEntries(months!)
    }
  }
  
  func getEntries(months:NSArray) {
    let jsonTableViewController = self.viewController as! JSONTableViewController
    if jsonTableViewController.monthIndex < months.count {
      self.userSadhanaEntries(months[jsonTableViewController.monthIndex] as! String)
    } else {
      jsonTableViewController.monthIndex = 0
      --jsonTableViewController.year
      getAvailableMonths()
    }
  }
}