//
//  SceneDelegate.swift
//  Converter
//
//  Created by Victor Mashukevich on 21.10.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let tabBarController = TabBarController()
          
          guard let windowScene = (scene as? UIWindowScene) else {return}
          window = UIWindow(frame: windowScene.coordinateSpace.bounds)
          window?.windowScene = windowScene
          window?.rootViewController = tabBarController
          window?.makeKeyAndVisible()
      }


}

