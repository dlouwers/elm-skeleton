const path = require('path');

var elmSource = __dirname + '/src';

module.exports = {
    module: {
        rules: [{
            test: /\.html$/,
            exclude: /node_modules/,
            loader: 'file-loader',
            options: {
                name: '[name].[ext]'
            }
        },
        {
            test: /\.elm$/,
            exclude: [/elm-stuff/, /node_modules/],
            loader: 'elm-webpack-loader'
        }]
    },
    devServer: {
        contentBase: './dist',
    }
};