var path = require('path');
var express = require('express');
var app = express();

if (process.env.NODE_ENV !== 'production') {
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
}

var Gun = require('gun');
Gun.log.verbose = process.env.NODE_ENV !== 'production';
var gun = Gun({
	file: 'data.json',
	s3: {
		key: '', // AWS Access Key
		secret: '', // AWS Secret Token
		bucket: '' // The bucket you want to save into
	}
});

gun.attach(app);
app.use(express.static(__dirname));

var port = (process.env.NODE_ENV !== 'production' ? '4000' : '3000');
var host = (process.env.NODE_ENV !== 'production' ? '0.0.0.0' : 'localhost');

app.listen(port, host, function(err) {
  if (err) {
    console.log(err);
    return;
  }
  console.log('Listening at http://' + host + ':' + port);
});
