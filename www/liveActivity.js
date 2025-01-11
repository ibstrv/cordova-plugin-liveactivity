LiveActivity = function() {};
    
LiveActivity.prototype.start = function(message, successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, 'LiveActivity', 'start', [message]);
};

LiveActivity.prototype.getStartToken = function(message, successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, 'LiveActivity', 'start', [message]);
};
    
module.exports = new LiveActivity();
