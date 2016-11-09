//
//  TYRefreshControl.swift
//
//  Created by thomasTY on 16/9/30.
//  Copyright © 2016年 thomasTY. All rights reserved.
//

import UIKit

private let RefreshControlHeight: CGFloat = 50

private enum RefreshType: Int
{
    
    case normal = 0
    
    case pulling = 1
    
    case refreshing = 2
    
}

class TYRefreshControl: UIControl
{
    
    private var currentScrollView: UIScrollView?
    
    private var refreshType: RefreshType = .normal{
        didSet
        {
            switch refreshType
            {
            case .normal:
                print("dropDown")
                
                pullDownImageView.isHidden = false
                UIView .animate(withDuration: 0.25, animations: {
                    self.pullDownImageView.transform = CGAffineTransform.identity
                })
                indicatorView.stopAnimating()
                messageLabel.text = "dropDown"
                if oldValue == .refreshing
                {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.currentScrollView?.contentInset.top  -= RefreshControlHeight
                    })
                }
            case .pulling:
                print("gripToRefresh")
                messageLabel.text = "gripToRefresh"
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.pullDownImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                })
            case .refreshing:
                print("refreshing")
                pullDownImageView.isHidden = true
                indicatorView.startAnimating()
                messageLabel.text = "refreshing"
                UIView.animate(withDuration: 0.25, animations: {
                    self.currentScrollView?.contentInset.top += RefreshControlHeight
                })
                
                sendActions(for: UIControlEvents.valueChanged)
            }
        }
    }
    
    fileprivate lazy var pullDownImageView: UIImageView = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
    
    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "dropDown"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.gray
        return label
    }()
    
    fileprivate lazy var indicatorView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        let screenWidth = UIScreen.main.bounds.width
        self.frame = CGRect(x: 0, y: -RefreshControlHeight, width: screenWidth, height: RefreshControlHeight)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI()
    {
        self.backgroundColor = UIColor.red
        
        addSubview(pullDownImageView)
        addSubview(messageLabel)
        addSubview(indicatorView)
        
        pullDownImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: pullDownImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -35))
        addConstraint(NSLayoutConstraint(item: pullDownImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: pullDownImageView, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: pullDownImageView, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: pullDownImageView, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: pullDownImageView, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
    func endRefreshing()
    {
        refreshType = .normal
    }
    
    override func willMove(toSuperview newSuperview: UIView?)
    {
        if let scrollView = newSuperview as? UIScrollView
        {
            
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            self.currentScrollView = scrollView
            
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        
        guard let scrollView = currentScrollView else
        {
            return
        }
        
        let maxY = -(scrollView.contentInset.top + RefreshControlHeight)
        let contentOffSetY = scrollView.contentOffset.y
        
        
        if scrollView.isDragging
        {
            
            if contentOffSetY <= maxY && refreshType == .normal
            {
                
                refreshType = .pulling
                print("pulling")
                
            }else if contentOffSetY > maxY && refreshType == .pulling
            {
                refreshType = .normal
                print("normal")
            }
        }else
            
        {
            
            if refreshType == .pulling
            {
                refreshType = .refreshing
                print("refreshing")
            }
        }
    }
    
    deinit
    {
        currentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
}
