var webpack = require('webpack');
var CommonsChunkPlugin = require('webpack/lib/optimize/CommonsChunkPlugin');
var glob = require('glob');
var fixedDirectoryDescriptionFilePlugin = require('webpack-bower-resolver');


function getEntry() {
    var entry = {};
    glob.sync(__dirname + '/frontend/js/**/*.main.js').forEach(function (name) {
        var n = name.slice(__dirname.length).match(/^\/frontend\/js\/(.+?)\.main\.js/)[1];

        entry[n] = './frontend/js/' + n + '.main.js';
    });

    return entry;
}
module.exports = {
    refreshEntry: function () {
        this.entry = getEntry();
    },
    entry: getEntry(),
    resolve: {
        modulesDirectories: [
            'bower_components',
            'node_modules',
            __dirname + '/semantic/dist',
            'frontend/tags',
            'frontend/js/lib'
        ]
    },
    plugins: [
//        new CommonsChunkPlugin('common.min.js', 5),
        new webpack.optimize.UglifyJsPlugin(),
        new webpack.ProvidePlugin({
        //new webpack.ProvidePlugin({
            $: "jquery",
            jQuery: "jquery",
            riot: 'riot'
        }),
        new webpack.ResolverPlugin(
            //new fixedDirectoryDescriptionFilePlugin('bower.json', ['main'])
            new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin("bower.json", ["main"])
        )
    ],
    module: {
        preLoaders: [
            {test: /\.tag$/, exclude: /node_modules/, loader: 'riotjs-loader', query: {type: 'none'}}
        ],
        loaders: [
            {test: /\.js|\.tag$/, exclude: /node_modules|bower_components|semantic/, loader: 'babel-loader'},
            {test: /json-editor/, loader: 'exports?JSONEditor'}
        ]
    },
    //devtool: 'source-map',
    output: {
        path: __dirname + '/public/js',
        filename: '[name].min.js',
        sourceMapFilename: '[file].map'
    }
};
