//
//  RealmModel.swift
//  EvaluationTestiOS
//
//  Created by Денис Магильницкий on 18.01.2021.
//  Copyright © 2021 Денис Магильницкий. All rights reserved.
//

import Foundation
import RealmSwift

class RealmModel: Object {
    @objc dynamic var searchingText: String = ""
}
