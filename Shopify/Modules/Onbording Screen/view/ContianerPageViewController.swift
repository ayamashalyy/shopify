//
//  ContianerPageViewController.swift
//  Shopify
//
//  Created by mayar on 29/06/2024.
//

import UIKit

class ContianerPageViewController:  UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        let onboardingImages = ["o3", "o2", "o3"]

        override func viewDidLoad() {
            super.viewDidLoad()
            dataSource = self
                   delegate = self
                   
                   if let initialViewController = contentViewController(at: 0) {
                       setViewControllers([initialViewController], direction: .forward, animated: true, completion: nil)
                   }

        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
               guard let index = (viewController as? OnbordingViewController)?.pageIndex else { return nil }
               let previousIndex = index - 1
               guard previousIndex >= 0 else { return nil }
               return contentViewController(at: previousIndex)
           }
           
           func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
               guard let index = (viewController as? OnbordingViewController)?.pageIndex else { return nil }
               let nextIndex = index + 1
               guard nextIndex < onboardingImages.count else {
                 //  transitionToSplashScreen()
                   return nil
                   
               }
               return contentViewController(at: nextIndex)
           }
           
         
           
           func contentViewController(at index: Int) -> OnbordingViewController? {
               guard index >= 0 && index < onboardingImages.count else { return nil }
               let contentViewController = storyboard?.instantiateViewController(withIdentifier: "page1") as? OnbordingViewController
               contentViewController?.pageIndex = index
               contentViewController?.imageFileName = onboardingImages[index]
               return contentViewController
           }
        


    }
