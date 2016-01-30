var path = require('path');
var express = require('express');
var app = express();
var Gun = require('gun');

var host, port;

if (process.env.NODE_ENV !== 'production') {
  // development config with HMR
  // hot reload works for both client and server
  host = '0.0.0.0';
  port = 4000;
  
  var webpack = require('webpack');
  var config = require('../../webpack.client-watch.js');
  var compiler = webpack(config);
  
  app.use(require('webpack-dev-middleware')(compiler, {
    noInfo: true,
    progress: true,
    publicPath: config.output.publicPath
  }));
  app.use(require('webpack-hot-middleware')(compiler));
  console.log('webpack-hot-middleware loaded');
  
  Gun.log.verbose = true;
  app.use(express.static(__dirname));
} else {
  // production config (for reverse proxy)
  // you need nginx (or something) to serve static files in production mode
  host = 'localhost';
  port = 3000;
}

var gun = Gun({
	file: 'data.json',
	s3: {
		key: '', // AWS Access Key
		secret: '', // AWS Secret Token
		bucket: '' // The bucket you want to save into
	}
});

gun.wsp(app);

app.listen(port, host, function(err) {
  if (err) {
    console.log(err);
    return;
  }
  console.log('Server listening at http://' + host + ':' + port);
});
