//
//  SearchBox.swift
//  WrocNav
//
//  Created by Kacper Raczy on 12.12.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

fileprivate let kSearchBoxDefaultHeight: CGFloat = 65.0

class SearchBox: UIControl {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var searchFieldView: RoundView!
    
    private var backgroundColorCache: UIColor?
    var backgroundColorWhenSelected: UIColor = UIColor.hexStringToUIColor(hex: "#f5f5f5")
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpXib()
    }
    
    private func setUpXib() {
        let nibName = "\(type(of: self))"
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(contentView)
        configureView()
    }
    
    private func configureView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: kSearchBoxDefaultHeight).isActive = true
    }
    
    // MARK: Touch events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColorCache = searchFieldView.backgroundColor
        searchFieldView.backgroundColor = backgroundColorWhenSelected
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchFieldView.backgroundColor = backgroundColorCache
        super.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendActions(for: .touchUpInside)
        searchFieldView.backgroundColor = backgroundColorCache
        super.touchesEnded(touches, with: event)
    }

}
