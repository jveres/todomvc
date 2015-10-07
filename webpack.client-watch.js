var path = require('path');
var webpack = require('webpack');

module.exports = {
  devtool: 'eval',
  entry: [
    'webpack-hot-middleware/client?overlay=false&reload=true',
    './src/client/app'
  ],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: ''
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
  ],
  resolve: {
    extensions: ['', '.js', '.jsx', '.imba'],
		modulesDirectories: [
			"src/client",
			"node_modules",
		]
  },
  module: {
    loaders: [
      {
        test: /\.jsx/, loader: 'babel', include: path.join(__dirname, 'src/client'), exclude: /node_modules/
      }, { 
        test: /\.imba/, loader: 'imba', include: path.join(__dirname, 'src/client')
      }, {
        test: /\.css/, loader: "style!css!autoprefixer", include: path.join(__dirname, 'src/client')
      }
    ]
  }
};
