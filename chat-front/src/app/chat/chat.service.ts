import { Injectable, signal } from '@angular/core';
import { Client, IMessage } from '@stomp/stompjs';
import { ChatMessage } from './chat-message.model';

@Injectable({
  providedIn: 'root'
})
export class ChatService {

  private readonly client: Client;

  messages = signal<ChatMessage[]>([]);

  constructor() {
    // Configure STOMP client with WebSocket endpoint
    this.client = new Client({
      brokerURL: 'ws://localhost:8080/ws/chat',
      reconnectDelay: 5000, // auto-reconnect
      debug: (str) => console.log(str) // STOMP debug logs
    });
  }

  connect() {
    // Called when STOMP connection is established
    this.client.onConnect = () => {
      // Subscribe to broadcasted chat messages
      this.client.subscribe('/topic/messages', (msg: IMessage) => {
        const data: ChatMessage = JSON.parse(msg.body);
        this.messages.update(list => [...list, data]);
      });
    };

    // Activate STOMP client and open WebSocket
    this.client.activate();
  }

  send(message: ChatMessage) {
    // Publish message to backend STOMP endpoint
    this.client.publish({
      destination: '/app/send',
      body: JSON.stringify(message)
    });
  }
}
