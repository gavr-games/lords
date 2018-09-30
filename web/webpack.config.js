var path = require('path');
var extend = require('extend');
var webpack = require('webpack');

commonConfig = {
  module: {
    loaders: [
        {
            test: /\.js$/,
            loader: 'babel-loader',
            query: {
                presets: ['es2015']
            }
        }
    ]
  },
  stats: {
      colors: true
  },
  devtool: 'source-map'
}

// Compile Ws client for game
wsClientConfig = extend(commonConfig, {
  entry: './general_js/ws/src/app.js',
  output: {
    path: './general_js/ws/build',
    filename: 'ws.bundle.js'
  }
})

// Compile Ws client for game
gameModeConfig = extend(commonConfig, {
  entry: './game/mode/js/mode.js',
  output: {
    path: './game/mode9/js_libs',
    filename: 'mode.js'
  }
})

module.exports = [wsClientConfig, gameModeConfig]