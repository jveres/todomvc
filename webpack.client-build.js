var webpack = require('webpack');

var path = require('path');
var execSync = require('child_process').execSync;

execSync("cp " +  path.join(__dirname, 'src/server/index.html') + " dist" );
execSync("cp " +  path.join(__dirname, 'src/server/server.js') + " dist" );
execSync("cp " +  path.join(__dirname, 'data.json') + " dist ; exit 0" );

module.exports = {
  entry: [
    './src/client/app'
  ],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: ''
  },
  plugins: [
    new webpack.DefinePlugin({'process.env': {'NODE_ENV': JSON.stringify('production')}}),
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin({compress: {warnings: false}}),
    new webpack.optimize.AggressiveMergingPlugin()
  ],
  resolve: {
    extensions: ['', '.js', '.jsx', '.imba'],
		modulesDirectories: [
			"src/client",
			"node_modules"
		]
  },
  module: {
    loaders: [
      {
        test: /\.jsx$/, loader: 'babel', include: path.join(__dirname, 'src/client'), exclude: /node_modules/
      }, { 
        test: /\.imba$/, loader: 'imba', include: path.join(__dirname, 'src/client')
      }, {
        test: /\.css$/, loader: "style!css!autoprefixer", include: path.join(__dirname, 'src/client')
      }
    ]
  }
};
