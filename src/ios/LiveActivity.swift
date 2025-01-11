// Live Activity Manager
// Created by Ivan Bystrov on 2025

import Foundation
import ActivityKit

@objc public class LiveActivityManager: NSObject {
    @objc public static func observePushToStartToken() {
        if #available(iOS 17.2, *), ActivityAuthorizationInfo().areActivitiesEnabled {
            Task {
                for await data in Activity<OrderAttributes>.pushToStartTokenUpdates {
                    let token = data.map { String(format: "%02x", $0) }.joined()
                    print("Push-to-Start Token: \(token)")
                    // Отправьте токен на сервер
                }
            }
        }
    }
    
    @objc public static func startLiveActivity(orderId: String, orderNum: String, orderStatus: String, orderState: Int) {
        let currOrder = orderId
        let attributes = OrderAttributes(orderId: orderId, orderNum: orderNum)
        let initialContentState = OrderAttributes.ContentState(
            orderStatus: orderStatus,
            orderState: orderState
        )

        do {
            let activity = try Activity<OrderAttributes>.request(
                attributes: attributes,
                content: ActivityContent(state: initialContentState, staleDate: nil),
                pushType: .token
            )
            print("Live Activity started with ID: \(activity.id)")
            if let pushToken = activity.pushToken {
                let tokenString = pushToken.map { String(format: "%02x", $0) }.joined()
                print("Push token: \(tokenString)")
                sendPushToStartTokenToServer(tokenString, order: currOrder)
            } else {
                print("Failed to get push token immediately. Waiting for updates...")
            }
            Task {
                for await pushToken in activity.pushTokenUpdates {
                    let pushTokenString = pushToken.reduce("") {
                          $0 + String(format: "%02x", $1)
                    }
                    print("New push token: \(pushTokenString)")
                    sendPushToStartTokenToServer(pushTokenString, order: currOrder)
                }
            }
        } catch {
            print("Failed to start Live Activity: \(error.localizedDescription)")
        }
    }
    
    // Метод для обновления Live Activity
    @objc public static func updateLiveActivity(orderStatus: String, orderState: Int) {
        Task {
            let contentState = Activity<OrderAttributes>.ContentState(
                orderStatus: orderStatus,
                orderState: orderState
            )
            
            for activity in Activity<OrderAttributes>.activities {
                do {
                    if #available(iOS 17.0, *) {
                        // Новый метод для iOS 17.0+
                        try await activity.update(
                            ActivityContent<OrderAttributes.ContentState>(
                                state: contentState,
                                staleDate: Date.now + 15
                            )
                        )
                    } else {
                        // Старый метод для iOS 16.1
                        try await activity.update(using: contentState)
                    }
                    print("Live Activity updated successfully for activity ID: $activity.id)")
                } catch {
                    print("Error updating Live Activity: $error)")
                }
            }
        }
    }

    private static func sendPushToStartTokenToServer(_ token: String, order: String) {
        let url = URL(string: "https://your_domain.com/path/to")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["token": token, "order": order]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to send token: \(error.localizedDescription)")
            } else {
                print("Token sent successfully")
            }
        }.resume()
    }
}