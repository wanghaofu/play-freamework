var $ = require('jquery');
var md5 = require('md5-jkmyers');
var inVigilante = location.host.indexOf('vig') !== -1;
var URL =
    localStorage.env ||
    (location.host.indexOf('ifaclub.com') !== -1 ? '//api.ifaclub.com' : '/');
var DEVURL =
    localStorage.devEnv || '/';
var cache = {};
var sid = localStorage.sid || '_';

var Gateway = module.exports = (method, params = {})=> {
    var key = JSON.stringify([method, params]);
    if (cache[key]) {
        return cache[key];
    }

    return cache[key] = request(method, params)
        .then(null, (result) => {
            delete cache[key];
            return result;
        })
};

Gateway.request = request;
Gateway.requestRaw = requestRaw;
Gateway.parseResponse = parseResponse;
Gateway.setSid = (_sid) => {
    if(!_sid) return;
    localStorage.sid = sid = _sid;
};
Gateway.getSid = () => {
    return sid;
};


function request(method, params = {}, uid = null) {
    return requestRaw(method, params, uid).then(parseResponse);
}

function requestRaw(method, params = {}, uid = null, ua = null, agent = null) {
    var id = Math.random().toString(36);
    var t = parseInt(Date.now() / 1000);
    var request = JSON.stringify([
        {
            jsonrpc: '2.0',
            id: 'sid',
            method: 'etc.get_session',
            params: {}
        },
        {
            jsonrpc: '2.0',
            id,
            method,
            params
        }
    ]);

    var sign = md5(['king-ifa', unescape(encodeURI(request)), sid, t].join('@'));
    ua = ua || navigator.userAgent;
    return $.ajax({
        url: method.match(/^dev\./) ? DEVURL : URL,
        headers: {
            "X-KGW-USER-AGENT": ua,
            "X-KGW-SID": sid,
            "X-KGW-T": t,
            "X-KGW-AGENT": agent || '',
            "X-KGW-UID": uid,
            "X-KGW-SIGN": sign
        },
        type: 'POST',
        contentType: 'application/json',
        xhrFields: {
            withCredentials: true
        },
        data: request
    })
        .then((res) => {
            Gateway.setSid(res[0].result)
            return [id, res[1]];
        }, (err) => {
            return {
                code: -1,
                message: '网络请求失败',
                data: err
            };
        });
}

function parseResponse(res) {
    var id = res[0];
    res = res[1];

    switch (true) {
        case res.jsonrpc !== '2.0':
        case res.id !== id:
            return reject({
                code: -1,
                message: '响应异常',
                data: res
            });
        case !!res.error:
            return reject(res.error);
        default:
            return res.result;
    }
}

function reject(reason) {
    var dfr = $.Deferred();
    dfr.reject(reason);

    return dfr.promise();
}
function resolve(reason) {
    var dfr = $.Deferred();
    dfr.resolve(reason);

    return dfr.promise();
}