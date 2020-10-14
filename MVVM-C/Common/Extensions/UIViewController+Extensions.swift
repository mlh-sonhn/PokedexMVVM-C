//
//  UIViewController+Extensions.swift
//  MVVM-C
//
//  Created by SonHoang on 9/25/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit
import RxSwift

enum AlertAction {
    case confirm
    case cancel
}

extension UIViewController {
    
    func showError(title: String?, message: String?, confirmTitle: String?, cancelTitle: String?) -> Observable<AlertAction> {
        return Observable.create { observable -> Disposable in
            
            let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            if let confirmTitle = confirmTitle {
                let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
                    observable.onNext(.confirm)
                    observable.onCompleted()
                }
                alertViewController.addAction(confirmAction)
            }
            
            if let cancelTitle = cancelTitle {
                let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                    observable.onNext(.cancel)
                    observable.onCompleted()
                }
                alertViewController.addAction(cancelAction)
            }
            
            let navigationController = UIViewController.topViewController()?.navigationController
            navigationController?.present(alertViewController, animated: true, completion: nil)
            
            return Disposables.create()
        }
    }
    
}


extension UIViewController {
    
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController) -> UIViewController? {
        if let navigationController = base as? UINavigationController {
            return topViewController(base: navigationController.visibleViewController)
        }
        if let tabBarController = base as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        /// For case present 2 alert controller in 1 time
        if base is UIAlertController {
            return nil
        }
        
        return base
    }
    
}
