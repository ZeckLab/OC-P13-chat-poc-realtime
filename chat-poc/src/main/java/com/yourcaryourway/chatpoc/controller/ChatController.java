package com.yourcaryourway.chatpoc.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import com.yourcaryourway.chatpoc.dto.ChatMessage;

@Controller
public class ChatController {

    @MessageMapping("/send")    // Handle messages sent to /app/send
    @SendTo("/topic/messages")  // Broadcast to all subscribers
    public ChatMessage broadcastMessage(ChatMessage message) {
        return message;
    }
}