var JSBridge = {
	callAPI: function(funcName, params, callBack) {
		var message;
		var plugin = 'ZLJSCoreBridge';
		var CallBackID = plugin + '_' + funcName + '_' + 'CallBack';
		if (callBack) {
			if (!JSBridgeEvent._listeners[CallBackID]) {
				JSBridgeEvent.addEvent(CallBackID, function(data) {
					callBack(data);
				});
			}
		}
		if (callBack) 
		{
			message = 
			{
				'plugin': plugin,
				'func': funcName,
				'params': params,
				'callBackID': CallBackID,
			};
		} 
		else 
		{
			message = 
			{
				'plugin': plugin,
				'func': funcName,
				'params': params
			};
		}
		window.webkit.messageHandlers.JSBridge.postMessage(message);
	},

	callBack: function(callBackID, data) {
		JSBridgeEvent.fireEvent(callBackID, data);
	},

	removeAllCallBacks: function(data) {
		JSBridgeEvent._listeners = {};
	}

};



var JSBridgeEvent = {

	_listeners: {},


	addEvent: function(type, fn) {
		if (typeof this._listeners[type] === "undefined") {
			this._listeners[type] = [];
		}
		if (typeof fn === "function") {
			this._listeners[type].push(fn);
		}

		return this;
	},


	fireEvent: function(type, param) {
		var arrayEvent = this._listeners[type];
		if (arrayEvent instanceof Array) {
			for (var i = 0, length = arrayEvent.length; i < length; i += 1) {
				if (typeof arrayEvent[i] === "function") {
					arrayEvent[i](param);
				}
			}
		}

		return this;
	},

	removeEvent: function(type, fn) {
		var arrayEvent = this._listeners[type];
		if (typeof type === "string" && arrayEvent instanceof Array) {
			if (typeof fn === "function") {
				for (var i = 0, length = arrayEvent.length; i < length; i += 1) {
					if (arrayEvent[i] === fn) {
						this._listeners[type].splice(i, 1);
						break;
					}
				}
			} else {
				delete this._listeners[type];
			}
		}

		return this;
	}
};
