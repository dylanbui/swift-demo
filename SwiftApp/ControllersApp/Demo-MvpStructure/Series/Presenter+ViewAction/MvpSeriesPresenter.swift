//
//  MvpSeriesPresenter.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/4/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

protocol MvpSeriesViewAction: DbMvpLoadingViewAction
{
    // Co y dat trung ten ham voi "extension DbMvpTableViewAction", thi khong can khai bao func cho MvpCharactersViewAction
    // vi no trung ten, no se tu dong goi DbMvpTableViewAction de loai lai TableView
    func doReloadTableView(items: [MvpSeries])
}

class MvpSeriesPresenter: DbMvpPresenter
{
    private weak var ui: MvpSeriesViewAction?
    
    required init()
    {
        
    }
    
    // -- Su dung kieu ngam dinh thay cho : typealias ViewAction = MvpSeriesViewAction --
    func attach(viewAction: MvpSeriesViewAction)
    {
        self.ui = viewAction
        
    }
    
    func viewDidLoad()
    {
        self.ui?.showLoader()
        
        DbDispatch.after(3.5) { () -> (Void) in
            
            self.ui?.hideLoader()
            
            self.ui?.doReloadTableView(items: [
                MvpSeries(name: "Spider-Man (2004)"),
                MvpSeries(name: "Iron Fist: The Living Weapon (2004 - Present)"),
                MvpSeries(name: "Iron Man & the Armor Wars (2009)"),
                MvpSeries(name: "Avengers (2012 - Present)"),
                MvpSeries(name: "Thor: God of Thunder (2012 - Present)"),
                MvpSeries(name: "Iron Man (2012 - Present)"),
                MvpSeries(name: "Deadpool (2012 - Present)"),
                MvpSeries(name: "All-New X-Men (2012 - Present)"),
                MvpSeries(name: "Iron Man (2013)"),
                MvpSeries(name: "Guardians of the Galaxy (2013 - Present)"),
                MvpSeries(name: "Amazing Spider-Man (2014 - Present)"),
                MvpSeries(name: "Daredevil (2014 - Present)"),
                MvpSeries(name: "Inhuman (2014 - Present)"),
                MvpSeries(name: "Jessica Jones (2014 - Present)"),
                MvpSeries(name: "Civil War (2014 - Present)"),
                MvpSeries(name: "Avengers & X_Men: Axis (2014 - Present)"),
                MvpSeries(name: "Death of Wolverine: Axis (2015 - Present)")
                ])
        }
    }
}
