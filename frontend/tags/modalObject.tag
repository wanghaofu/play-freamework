<modalObject>

    <i onclick={close} class="close icon"></i>

    <div class="header">
        Api Object
    </div>

    <div class="content">
        <partial-object object={opts.object} />
    </div>

    <script>
        var $ = require('jquery');
        var tag = this;

        tag.close = function () {
            $(tag.root).modal('hide');
        };
    </script>
</modalObject>