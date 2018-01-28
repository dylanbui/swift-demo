//
//  DbSelectorActionSheet.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/28/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

let sas_CELL_HEIGHT             = 50

let sas_TITLE_VIEW_HEIGHT       = 35
let sas_DISMISS_BUTTON_HEIGHT   = 65
let sas_ImageChecked            = UIImage(named: "sas_checked.png")
let sas_ImageUnCheck            = UIImage(named: "sas_uncheck.png")

let sas_ActionTitleFontSize     = 14.5
let sas_ActionTitleColor        = UIColor.black
let sas_ActionButtonTitleColor  = UIColor.black

let sas_OptionTextColor = UIColor.init(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0)
let sas_SeletedOptionTextColor = UIColor.init(red: 255.0/255.0, green: 160.0/255.0, blue: 48.0/255.0, alpha: 1.0)
let sas_ActionSeparatorColor  = UIColor.init(red: 232.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0)
let sas_ActionDoneButtonColor  = UIColor.init(red: 0.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: 1.0)


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
    
    func setupDismissView() -> Void {
        self.btnDismiss.backgroundColor = UIColor.clear
        self.btnDismiss.frame = self.frame
        self.btnDismiss.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        self.btnDismiss.addTarget(self, action: #selector(btnCancelActionSheetClick), for: .touchUpInside)
        self.addSubview(self.btnDismiss)
    }
    
    func setupTableView() -> Void {
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
    
    func dissmissActionSheet() -> Void {
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
    @objc func btnCancelActionSheetClick(sender: Any?) {
        if let blockHandler = self.blockHandler {
            blockHandler(-1, true)
        }
        self.dissmissActionSheet()
    }
    
    @objc func btnDismissActionSheetClick(sender: Any?) {
        if let blockHandler = self.blockHandler {
            blockHandler(self.selectedIndex, true)
        }
        self.dissmissActionSheet()
    }
    
    // MARK: - Show/Hide ActionSheet
    // MARK: -
    
    func showIn(_ inController: UIViewController, selectorActionSheetBlock handler: DbSelectorActionBlock?) -> Void {
        self.blockHandler = handler
//        var inController: UIViewController? = inController
//        inController = UIApplication.shared.keyWindow?.rootViewController
        
        // Calculate frame for dismiss button
        let frame = inController.view.frame
        self.frame = frame;
        self.btnDismiss.frame = self.frame
        
        // Calculate Height for TableView
        var optionsHeight = ((self.otherTitles.count > 4) ? 4 : self.otherTitles.count) * sas_CELL_HEIGHT
        // Give extra space to indicate that table view is scrollable if more than 4 options available
        // extraHeight will help to show 4 and a half options
        var extraHeight = (self.otherTitles.count > 4) ? 20 : 0
        
        if self.otherTitles.count <= 4 {
            optionsHeight = 4 * sas_CELL_HEIGHT
            extraHeight = 0
        }
        
        //    CGFloat totalHeight = TITLE_VIEW_HEIGHT + DISMISS_BUTTON_HEIGHT + optionsHeight + extraHeight;
        let totalHeight = sas_TITLE_VIEW_HEIGHT + optionsHeight + extraHeight
        // Defalut set table frame to out of screen
        let tableFrame = CGRect(x: 0, y: Int(frame.size.height), width: Int(frame.size.width), height: totalHeight)

        self.tableViewOptions.frame = tableFrame
    
        inController.view.addSubview(self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0.3)
            
            // Animate TableView from bottom
            var newFrame = self.tableViewOptions.frame
            newFrame.origin.y = CGFloat(Int(frame.size.height) - totalHeight)
            self.tableViewOptions.frame = newFrame;
            
        }) { (finished) in
            
        }
        self.tableViewOptions.reloadData()
    }
    
    
    
    
    
}

extension DbSelectorActionSheet: UITableViewDataSource {
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.otherTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        configureCell(cell: cell, forRowAt: indexPath)
        return cell
        
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
//
//        UIView *viewSeperator = [cell.contentView viewWithTag:1111];
//        if (!viewSeperator) {
//            viewSeperator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 44.0, self.frame.size.width, 1.0)];
//            viewSeperator.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
//            viewSeperator.tag = 1111;
//            viewSeperator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//            [cell.contentView addSubview:viewSeperator];
//        }
//
//        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1234];
//        if (!imgView) {
//            //        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 11.0, 20.0, 20.0)];
//            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 40.0, (CELL_HEIGHT-20)/2, 20.0, 20.0)];
//            imgView.backgroundColor = [UIColor clearColor];
//            imgView.tag = 1234;
//            [cell.contentView addSubview:imgView];
//        }
//
//        cell.textLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:14.0];
//        cell.textLabel.backgroundColor = [UIColor clearColor];
//        cell.textLabel.textColor = kYOptionTextColor;
//        cell.textLabel.textAlignment = NSTextAlignmentLeft;
//        cell.textLabel.text = [otherTitles objectAtIndex:indexPath.row];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        // Check for selected/ non-selected row
//        if (self.selectedIndex == indexPath.row){
//            cell.textLabel.textColor = kYSeletedOptionTextColor;
//            cell.textLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.0];
//            [imgView setImage:kYImageChecked];
//            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//        }
//        else
//        [imgView setImage:kYImageUnCheck];
//
//        return cell;
        
        
        
    }
    
    func configureCell(cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
}


extension DbSelectorActionSheet: UITableViewDelegate {
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        let cell = tableView.cellForRow(at: indexPath)
        if let imageView = cell?.contentView.viewWithTag(1234) as? UIImageView {
            cell?.textLabel?.textColor = sas_SeletedOptionTextColor
            imageView.image = sas_ImageChecked
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
            cell?.textLabel?.textColor = sas_OptionTextColor
            imageView.image = sas_ImageUnCheck
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(sas_CELL_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(sas_TITLE_VIEW_HEIGHT)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: Int(self.frame.size.width), height: sas_TITLE_VIEW_HEIGHT)))
        view.backgroundColor = sas_ActionSeparatorColor
        
        let lblTitle = UILabel(frame: CGRect(origin: CGPoint(x: 10.0, y: 0), size: CGSize(width: Int(self.frame.size.width - 10), height: sas_TITLE_VIEW_HEIGHT)))
        
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.textColor = sas_ActionTitleColor
        lblTitle.font = UIFont.init(name: "HelveticaNeue", size: CGFloat(sas_ActionTitleFontSize))
        lblTitle.textAlignment = .left
        lblTitle.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        lblTitle.text = title;
        
        return view
    }
}
