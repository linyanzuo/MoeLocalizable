//
//  UIKit+NameSpace.swift
//  MoeCommon
//
//  Created by Zed on 2019/11/19.
//

// MARK: UIViewController

public extension TypeWrapperProtocol where WrappedType: UIViewController {
    /// 呈现模态视图(Model Present)时，清除其背景色
    func clearPresentationBackground()  {
        wrappedValue.providesPresentationContextTransitionStyle = true
        wrappedValue.definesPresentationContext = true
        wrappedValue.modalPresentationStyle = .overCurrentContext
    }
}


// MARK: UIApplication

public extension TypeWrapperProtocol where WrappedType: UIApplication {
    /// 返回指定控制器中，控制器层级最高(正在交互)的控制器
    /// - Parameter base: 指定的控制器
    static func topViewController(
        base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController)
        -> UIViewController?
    {
        if let nav = base as? UINavigationController
        { return topViewController(base: nav.visibleViewController) }
        
        if let tab = base as? UITabBarController {
            let moreNav = tab.moreNavigationController
            
            if let top = moreNav.topViewController, top.view.window != nil
            { return topViewController(base: top) }
            else if let selected = tab.selectedViewController
            { return topViewController(base: selected) }
        }
        
        if let presented = base?.presentedViewController
        { return topViewController(base: presented) }
        
        return base
    }
}
