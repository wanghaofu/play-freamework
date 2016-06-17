<modalTable>

    <i onclick={close} class="close icon"></i>

    <div class="header">
        DB Table
    </div>

    <div class="content">
        <partial-table table={opts.table} />
    </div>

    <script>
        var $ = require('jquery');
        var tag = this;

        tag.close = function () {
            $(tag.root).modal('hide');
        };
    </script>
</modalTable>