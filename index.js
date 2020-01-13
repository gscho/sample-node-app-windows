var app = require('./app');
var http = require('http');
var nconf = require('nconf');

nconf.file({ file: process.argv[2] });

var port = nconf.get('port');
app.set('port', port);

var server = http.createServer(app);
server.listen(port);
