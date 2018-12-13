//
//  analyzerWrapper.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

import Foundation
class analyzerWrapper{
    private static let _analyzer = analyzer()
    static func share()->analyzer{
        return _analyzer
    }
}
