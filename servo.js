var serialport = require("serialport");
var SerialPort = serialport.SerialPort;


sp = new SerialPort("/dev/ttyUSB0", {
              baudrate: 9600,
	     dataBits: 8, 
	     parity: 'none', 
	     stopBits: 1, 
	     flowControl: false 
	});
sp.on("open", function () {
	sp.on("data", function (data) {  
    		console.log(data.toString());
	});
	
});