import { Component, signal } from '@angular/core';
import { ChatService } from './chat.service';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-chat',
  imports: [FormsModule],
  templateUrl: './chat.html',
  styleUrls: ['./chat.css']
})
export class Chat {

  message = '';
  username = signal<string>('');

  constructor(public chatService: ChatService) {
    // Connect to STOMP/WebSocket on component init
    this.chatService.connect();
  }

  send() {
    // Prevent sending if username or message is empty
    if (!this.username() || !this.message) return;

    // Send message if not blank
    if (this.message.trim()) {
      this.chatService.send({
        user: this.username(),
        content: this.message
      });

      this.message = '';
    }
  }
}
