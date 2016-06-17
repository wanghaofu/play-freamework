<page-api>
    <div class="ui page grid">
        <div class="column">
            <div class="ui blue segment">
                <h1 class="ui header">
                    <div class="content">
                        {api.title || api.name}
                        <span if={api.needLogin !== '0'} class="ui mini label blue">
                            <i class="user icon"></i>
                            need login
                        </span>
                        <span if={api.needUserLogin !== '0'} class="ui mini label blue">
                            <i class="child icon"></i>
                            User login
                        </span>
                        <span if={api.needFaLogin !== '0'} class="ui mini label blue">
                            <i class="spy icon"></i>
                            FA login
                        </span>
                        <div class="sub header">
                            {api.name}
                        </div>
                    </div>
                </h1>
                <div name="desc" class="markdown-body"></div>

                <div if={api.resultSchema}>
                    <h3>返回结果说明</h3>
                    <div class="ui form">
                        <textarea>{JSON.stringify(api.resultSchema, null, 2)}</textarea>
                    </div>
                </div>
            </div>

            <div class="ui green segment">
                <div name="editor"></div>

                <div class="ui divider"></div>

                <div class="ui input action fluid">
                    <button onclick={submit} disabled={disableSubmit} class="ui button primary">
                        submit
                    </button>
                    <input type="text" name="sid" placeholder="sid"/>
                    <input type="text" name="uid" placeholder="uid"/>
                    <select class="ui dropdown" name="platform">
                        <option value="ios">iOS</option>
                        <option value="android">android</option>
                        <option value="pc">PC</option>
                    </select>
                    <select class="ui dropdown" name="type">
                        <option value="user">用户</option>
                        <option value="fa">理财师</option>
                        <option value="jg">机构</option>
                    </select>
                    <input type="text" name="version" placeholder="build号,默认灰常大"/>
                    <input type="text" name="apiLevel" placeholder="apiLevel"/>
                </div>

            </div>

            <div name="result" class="ui yellow segment">
                <div name="accordion" class="ui styled accordion">
                    <div class="active title">
                        <i class="dropdown icon"></i>
                        Request
                    </div>
                    <div class="active content">
                        <pre>{request}</pre>
                    </div>
                    <div class="title">
                        <i class="dropdown icon"></i>
                        Response
                    </div>
                    <div class="content">
                        <a class={ ui: 1, label: 1, ribbon: 1, red: !responseSuccess, green: responseSuccess
                           }>{labelText}</a>

                        <div class="ui segment">
                            <pre>{response}</pre>
                        </div>
                        <a class="ui label purple ribbon">Raw</a>

                        <div class="ui segment secondary">
                            <pre>{rawResponse}</pre>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var marked = require('marked');
        var $ = require('jquery');
        var JSONEditor = require('jsoneditor-sui');

        var tag = this;
        var gw = require('gateway');
        var hljs = require('highlight.js');

        var name = tag.opts.params[0];
        var editor;
        var $result = $(tag.result);
        var $response = $(tag.response);
        var $accordion = $(tag.accordion);
        var $sid = $(tag.sid);
        var $uid = $(tag.uid);
        var $version = $(tag.version);
        var $apiLevel = $(tag.apiLevel);
        var $type = $(tag.type);
        var $platform = $(tag.platform);

        tag.responseSuccess = true;

        $sid.val(gw.getSid())
            .on('change input blur', function () {
                gw.setSid($sid.val());
            });


        gw('dev.api_index').then(function (apis) {
            $sid.val(gw.getSid());

            if (!apis[name]) {
                riot.route('404');
                return;
            }
            tag.api = apis[name];
            tag.update();
        }, function (err) {
            console.error(err);
        });

        tag.on("update", function () {
            if (tag.api) {
                if (tag.api.desc && !tag.desc.innerHTML) {
                    tag.desc.innerHTML = marked(tag.api.desc);
                    $('pre code', tag.desc).each(function (i, block) {
                        hljs.highlightBlock(block);
                    });
                }

                if (!editor) {
                    editor = new JSONEditor(tag.editor, {
                        show_errors: 'always',
                        schema: tag.api.schema
                    });

                    editor.on('change', function () {
                        tag.request = JSON.stringify(wrapRequest(editor.getValue()), null, 2);
                        if (editor.validate().length > 0) {
                            tag.disableSubmit = true;
                        } else {
                            tag.disableSubmit = null;
                        }
                        tag.update();
                    });

                    $accordion.accordion({
                        exclusive: false
                    });
                }
            }
        });

        tag.submit = function () {
            editor.disable();

            var loading = null;
            var params = editor.getValue();

            loading = setTimeout(function () {
                $result.addClass('loading');
                loading = null;
            }, 100);

            $accordion.accordion('close', 0);
            $accordion.accordion('open', 1);

            tag.rawResponse = '';
            var plat = $platform.val();
            var type = $type.val();
            var ua = null;
            var agent = null;
            var packageName = {
                ios: {
                    user: 'com.ifa.app.std',
                    fa: 'com.ifa.app.pro'
                },
                android: {
                    user: 'com.noah.ifa.app.standard',
                    fa: 'com.noah.ifa.app.pro'
                }
            };

            switch(plat) {
                case 'ios':
                case 'android':
                    agent = plat;
                    ua = packageName[plat][type];
                    break;
                default:
                    ua = null;
            }

            if(ua) {
//                'IFA/1.0(com.noah.ifa.app.pro; 72; android; play-web-ui; 999)'
                ua = ['IFA/1.0(', [
                    ua,
                    $version.val() || 999999999,
                    plat,
                    localStorage.uuid || (localStorage.uuid = Math.random().toString(36).slice(-8)),//device id
                    '999',//os ver
                    'play-webui',//hardware name
                    $apiLevel.val() || null
                ].join('; '), ')'].join('');
            }

            gw.requestRaw(name, params, $uid.val(), ua, agent)
                    .then(function (res) {
                        tag.rawResponse = JSON.stringify(res[1], null, 2);

                        return res;
                    })
                    .then(gw.parseResponse)
                    .then(function (o) {
                        tag.labelText = 'Success';
                        tag.responseSuccess = true;
                        tag.response = JSON.stringify(o, null, 2);
                    }, function (e) {
                        tag.labelText = 'Failed';
                        tag.responseSuccess = false;
                        tag.response = JSON.stringify(e, null, 2);
                    })
                    .always(function () {
                        editor.enable();
                        if(loading) {
                            clearTimeout(loading);
                        } else {
                            $result.removeClass('loading');
                        }
                        $sid.val(gw.getSid());
                        tag.update();
                    })
        }

        function wrapRequest(params) {
            return {
                jsonrpc: '2.0',
                id: "<<RANDOM VALUE>>",
                method: name,
                params: params
            };
        }


    </script>
</page-api>