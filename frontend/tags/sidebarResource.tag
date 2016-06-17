<sidebarResource>
    <div class="item">
        <div class="ui input fluid">
            <input oninput={update} type="text" placeholder="Search..." name="term" >
        </div>
    </div>
    <a class="item" href="#resource/{name}" title={title || name} each={apis.filter(filter)}>
        <i class="newspaper icon"></i>
        {name}
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

        gw('dev.r_api_index').then(function (apis) {
            tag.apis = Object.keys(apis).map(function (k) {
                return apis[k];
            });

            tag.update();
        }, function (err) {
            console.error(err);
        });
    </script>
</sidebarResource>
