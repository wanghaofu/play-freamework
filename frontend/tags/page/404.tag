<page-404>
    <div class="ui segment">
        <div class="ui icon message error massive">
            <i class="icon warning sign"></i>

            <div class="content">
                <p>
                    Page Not Found
                </p>
            </div>
        </div>
    </div>
    <script>
        var $ = require('jquery');
        var tag = this;

        tag.on('mount', function () {
            $(tag.opts.body.sidebar).sidebar('show');
        });
    </script>
</page-404>