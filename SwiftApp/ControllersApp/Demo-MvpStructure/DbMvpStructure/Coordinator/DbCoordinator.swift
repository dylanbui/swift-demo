//
//  DbCoordinator.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

// *******************************
// MARK: - DbCoordinator
// *******************************

///  The most basic type of `DbCoordinator`: one that manages other coordinators.

protocol DbCoordinator: class {
    
    /** Any child coordinators to keep track of, to prevent them from getting deallocated in memory. */
    var childCoordinators: [DbCoordinator] { get set }
    
    /** Used for handling startup tasks - think of it as the `viewDidLoad()` of coordinators. */
    func start()
    
}

extension DbCoordinator {
    
    /**
     Adds a child coordinator to the parent, preventing it from getting deallocated in memory.
     
     - Parameter childCoordinator: The coordinator to keep allocated in memory.
     */
    
    func addChildCoordinator(_ childCoordinator: DbCoordinator) {
        childCoordinators.append(childCoordinator)
    }
    
    /**
     Removes a child coordinator from its parent, releasing it from memory.
     
     - Parameter childCoordinator: The coordinator to release.
     */

    func removeChildCoordinator(_ childCoordinator: DbCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
    
}

// *******************************
// MARK: - DbCoordinatorPresentable
// *******************************

///  The underlying protocol for `DbCoordinatorPresentable`.
///
///  - Important:
///  It's usually best to avoid implementing this protocol directly. It acts as a base protocol
///  for `CoordinatorPresentable` to avoid `associatedtype` compiler errors.

protocol DbBaseCoordinatorPresentable: DbCoordinator {
    
    /** The underlying root view controller for `CoordinatorPresentable`. */
    var _rootViewController: UIViewController { get }
    
}

///  A `Coordinator` which also manages a `UIViewController`.

protocol DbCoordinatorPresentable: DbBaseCoordinatorPresentable {
    
    associatedtype ViewController: UIViewController
    
    /** The `Coordinator`'s root view controller. */
    var rootViewController: ViewController { get }
    
}

// `DbBaseCoordinatorPresentable` default implementation

extension DbCoordinatorPresentable {
    
    /** A computed property which simply returns the `rootViewController`. */
    var _rootViewController: UIViewController { return rootViewController }
    
}

// MARK: - Presentation Methods

extension DbCoordinatorPresentable {
    
    /**
     Starts a child coordinator and presents its `rootViewController` modally. This method also retains the `childCoordinator` in memory, which needs to be released upon dismissal.
     
     - Parameters:
        - childCoordinator: The coordinator to present and retain.
        - animated: Specify `true` to animate the transition or `false` if you do not want the transition to be animated.
     */
    
    func presentCoordinator(_ childCoordinator: DbBaseCoordinatorPresentable, animated: Bool) {
        addChildCoordinator(childCoordinator)
        childCoordinator.start()
        rootViewController.present(childCoordinator._rootViewController, animated: animated)
    }
    
    /**
     Dismisses a child coordinator's `rootViewController` which was presented modally, and releases the coordinator from memory.
     
     - Parameters:
        - childCoordinator: The coordinator to dismiss and release.
        - animated: Specify `true` to animate the transition or `false` if you do not want the transition to be animated.
        - completion: The block to execute after the view controller is dismissed.
     */
    
    func dismissCoordinator(_ childCoordinator: DbBaseCoordinatorPresentable, animated: Bool, completion: (() -> Void)? = nil) {
        childCoordinator._rootViewController.dismiss(animated: animated, completion: completion)
        self.removeChildCoordinator(childCoordinator)
    }

}

// *******************************
// MARK: - CoordinatorNavigable
// *******************************

///  Handles the navigation flow between one or more `UIViewController`s and/or `Coordinator`s, pulling the responsibility of navigation one level above.

protocol DbCoordinatorNavigable: DbCoordinatorPresentable {
    
    /** Responsible for the navigation stack between `UIViewController`s. */
    var navigator: DbNavigatorType { get }
    
}

// MARK: - Navigation Methods

extension DbCoordinatorNavigable {
    
    /**
     Starts a child coordinator and pushes its `rootViewController` onto the navigation stack.
     This method also manages retaining and releasing the `childCoordinator` in memory.
     
     - Parameters:
        - childCoordinator: The coordinator to push.
        - animated: Specify `true` to animate the transition or `false` if you do not want the transition to be animated.
     */
    
    func pushCoordinator(_ childCoordinator: DbBaseCoordinatorPresentable, animated: Bool) {
        addChildCoordinator(childCoordinator)
        childCoordinator.start()
        navigator.push(childCoordinator._rootViewController,
                       animated: animated,
                       onPoppedCompletion: { [weak self] in
                        self?.removeChildCoordinator(childCoordinator)
        })
    }
    
}
