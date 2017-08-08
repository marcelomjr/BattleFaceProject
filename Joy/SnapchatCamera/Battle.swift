//
//  Battle.swift
//  BattleFace
//
//  Created by Marcelo Martimiano Junior on 30/07/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//
import UIKit

class Battle
{
    private(set) var hostUsername: String
    private(set) var hostProfilePhoto: UIImage?
    private(set) var hostBattleFace: UIImage?
    
    private(set) var guestUsername: String?
    private(set) var guestProfilePhoto: UIImage?
    private(set) var guestBattleFace: UIImage?
    
    private(set) var judgeUsername: String?
    private(set) var judgeProfilePhoto: UIImage?
    
    private(set) var battleStatus: BattleStatus?
    private(set) var winnerUsername: String?
    private(set) var date: String?
    
    enum BattleStatus
    {
        case NotStarted, WaitingForTheGuest, WaitingForTheJudge, JudgeRefused, JudgeVoted
    }
    
    init (hostUsername: String)
    {
        self.hostUsername = hostUsername
    }
    
    func setHost(username: String, profilePhoto: UIImage)
    {
        self.hostUsername = username
        self.hostProfilePhoto = profilePhoto
    }
    
    func setGuest(username: String)
    {
        self.guestUsername = username
        self.guestProfilePhoto = nil
    }
    func setJudge(username: String)
    {
        self.judgeUsername = username
        self.judgeProfilePhoto = nil
    }
    
    func setHostProfilePhoto(photo: UIImage)
    {
        self.hostProfilePhoto = photo
    }
    func setGuestProfilePhoto(photo: UIImage)
    {
        self.guestProfilePhoto = photo
    }
    func setJudgeProfilePhoto(photo: UIImage)
    {
        self.judgeProfilePhoto = photo
    }
}

