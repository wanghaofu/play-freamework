<page-resource>
    <div class="ui page grid">
        <div class="column">
            <div class="ui blue segment">
                <h1 class="ui header">
                    <div class="content">
                        {api.title || api.name}
                        <span if={api.needLogin} class="ui mini label blue">
                            <i class="user icon"></i>
                            need login
                        </span>
                        <div class="sub header">
                            {api.name}
                        </div>
                    </div>
                </h1>
                <div name="desc" class="markdown-body"></div>
            </div>

            <div class="ui green segment">
                <div name="editor"></div>

                <div class="ui divider"></div>

                <div class="ui input action fluid">
                    <button onclick={submit} disabled={disableSubmit} class="ui button primary">
                        GET
                    </button>
                    <input type="text" name="sid" placeholder="sid"/>
                </div>

            </div>

            <div name="result" class="ui yellow segment">
                <a href="{request}" target="_blank">{request}</a>
                <div class="ui segment">
                    <iframe src="about:blank" frameborder="0" name="iframe"></iframe>
                </div>
            </div>
        </div>
    </div>

    <script>
        var marked = require('marked');
        var $ = require('jquery');
        var md5 = require('md5-jkmyers');
        var JSONEditor = require('jsoneditor-sui');

        var tag = this;
        var gw = require('gateway');

        var name = tag.opts.params[0];
        var editor;
        var $result = $(tag.result);
        var $sid = $(tag.sid);
        var $iframe = $(tag.iframe);

        tag.responseSuccess = true;

        $sid.val(gw.getSid())
            .on('change input blur', function () {
                gw.setSid($sid.val());
            });


        gw('dev.r_api_index').then(function (apis) {
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
                        tag.request = wrapRequest(tag.api.path, editor.getValue());

                        if (editor.validate().length > 0) {
                            tag.disableSubmit = true;
                        } else {
                            tag.disableSubmit = null;
                        }
                        tag.update();
                    });
                }
            }
        });

        tag.submit = function () {
            tag.request = wrapRequest(tag.api.path, editor.getValue());
            tag.update();

            $iframe.attr('src', tag.request);
        }

        function wrapRequest(path, params) {
            var sid = gw.getSid();
            var t = parseInt(Date.now() / 1000);
            var sign = md5(['king-ifa', '', sid, t].join('@'));
            var q = [];
            params = params || {};

            params.kgw_t = t;
            params.kgw_sign = sign;
            params.kgw_sid = sid;

            Object.keys(params).forEach(function (k) {
                q.push(encodeURIComponent(k) + '=' + encodeURIComponent(params[k]));
            });

            return location.origin + path + '?' + q.join('&');
        }


    </script>
</page-resource>