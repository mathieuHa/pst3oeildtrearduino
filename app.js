var http = require('http');
var fs = require('fs');

var nbUser = 0;

// Chargement du fichier index.html affiché au client
var server = http.createServer(function(req, res) {
    fs.readFile('./index.html', 'utf-8', function(error, content) {
        res.writeHead(200, {"Content-Type": "text/html"});
        res.end(content);
    });
});

// Chargement de socket.io
var io = require('socket.io').listen(server);
var spawn = require('child_process').spawn;

var Tourner = function(direction, val){
    console.log("Tourner la caméra : " + direction );
        
    var move = spawn('python', ['/home/pi/pst3oeildtrearduino/asserv_arduino.py', val]);
    move.stdout.on('data', (data) => {
      console.log(`stdout: ${data}`);
    });

    move.stderr.on('data', (data) => {
      console.log(`stderr: ${data}`);
    });

    move.on('close', (code) => {
      console.log(`child process exited with code ${code}`);
    });
}

var Control_cam = function(cmd, val, par){
    console.log("Commande de la cam : " + cmd + val + par );

    var control = spawn('sh', ['/home/pi/oeildtre/pst3oeildtrearduino/cam.sh', 'im', 1]);

    control.stdout.on('data', (data) => {
        console.log(`stdout: ${data}`);
});

    control.stderr.on('data', (data) => {
        console.log(`stderr: ${data}`);
});

    control.on('close', (code) => {
        console.log(`child process exited with code ${code}`);
});
}


// Quand un client se connecte, on le note dans la console
io.sockets.on('connection', function (socket) {
    socket.emit('message', 'Vous êtes bien connecté !');
    nbUser++;
    socket.emit('message', nbUser, ' connectés');

    socket.on('picture', function () {
        Control_cam('im','1','');
    })

    socket.on('right', function () {
    Tourner("DROITE",'d');
    });
    socket.on('left', function () {
    Tourner("GAUCHE",'g');
    });
    socket.on('up', function () {
    Tourner("HAUT",'h');
    });
    socket.on('down', function () {
    Tourner("BAS",'b');
    });
    socket.on('up-right', function () {
    Tourner("HAUT-DROITE",'p');
    });
    socket.on('down-left', function () {
    Tourner("BAS-GAUCHE",'w');
    });
    socket.on('down-right', function () {
    Tourner("BAS-DROITE",'n');
    });
    socket.on('up-left', function () {
    Tourner("HAUT-GAUCHE",'a');
    });
    socket.on('center', function () {
    Tourner("Centrer",'c');
    });
    socket.on('light-on', function () {
    Tourner("LIGHT-ON",'l');
    });
    socket.on('light-off', function () {
    Tourner("LIGHT-OFF",'o');
    });
});


server.listen(8080);
