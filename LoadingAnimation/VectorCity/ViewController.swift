//
//  ViewController.swift
//  VectorCity
//
//  Created by Steven Curtis on 15/07/2020.
//  Copyright © 2020 Steven Curtis. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var city: UIImageView!
    @IBOutlet private weak var city2: UIImageView!
    @IBOutlet private weak var manImage: UIImageView!
    @IBOutlet private weak var tree0: UIImageView!
    private var manImageList = [UIImage]()

    @IBAction private func viewButton(_ sender: UIButton) {
        let vc = ProgrammaticViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func constraintsButton(_ sender: UIButton) {
        let vc = ProgrammaticConstraintsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 238/255, green: 240/255, blue: 238/255, alpha: 1.0)
        
        for i in 0...3 {
            guard let img = UIImage(named: String(i)) else {return}
            manImageList.append(img)
            if i == 3 {
                self.manImage.animationImages = self.manImageList
                self.manImage.animationDuration = 0.50
                self.manImage.startAnimating()
            }
        }
    }

    // If added to the Storyboard, have to use viewDidAppear NOT something before in the lifecycle

    override func viewDidAppear(_ animated: Bool) {
        animate(duration: 8.0, delay: 0.0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.20, delay: 0, options: [], animations: {
            self.tree0.alpha = 0.0
            self.city2.alpha = 0.0
            self.city.alpha = 0.0
            self.manImage.alpha = 0.0
        }, completion: nil)
    }
    
    private func animate(duration: TimeInterval, delay: TimeInterval) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.tree0.alpha = 1.0
            self.city.alpha = 1.0
            self.city2.alpha = 1.0
            self.manImage.alpha = 1.0
            }, completion: nil)
        
        // tree must disappear off the screen, so -50
        let treeAnimation = CABasicAnimation(keyPath: "position.x")
        treeAnimation.duration = duration
        let treeMid: Double = Double(self.city.frame.size.width)
        treeAnimation.fromValue = NSNumber(value: treeMid)
        treeAnimation.toValue = NSNumber(value: -50 )
        treeAnimation.repeatCount = .infinity
        self.tree0.layer.add(treeAnimation, forKey: "basic")
        
        let firstCityAnimation = CABasicAnimation(keyPath: "position.x")
        firstCityAnimation.duration = duration
        firstCityAnimation.fromValue = NSNumber(value: 0.0)
        firstCityAnimation.toValue = NSNumber(value: -1 * Int(self.city.frame.size.width))
        firstCityAnimation.repeatCount = .infinity
        self.city.layer.add(firstCityAnimation, forKey: "basic")

        let secondCityAnimation = CABasicAnimation(keyPath: "position.x")
        secondCityAnimation.duration = duration
        secondCityAnimation.fromValue = NSNumber(value: Int(self.city.frame.size.width) )
        secondCityAnimation.toValue = NSNumber(value: 0 )
        secondCityAnimation.repeatCount = .infinity
        self.city2.layer.add(secondCityAnimation, forKey: "basic")
    }
}
