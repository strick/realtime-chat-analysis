const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const { v4: uuidv4 } = require('uuid'); // Import the UUID package
// Trigger workfl

// Initialize the Express app and create an HTTP server from it
const app = express();
const server = http.createServer(app);

// Initialize Socket.io
const io = socketIo(server);

// Serve your static files (like the frontend HTML, CSS, JS)
app.use(express.static('public'));

// Handle a socket connection request from web clients
io.on('connection', (socket) => {
    // Assign a unique ID (terminal ID) to the socket
    let terminalId = uuidv4(); // Generate a unique ID
    socket.terminalId = terminalId; // Store it on the socket object
    let color = '#' + Math.floor(Math.random()*16777215).toString(16); // Generate a random color in hexadecimal
    let deviceName = terminalId;

    //console.log(`Terminal ${terminalId} has connected.`);
    // Listen for 'device connected' event to receive the device name
    socket.on('device connected', (deviceName) => {
        console.log(`${deviceName} with terminal ID ${terminalId} and color ${color} has connected.`);
        deviceName = "HEEE";
    });

    // Emit an event to the connected client with the terminal ID
    socket.emit('welcome', terminalId);

    // Listen for chat messages from the client
    socket.on('chat message', (msg, deviceName) => {
        console.log(`Terminal ${socket.terminalId} received message: ${msg}`);

        // Broadcast the received message to all connected clients, along with the terminal IDs
        io.emit('chat message', { msg, from: deviceName, color:color });
    });

    // Handle when a user disconnects
    socket.on('disconnect', () => {
        console.log(`Terminal ${socket.terminalId} disconnected.`);
    });
});

// Specify the port to listen on
const PORT = process.env.PORT || 3010;
server.listen(PORT, () => {
   var host = server.address().address
   var port = server.address().port
   
   console.log("App listening at http://%s:%s", host, port)

});
