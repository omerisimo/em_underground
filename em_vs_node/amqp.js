var amqp = require('amqp'); 

var connection = amqp.createConnection(); 
connection.on('ready', function() {
  connection.queue('hello_queue', function(queue) { 
    queue.subscribe(function(payload) {
      console.log("Received message: " + payload.body);
      connection.disconnect();
    });
  });

  var exchange = connection.exchange();
  exchange.publish('hello_queue', { body: 'Hello World!'}); 
});