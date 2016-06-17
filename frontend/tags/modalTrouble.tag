<modalTrouble>

    <i onclick={close} class="close icon"></i>

    <div class="header">
        错误码
    </div>

    <div class="content">
        <partial-trouble trouble-name={opts.troubleName} />
    </div>

    <script>
        var $ = require('jquery');
        var tag = this;

        tag.close = function () {
            $(tag.root).modal('hide');
        };
    </script>
</modalTrouble>