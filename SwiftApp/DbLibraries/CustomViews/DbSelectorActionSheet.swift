//
//  DbSelectorActionSheet.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/28/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

enum Sas {
    static let CELL_HEIGHT              = 55
    static let TITLE_VIEW_HEIGHT        = 35
    static let DISMISS_BUTTON_HEIGHT    = 65
    
    static let ImageChecked             = UIImage(named: "sas_checked.png")
    static let ImageUnCheck             = UIImage(named: "sas_uncheck.png")
    
    static let ActionTitleFontSize      = 14.5
    static let ActionTitleColor         = UIColor.black
    static let ActionButtonTitleColor   = UIColor.black
    
    static let OptionTextColor          = UIColor.init(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    static let SeletedOptionTextColor   = UIColor.init(red: 255.0/255.0, green: 160.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    static let ActionSeparatorColor     = UIColor.init(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    static let ActionDoneButtonColor    = UIColor.init(red: 0.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: 1.0)
}


typealias DbSelectorActionBlock = (Int, Bool) -> Void

class DbSelectorActionSheet: UIView {
    
    var title: String! = ""
    var dismissButtonTitle: String! = ""
    var otherTitles: [String] = [String]()
    var dismissOnSelect: Bool = true
    var selectedIndex: Int! = 0
    
    var blockHandler: DbSelectorActionBlock?
    
    fileprivate let tableViewOptions = UITableView()
    fileprivate let btnDismiss = UIButton.init(type: .custom)

    // -- Default init must override
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    // -- Default init must override
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(title: String?, dismissButtonTitle: String?, otherButtonTitles: [String], dismissOnSelect: Bool = true) {
        super.init(frame: CGRect.zero)
        self.title = title ?? ""
        self.dismissButtonTitle = dismissButtonTitle ?? ""
        self.otherTitles = otherButtonTitles
        self.dismissOnSelect = dismissOnSelect
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        self.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        
        // Setup Dissmiss button
        self.setupDismissView()
    
        // Setup TableView
        self.setupTableView()

        

    }
    
    private func setupDismissView() -> Void {
        self.btnDismiss.backgroundColor = UIColor.clear
        self.btnDismiss.frame = self.frame
        self.btnDismiss.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        self.btnDismiss.addTarget(self, action: #selector(btnCancelActionSheetClick), for: .touchUpInside)
        self.addSubview(self.btnDismiss)
    }
    
    private func setupTableView() -> Void {
        // Add TableView to show options
        self.tableViewOptions.frame = self.frame
        self.tableViewOptions.backgroundColor = UIColor.white
        self.tableViewOptions.dataSource = self
        self.tableViewOptions.delegate = self
        self.tableViewOptions.bounces = false
        self.tableViewOptions.separatorStyle = .none
        self.tableViewOptions.showsVerticalScrollIndicator = false

        self.tableViewOptions.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleWidth]
        self.addSubview(self.tableViewOptions)
    }
    
    private func dissmissActionSheet() -> Void {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0)
            // Animate TableView from bottom
            var newFrame = self.tableViewOptions.frame
            newFrame.origin.y = self.frame.size.height
            self.tableViewOptions.frame = newFrame
        }) { (finished) in
            self.removeFromSuperview()
        }
    }

    // MARK: - Button Clicks
    // MARK: -
    @objc private func btnCancelActionSheetClick(sender: Any?) {
        if let blockHandler = self.blockHandler {
            blockHandler(-1, true)
        }
        self.dissmissActionSheet()
    }
    
    @objc private func btnDismissActionSheetClick(sender: Any?) {
        if let blockHandler = self.blockHandler {
            blockHandler(self.selectedIndex, true)
        }
        self.dissmissActionSheet()
    }
    
    // MARK: - Show/Hide ActionSheet
    // MARK: -
    
    func showWith(selectorActionSheetBlock handler: DbSelectorActionBlock?) -> Void {
        let inController = UIApplication.shared.keyWindow?.rootViewController
        self.showIn(inController!, selectorActionSheetBlock: handler)
    }
    
    func showIn(_ inController: UIViewController, selectorActionSheetBlock handler: DbSelectorActionBlock?) -> Void {
        self.blockHandler = handler
        
        // Calculate frame for dismiss button
        let frame = inController.view.frame
        self.frame = frame;
        self.btnDismiss.frame = self.frame
        
        // Calculate Height for TableView
        var optionsHeight = ((self.otherTitles.count > 4) ? 4 : self.otherTitles.count) * Sas.CELL_HEIGHT
        // Give extra space to indicate that table view is scrollable if more than 4 options available
        // extraHeight will help to show 4 and a half options
        var extraHeight = (self.otherTitles.count > 4) ? 20 : 0
        
        if self.otherTitles.count <= 4 {
            optionsHeight = 4 * Sas.CELL_HEIGHT
            extraHeight = 0
        }
        
        //    CGFloat totalHeight = TITLE_VIEW_HEIGHT + DISMISS_BUTTON_HEIGHT + optionsHeight + extraHeight;
        let totalHeight = Sas.TITLE_VIEW_HEIGHT + optionsHeight + extraHeight
        // Defalut set table frame to out of screen
        let tableFrame = CGRect(x: 0, y: frame.size.height.db_int, width: frame.size.width.db_int, height: totalHeight)

        self.tableViewOptions.frame = tableFrame
    
        inController.view.addSubview(self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0.3)
            
            // Animate TableView from bottom
            var newFrame = self.tableViewOptions.frame
            newFrame.origin.y = frame.size.height - totalHeight.db_cgFloat
            self.tableViewOptions.frame = newFrame;
            
        }) { (finished) in
            
        }
        self.tableViewOptions.reloadData()
    }
    
}

extension DbSelectorActionSheet: UITableViewDataSource {
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.otherTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId") ?? UITableViewCell(style: .default, reuseIdentifier: "CellId")

        var viewSeperator = cell.contentView.viewWithTag(1111)
        if viewSeperator == nil {
            viewSeperator = UIView(frame: CGRect(x: 0, y: Sas.CELL_HEIGHT - 1, width: self.frame.size.width.db_int, height: 1))
            viewSeperator?.backgroundColor = UIColor.init(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
            viewSeperator?.tag = 1111
            cell.contentView.addSubview(viewSeperator!)
        }
        
        var imgView = cell.contentView.viewWithTag(1234) as? UIImageView
        if imgView == nil {
            imgView = UIImageView.init(frame: CGRect(x: self.frame.size.width.db_double - 40.0, y: Double(Sas.CELL_HEIGHT-20)/2, width: 20.0, height: 20.0))
            imgView?.backgroundColor = UIColor.clear
            imgView?.tag = 1234
            cell.contentView.addSubview(imgView!)
        }
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = Sas.OptionTextColor
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.text = self.otherTitles[indexPath.row]
        cell.selectionStyle = .none;
        
        // Check for selected/ non-selected row
        if self.selectedIndex == indexPath.row {
            cell.textLabel?.textColor = Sas.SeletedOptionTextColor;
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            imgView?.image = Sas.ImageChecked
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            imgView?.image = Sas.ImageUnCheck
        }

        return cell
    }
    
}


extension DbSelectorActionSheet: UITableViewDelegate {
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        let cell = tableView.cellForRow(at: indexPath)
        if let imageView = cell?.contentView.viewWithTag(1234) as? UIImageView {
            cell?.textLabel?.textColor = Sas.SeletedOptionTextColor
            imageView.image = Sas.ImageChecked
        }
        //if dismiss on select is active
        if dismissOnSelect {
            if let blockHandler = self.blockHandler {
                blockHandler(self.selectedIndex, false)
            }
            self.dissmissActionSheet()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Unselect this cell
        let cell = tableView.cellForRow(at: indexPath)
        if let imageView = cell?.contentView.viewWithTag(1234) as? UIImageView {
            cell?.textLabel?.textColor = Sas.OptionTextColor
            imageView.image = Sas.ImageUnCheck
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Sas.CELL_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Sas.TITLE_VIEW_HEIGHT)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: Int(self.frame.size.width), height: Sas.TITLE_VIEW_HEIGHT)))
        view.backgroundColor = Sas.ActionSeparatorColor
        
        let lblTitle = UILabel(frame: CGRect(origin: CGPoint(x: 10.0, y: 0), size: CGSize(width: Int(self.frame.size.width - 10), height: Sas.TITLE_VIEW_HEIGHT)))
        
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.textColor = Sas.ActionTitleColor
        // lblTitle.font = UIFont.init(name: "HelveticaNeue", size: CGFloat(Sas.ActionTitleFontSize))
        lblTitle.font = UIFont.systemFont(ofSize: CGFloat(Sas.ActionTitleFontSize))
        lblTitle.textAlignment = .left
        lblTitle.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        lblTitle.text = title
        view.addSubview(lblTitle)
        
        return view
    }
}
