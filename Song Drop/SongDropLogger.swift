//
//  SongDropLogger.swift
//  Song Drop
//
//  Created by Timothy Spencer on 3/4/24.
//

import Foundation

enum LogType: String {
    case info, error
}

func INFO(_ message: String) {
    let infoMessage = Message(content: message, type: .info)
    SongDropAppManager.shared.global.logger.log(infoMessage)
}

func ERROR(_ message: String) {
    let errorMessage = Message(content: message, type: .error)
    SongDropAppManager.shared.global.logger.log(errorMessage)
}

struct Message {
    // Message for the log.
    var content: String
    var type: LogType
}

class SongDropLogger {
    func log(_ message: Message) {
        print(message.content)
    }
}
