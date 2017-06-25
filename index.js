'use strict';

exports.helloWorld = (event, context, callback) => {
    callback(null, 'Hi everybody!');
};

exports.goodbye = (event, context, callback) => {
    callback(null, 'Goodbye!');
};