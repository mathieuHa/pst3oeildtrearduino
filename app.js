var http = require('http');
var fs = require('fs');

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
		
	var move = spawn('python', ['/home/pi/pst3/pt.py', val]);
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


// Quand un client se connecte, on le note dans la console
io.sockets.on('connection', function (socket) {
    socket.emit('message', 'Vous êtes bien connecté !');
    
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
});


server.listen(8080);
