'use strict';

exports.helloWorld = (event, context, callback) => {
    callback(null, 'Hello World');
};

exports.goodbye = (event, context, callback) => {
    callback(null, 'Goodbye!');
};