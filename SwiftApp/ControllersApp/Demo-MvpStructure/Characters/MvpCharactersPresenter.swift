//
//  CharactersPresenter.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

struct MvpCharacter {
    let name: String
    let thumbnail: URL
}

protocol MvpCharactersViewAction: DbMvpViewAction // DbMvpLoadingViewAction
{
    func show(items: [MvpCharacter])
    
    // Co y dat trung ten ham voi "extension DbMvpTableViewAction", thi khong can khai bao func cho MvpCharactersViewAction
    // vi no trung ten, no se tu dong goi DbMvpTableViewAction de loai lai TableView
    func doReloadTableView(items: [MvpCharacter])
}

// class MvpCharactersPresenter<V: MvpCharactersViewAction>: DbMvpPresenter
class MvpCharactersPresenter: DbMvpPresenter
{
    // typealias ViewAction = MvpCharactersViewAction
    private weak var ui: MvpCharactersViewAction?
    
    required init()
    {
        
    }
    
    // -- Su dung kieu ngam dinh thay cho : typealias ViewAction = MvpCharactersViewAction --
    func attach(viewAction: MvpCharactersViewAction)
    {
        self.ui = viewAction
        
    }
    
    func viewDidLoad()
    {
        load(items: [
            MvpCharacter(name: "Spider-Man", thumbnail: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/6/60/538cd3628a05e.jpg")!),
            MvpCharacter(name: "Iron Man", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg")!),
            MvpCharacter(name: "Scarlet Witch", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/9/b0/537bc2375dfb9.jpg")!),
            MvpCharacter(name: "Hulk", thumbnail: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/e/e0/537bafa34baa9.jpg")!),
            MvpCharacter(name: "Wolverine", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/9/00/537bcb1133fd7.jpg")!),
            MvpCharacter(name: "Storm", thumbnail: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/c/b0/537bc5f8a8df0.jpg")!),
            MvpCharacter(name: "Ultron", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/9/a0/537bc7f6d5d23.jpg")!),
            MvpCharacter(name: "BlackPanther", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/9/03/537ba26276348.jpg")!),
            MvpCharacter(name: "Winter Soldier", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/7/40/537bca868687c.jpg")!),
            MvpCharacter(name: "Captain Marvel", thumbnail: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/6/30/537ba61b764b4.jpg")!),
            MvpCharacter(name: "Iron Fist", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/6/60/537bb1756cd26.jpg")!),
            ])
    }
    
    func didStartRefreshing()
    {
        load(items: [
            MvpCharacter(name: "Captain America", thumbnail: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/9/80/537ba5b368b7d.jpg")!),
            MvpCharacter(name: "Magneto", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/70/537bb50ecbf68.jpg")!),
            MvpCharacter(name: "Star-Lord", thumbnail: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/9/a0/537bc5794cce1.jpg")!),
            MvpCharacter(name: "SpiderMan", thumbnail: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/6/60/538cd3628a05e.jpg")!),
            MvpCharacter(name: "IronMan", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg")!),
            MvpCharacter(name: "Scarlet Witch", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/9/b0/537bc2375dfb9.jpg")!),
            MvpCharacter(name: "Hulk", thumbnail: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/e/e0/537bafa34baa9.jpg")!),
            MvpCharacter(name: "Wolverine", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/9/00/537bcb1133fd7.jpg")!),
            MvpCharacter(name: "Storm", thumbnail: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/c/b0/537bc5f8a8df0.jpg")!),
            MvpCharacter(name: "Ultron", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/9/a0/537bc7f6d5d23.jpg")!),
            MvpCharacter(name: "BlackPanther", thumbnail: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/9/03/537ba26276348.jpg")!),
            ])
        
        //self.ui?.stopRefreshing()
    }
    
    private func load(items: [MvpCharacter])
    {
        self.ui?.show(items: items)
    }
}
