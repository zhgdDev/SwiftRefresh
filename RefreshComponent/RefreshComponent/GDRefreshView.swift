//
//  GDRefreshView.swift
//  RefreshComponent
//
//  Created by hhuc on 2019/1/20.
//  Copyright © 2019 hhuc. All rights reserved.
//

import UIKit

class GDRefreshView: UIView {

    //指示器
    @IBOutlet weak var tipIcon: UIImageView!
    //提示文案
    @IBOutlet weak var tipLabel: UILabel!
    //提示器
 //   @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var refreshState:GDRefreshState = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                tipIcon.isHidden = false
                indicator.stopAnimating()

                tipLabel.text = "继续使劲拉..."
                UIView.animate(withDuration: 0.3) {
                    //self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI - 0.001))
                    self.tipIcon.transform = CGAffineTransform.identity
                }

            case .Pulling:
                tipLabel.text = "放手即可刷新..."
                UIView.animate(withDuration: 0.3) {
                    self.tipIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI - 0.001))
                }

            case .WillRefresh:
                tipLabel.text = "正在刷新中..."
                tipIcon.isHidden = true
                indicator.startAnimating()

            }
        }
    }

    
    class func refreshView() -> GDRefreshView {
        let nib = UINib(nibName: "GDRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! GDRefreshView
        
        
    }
}
