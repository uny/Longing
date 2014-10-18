//
//  Communicate.swift
//  Longing
//
//  Created by Yuki Nagai on 10/18/14.
//  Copyright (c) 2014 Yuki Nagai. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Communicate : NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    let serviceType = "Longing"
    let keywordsKey = "keywords"
    let userKey = "user"
    let usernameKey = "username"
    let uidKey = "uid"
    let advertiser : MCNearbyServiceAdvertiser
    let session : MCSession
    let browser : MCNearbyServiceBrowser
    
    var delegate: CommunicateDelegate!
    
    override init() {
        let peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        session = MCSession(peer: peerID)
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        super.init()
        session.delegate = self
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
    
    func search() {
        browser.delegate = self
        browser.startBrowsingForPeers()
    }
    
    // MARK: - Delegates
    // MARK: MCNearbyServiceAdvertiserDelegate
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        invitationHandler(true, session)
    }
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
    }
    // MARK: MCNearbyServiceBrowserDelegate
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 0)
    }
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
    }
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println(error)
    }
    // MARK: MCSessionDelegate
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        if state == .Connected {
            // After connected, send keywords and profile data
            let user = User()
            let data = [
                keywordsKey: Keyword.all(),
                userKey: [
                    usernameKey: user.username,
                    uidKey: user.uid
                ]
            ] as NSDictionary
            var error : NSError?
            session.sendData(NSKeyedArchiver.archivedDataWithRootObject(data), toPeers: [peerID], withMode: .Reliable, error: &error)
        }
    }
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        let info = NSKeyedUnarchiver.unarchiveObjectWithData(data) as NSDictionary
        let keywords = Keyword.intersect(info[keywordsKey] as [String])
        if !keywords.isEmpty {
            if let userInfo = info[userKey] as? Dictionary<String, String> {
                let user = User(username: userInfo[usernameKey]!, uid: userInfo[uidKey]!)
                delegate.communicate(self, matched: user, keywords: keywords)
                browser.stopBrowsingForPeers()
            }
        }
    }
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
    }
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError) {
    }
    
    // MARK: - Private functions
}

protocol CommunicateDelegate : NSObjectProtocol {
    // func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!)
    func communicate(communicate: Communicate!, matched user: User, keywords: [String])
}
