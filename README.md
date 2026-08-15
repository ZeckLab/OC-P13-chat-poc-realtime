# Real-Time Chat Application (Angular + Spring WebSocket/STOMP)

A minimal full-stack chat application demonstrating real-time messaging using:
- **Angular** with **STOMP.js** and **Signals**
- **Spring Boot** with **WebSocket + STOMP**
- Simple message broadcasting between connected clients

---

## 🚀 Features
- Live chat between multiple browser clients  
- WebSocket/STOMP communication  
- Angular signals for reactive UI updates  
- Lightweight Spring controller broadcasting messages to `/topic/messages`

---

## 🛠 Technologies

### Front-end
- Angular 21  
- STOMP.js  
- TypeScript  
- Signals API  

### Back-end
- Spring Boot 4.1  
- WebSocket / STOMP  
- Java 21  

---

## ▶️ How to Run

### 1. Start the Back-end (Spring Boot)

Build the project:

```bash
cd chat-poc
mvn clean install
```

Run the application:
```bash
mvn spring-boot:run
```

Backend runs on: http://localhost:8080  
WebSocket endpoint: ws://localhost:8080/ws/chat

### 2. Start the Front-end (Angular)

```bash
cd chat-front
npm install
ng serve
```

Frontend runs on: http://localhost:4200

### 3. Set Up the Database (PostgreSQL)

Note: the chat PoC itself does not require a database (messages are not persisted). This schema is provided for the full application's data layer, as required by the project deliverables.

The `database/` folder contains the full relational schema for the application (not limited to the chat feature).

```bash
psql -U <your_user> -d <your_database> -f database/schema_your_car_your_way.sql
```

Requires PostgreSQL 18.4.

## Usage

1. Open http://localhost:4200 in two browser tabs
2. Enter a username
3. Send messages
4. Messages appear instantly in both tabs (real-time)

## Project Structure

```bash
root/
 ├── chat-front/   # Angular application
 ├── chat-poc/     # Spring Boot application
 └── database/     # PostgreSQL schema for the full application
```

---

## Purpose

This project is a simple proof-of-concept showing how to integrate Angular and Spring Boot using WebSocket/STOMP for real-time communication.