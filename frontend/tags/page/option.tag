<page-option>
    <div class="ui segment">
        <div class="ui icon message error massive">
            <i class="icon warning sign"></i>

            <div class="content">
                <p>
                    Option需求还没做
                </p>
            </div>
        </div>
    </div>
    <script>
        var $ = require('jquery');
        var tag = this;

        tag.options = [{
            name: "目标环境",
            key: "env",
            type: "text",
            suggest: ["/", "http://gw-master.ephah.cf/"]
        }, {

        }];
    </script>
</page-option>