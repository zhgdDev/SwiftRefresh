//
//  GDRefershControl.swift
//  RefreshComponent
//
//  Created by hhuc on 2019/1/20.
//  Copyright © 2019 hhuc. All rights reserved.
//

import UIKit

//刷新状态临近点
private let GDRefreshOffset:CGFloat = 80

/// 刷新状态
///
/// - Normal: 普通,初始状态什么都不做
/// - Pulling: 超过临界点,如果放松开始刷新
/// - WillRefresh: 用户超过j临近点,并且放手
enum GDRefreshState {
    case Normal
    case Pulling
    case WillRefresh
    
}

//为什么集成UIControl呢?
//因为这样更大空间去封装度
class GDRefershControl: UIControl {

    //此控件适用于UIScrollViewj及子类(weak防止循环引用)
    private weak var scrollView:UIScrollView?
    private var refreshView = GDRefreshView.refreshView()
    
     init() {
        super.init(frame: CGRect())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    //当父视图被移除(nil),它就被移除
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //判断父视图类型
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        //记录父视图
        scrollView = sv
        
        //KVO监听父视图contentOffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    
    override func removeFromSuperview() {
        //superView还存在
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
        //superView不存在
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let sv = scrollView else {
            return
        }
        
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        print(height)
        
        
        if height < 0 {
            return
        }
        
        self.frame = CGRect(x: 0,
                            y:-height ,
                            width: sv.bounds.width,
                            height: height)
        //判断临界点
        if sv.isDragging {
            if height > GDRefreshOffset && refreshView.refreshState == .Normal{
                print("放手刷新")
                refreshView.refreshState = .Pulling
            } else if height <= GDRefreshOffset && refreshView.refreshState == .Pulling {
                print("再使劲")
                refreshView.refreshState = .Normal

            }
            
        } else {
            //放手
            if refreshView.refreshState == .Pulling {
//                print("准备开始刷新")
//                refreshView.refreshState = .WillRefresh
//
//                var inset = scrollView?.contentInset
//                inset?.top = GDRefreshOffset
//                sv.contentInset = inset!
                
                beginRefreshing()
                sendActions(for: .valueChanged)
            }
        }
        
    }
    
    //开始刷新
    func beginRefreshing() {
        print("开始刷新")
        
        //守护
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshState == .WillRefresh {
            return 
        }
        
        //设置刷新状态
        refreshView.refreshState = .WillRefresh
        var inset = sv.contentInset
        inset.top = GDRefreshOffset
        sv.contentInset = inset
    }
    
    //结束刷新
    func endRefreshing() {
        print("结束刷新")
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshState != .WillRefresh {
            return
        }
        
        refreshView.refreshState = .Normal
        
        var inset = sv.contentInset
        inset.top -= GDRefreshOffset
        sv.contentInset = inset
    }
}

extension GDRefershControl {
    private func setupUI()  {
        
        backgroundColor = super.backgroundColor
        //clipsToBounds = true
        addSubview(refreshView)
        
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))

        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))

        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))

        
        
    }
}
