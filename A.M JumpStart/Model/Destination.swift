//
//  File.swift
//  A.M JumpStart
//
//  Created by Xavier Davis on 7/18/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import Foundation
import RealmSwift

class Destination: Object {
   @objc dynamic var address = ""
   @objc dynamic var city = ""
   @objc dynamic var state = ""
   @objc dynamic var lat = ""
   @objc dynamic var lon = ""
}
