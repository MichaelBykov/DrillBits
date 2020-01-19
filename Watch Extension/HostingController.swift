//
//  HostingController.swift
//  Watch Extension
//
//  Created by Michael Bykov on 1/17/20.
//  Copyright © 2020 Lepario. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<DrillBitView> {
    override var body: DrillBitView {
        return DrillBitView()
    }
}
