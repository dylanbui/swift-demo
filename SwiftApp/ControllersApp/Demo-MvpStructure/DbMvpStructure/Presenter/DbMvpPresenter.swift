//
//  DbMvpPresenter.swift
//  PropzySurvey
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation

public protocol DbMvpPresenter
{    
    init()
    
    associatedtype ViewAction
    func attach(viewAction: ViewAction)

    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
    
    func destroy()
}

public extension DbMvpPresenter
{
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewWillDisappear() {}
    func viewDidDisappear() {}
    
    func destroy() {}
}

//public protocol DbMvpPresenterForType: DbMvpPresenter
//{
//    associatedtype ViewAction
//
//    var ui: ViewAction?
//
//    func attachViewAction(view : ViewAction)
//    func detachViewAction()
//    func destroy()
//}
