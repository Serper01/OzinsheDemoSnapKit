//
//  ViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 19.02.2024.
//

import UIKit
import SnapKit

class OnboadringViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var onboardingItems: [OnboardingItem] = [
        OnboardingItem(title: "ÖZINŞE-ге қош келдің!",
                       subtitle: "Фильмдер, телехикаялар, ситкомдар, анимациялық жобалар, телебағдарламалар мен реалити-шоулар, аниме және тағы басқалары",
                       image: UIImage(named: "firstSlide")! ),
        OnboardingItem(title: "ÖZINŞE-ге қош келдің!",
                       subtitle: "Кез келген құрылғыдан қара Сүйікті фильміңді  қосымша төлемсіз телефоннан, планшеттен, ноутбуктан қара",
                       image: UIImage(named: "secondSlide")!),
        OnboardingItem(title: "ÖZINŞE-ге қош келдің!",
                       subtitle: "Тіркелу оңай. Қазір тіркел де қалаған фильміңе қол жеткіз",
                       image: UIImage(named: "thirdSlide")!)]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = view.bounds.size
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OnboardingCell.self,forCellWithReuseIdentifier: "Cell")
                
                return collectionView
    }()
    
    let skipButton: UIButton = {
        var skipButton = UIButton()
        skipButton.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        skipButton.setTitle("SKIP".localized(), for: .normal)
        skipButton.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 12)
        skipButton.setTitleColor(UIColor(named: "#111827 - #FFFFFF"), for: .normal)
        skipButton.layer.cornerRadius = 8.0
        skipButton.contentEdgeInsets.right = 16.0
        skipButton.contentEdgeInsets.left = 16.0
        skipButton.addTarget(self, action: #selector(skipOnboarding), for: .touchDown)
        
        return skipButton
    }()
    
    let skipButton2: UIButton = {
        var skipButton2 = UIButton()
        skipButton2.backgroundColor = UIColor(named: "#7E2DFC")
        skipButton2.setTitle("NEXT".localized(), for: .normal)
        skipButton2.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        skipButton2.setTitleColor(.white, for: .normal)
        skipButton2.layer.cornerRadius = 12
        skipButton2.addTarget(self, action: #selector(skipOnboarding), for: .touchDown)
        
        return skipButton2
    }()
    
   lazy var pageControl: UIPageControl = {
        var pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = true
        pageControl.pageIndicatorTintColor = UIColor(named: "#D1D5DB - #4B5563")
        pageControl.currentPageIndicatorTintColor = UIColor(named: "#B376F7")
        pageControl.numberOfPages = onboardingItems.count
        pageControl.currentPage = 0
        
        return pageControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        view.addSubview(collectionView)
        view.addSubview(skipButton)
        view.addSubview(skipButton2)
        view.addSubview(pageControl)
        setupConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          navigationController?.navigationBar.isHidden = true
      }
    
    func setupConstrains(){
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        skipButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(adaptiveSize(for: 60))
            make.right.equalToSuperview().inset(adaptiveSize(for: 16))
            make.height.equalTo(adaptiveSize(for: 24))
        }
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(adaptiveSize(for: 118))
            make.horizontalEdges.equalToSuperview()
        }
        
        skipButton2.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(adaptiveSize(for: 24))
            make.height.equalTo(adaptiveSize(for: 56))
            make.horizontalEdges.equalToSuperview().inset(adaptiveSize(for: 24))
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! OnboardingCell
        
        cell.setData(image: onboardingItems[indexPath.row].image, title: onboardingItems[indexPath.row].title, subtitle: onboardingItems[indexPath.row].subtitle)
        
        return cell
    }
func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       if indexPath.row == 2 {
           skipButton2.isHidden = false
           skipButton.isHidden = true
       } else {
           skipButton2.isHidden = true
           skipButton.isHidden = false
       }
   }

   func scrollViewDidScroll(_ scrollView: UIScrollView) {
     let offSet = scrollView.contentOffset.x
     let width = scrollView.frame.width
     let currentIndex = Int(round(offSet/width))
     
      pageControl.currentPage = currentIndex
   }
   
   @objc func skipOnboarding(){
       let logInVC = LogInViewController()
       navigationController?.pushViewController(logInVC, animated: true)
   }
    
   
}

