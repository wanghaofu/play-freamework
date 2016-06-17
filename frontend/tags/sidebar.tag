<sidebar>
    <div class="item">
        <div class="ui input fluid">
            <input oninput={update} type="text" placeholder="Search..." name="term" >
        </div>
    </div>
    <a class="item" href="#api/{name}" title={title || name} each={apis.filter(filter)}>
        {name}
        <span style="float: right; opacity: 0.8;">{title||name}</span>
    </a>

    <script>
        var gw = require('gateway');
        var tag = this;

        tag.filter = function (api) {
            return 'name desc title'
                    .split(/ /g)
                    .some(function (k) {
                        return api[k] && -1 !== api[k].indexOf(tag.term.value);
                    });
        };

        gw('dev.api_index').then(function (apis) {
            tag.apis = Object.keys(apis).map(function (k) {
                return apis[k];
            });

            tag.update();
        }, function (err) {
            console.error(err);
        });
    </script>
</sidebar>
