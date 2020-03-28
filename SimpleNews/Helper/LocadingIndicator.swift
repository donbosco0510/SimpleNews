//
//  LocadingIndicator.swift
//  SimpleNews
//
//  Created by okky pribadi on 28/03/20.
//  Copyright © 2020 okky pribadi. All rights reserved.
//


import UIKit

class LoadingIndicator: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupComponents() {
        
        let fullIndicator = UIView()
        fullIndicator.frame = self.frame
        fullIndicator.backgroundColor = .black
        fullIndicator.alpha = 0.5
        
        let indicatorView = UIActivityIndicatorView.init(frame: self.frame)
        indicatorView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        indicatorView.color = .white
        indicatorView.startAnimating()
        
        self.addSubview(fullIndicator)
        self.addSubview(indicatorView)
    }
    
}
