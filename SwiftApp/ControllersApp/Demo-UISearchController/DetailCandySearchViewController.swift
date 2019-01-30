//
//  DetailCandySearchViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/30/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DetailCandySearchViewController: UIViewController
{
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var candyImageView: UIImageView!
    
    var detailCandy: Candy?
    {
        didSet {
            configureView()
        }
    }
    
    func configureView()
    {
        if let detailCandy = detailCandy {
            if let detailDescriptionLabel = detailDescriptionLabel, let candyImageView = candyImageView {
                detailDescriptionLabel.text = detailCandy.name
                candyImageView.image = UIImage(named: detailCandy.name)
                title = detailCandy.category
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}
