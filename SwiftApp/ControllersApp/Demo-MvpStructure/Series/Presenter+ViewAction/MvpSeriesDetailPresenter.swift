//
//  MvpSeriesDetailPresenter.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/4/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

protocol MvpSeriesDetailViewAction: DbMvpViewAction
{
    var title: String? { get set }

    func configureHeader(_ series: MvpSeries)
    // func show(items: [MvpComic])
    
    // Co y dat trung ten ham voi "extension DbMvpTableViewAction", thi khong can khai bao func cho MvpCharactersViewAction
    // vi no trung ten, no se tu dong goi DbMvpTableViewAction de loai lai TableView
    func doReloadCollectionView(items: [MvpComic])
}

class MvpSeriesDetailPresenter: DbMvpPresenter
{
    private weak var ui: MvpSeriesDetailViewAction?
    private var seriesName: String?
    
    required init()
    {
        
    }
    
    convenience init(ui: MvpSeriesDetailViewAction, seriesName: String)
    {
        self.init()
        self.ui = ui
        self.seriesName = seriesName
    }
    
    // -- Su dung kieu ngam dinh thay cho : typealias ViewAction = MvpSeriesDetailViewAction --
    func attach(viewAction: MvpSeriesDetailViewAction)
    {
        self.ui = viewAction
    }
    
    func viewDidLoad()
    {
        self.ui?.title = self.seriesName?.uppercased()
    }
    
    func viewWillAppear()
    {
        self.loadSeriesDetail()
    }
    
    private func loadSeriesDetail()
    {
        let series = MvpSeries(name: self.seriesName ?? "",
            coverURL: URL(string: "https://vignette3.wikia.nocookie.net/steamtradingcards/images/e/e6/Marvel_Heroes_Artwork_Iron_Man.jpg/revision/latest?cb=20130929234052"),
            rating: "T",
            description: "Extremis: It changes everything for Iron Man! The deadly "
            + "new technology from the imagination of Warren Ellis and Adi Granov "
            + "propels Tony Stark into the next gear as he takes on a super hero "
            + "Civil War and perhaps his greatest challenge yet as Director of "
            + "S.H.I.E.L.D.!",
            comics: [
                MvpComic(name: "Civil War: Iron Man",
                    coverURL: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/c/90/51ddaa7bb6788/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man: Execute Program",
                    coverURL: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/f/a0/4bc5ae737ec9c/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man: Extremis",
                    coverURL: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/8/80/4bc5abb727022/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man #14",
                    coverURL: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/9/40/4d2525b096dec/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man #13",
                    coverURL: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/6/e0/4d24fdc986281/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man #12",
                    coverURL: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/b/c0/4d2515cda44ae/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man #11",
                    coverURL: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/5/03/4d250b7077707/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man #10",
                    coverURL: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/3/03/4d25153f18362/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man #9",
                    coverURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/e/f0/4d24dea0ce8e1/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man #8",
                    coverURL: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/9/50/4d24e83a5b5d5/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man #7",
                    coverURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/7/20/4f8479d44fd50/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man #6",
                    coverURL: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/6/60/4f84752bb13d5/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man #5",
                    coverURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/4bb7dec0199b5/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man #4",
                    coverURL: URL(string: "https://x.annihil.us/u/prod/marvel/i/mg/c/70/4f7f0a8fb8c03/portrait_incredible.jpg")),
                MvpComic(name: "Iron Man #3",
                    coverURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/9/60/4d251fee74e41/portrait_incredible.jpg"))
            ])
        
        self.ui?.configureHeader(series)
        self.ui?.doReloadCollectionView(items: series.comics)
        // ui?.show(items: series.comics)
    }
    
}
