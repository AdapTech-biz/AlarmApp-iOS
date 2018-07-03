//
//  PostAlarmActivityCollectionViewController.swift
//  AlarmTest
//
//  Created by Xavier Davis on 6/21/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ActivityCell"
private var activityList = ActivityList.activity
//private var numActivities = activn
private var selectedActivites = Array<String>()

class PostAlarmActivityViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityCounter: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Register cell classes
        let nib = UINib(nibName: "PostAlarmActivityCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
//        collectionView.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "collectionfooter")
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.

        setupLayout()
        activityCounter.text = "(\(selectedActivites.count))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    func setupLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
        
    }

    func removeActivity(at indextPath: IndexPath){
        
        selectedActivites.append(activityList[indextPath.row])
        activityCounter.text = "(\(selectedActivites.count))"
        activityList.remove(at: indextPath.row)
        var paths = Array<IndexPath>()
        paths.append(indextPath)
        collectionView.performBatchUpdates({
            
        self.collectionView.deleteItems(at: paths)
            
        }, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ActivityDurationViewController
        destinationVC.activitiesToSetUp = selectedActivites
    }

}

extension PostAlarmActivityViewController: UICollectionViewDelegateFlowLayout{



    
    //MNARK: UICollectionViewDelegateFlowLoyout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((view.frame.width/2)-5), height: 100)
    }
    
    
    
}

extension PostAlarmActivityViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
        // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostAlarmActivityCell
        
        // Configure the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                let activityCell = cell as! PostAlarmActivityCell
                activityCell.taskTitle.text = activityList[indexPath.row]


    }
    
    //
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionFooter:
            //3
            print("footer register here")
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "collectionfooter",
                                                                             for: indexPath)
            return footerView
        default:
            let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "blankHeader",
                                                                             for: indexPath)
            return headerview
        }
    }
    
    //assigns spacing for footer section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 61)
    }
    
    


    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                print(activityList[indexPath.row])
                removeActivity(at: indexPath)
    }
    
}
