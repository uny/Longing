//
//  Communicate.swift
//  Longing
//
//  Created by Yuki Nagai on 10/18/14.
//  Copyright (c) 2014 Yuki Nagai. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Communicate : NSObject, MCNearbyServiceBrowserDelegate {
    let serviceType = "Longing"
    let advertiserAssistant : MCAdvertiserAssistant
    let nearbyBrowser : MCNearbyServiceBrowser
    
    override init() {
        let peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        let session = MCSession(peer: peerID)
        advertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)
        advertiserAssistant.start()
        nearbyBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
    }
    
    func search() {
        nearbyBrowser.delegate = self
        nearbyBrowser.startBrowsingForPeers()
    }
    
    // MARK: - Delegates
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        println(peerID)
    }
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
    }
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println(error)
    }
}
