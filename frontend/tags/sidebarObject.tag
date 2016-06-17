<sidebarObject>
    <div class="item">
        <div class="ui input fluid">
            <input oninput={update} type="text" placeholder="Search..." name="term" >
        </div>
    </div>
    <a class="item" href="#object/{name}" each={objects.filter(filter)}>
        <i class="file icon"></i>
        {name}
    </a>

    <script>
        var gw = require('gateway');
        var tag = this;

        tag.filter = function (object) {
            return 'name title'
                    .split(/ /g)
                    .some(function (k) {
                        return object[k] && -1 !== object[k].indexOf(tag.term.value);
                    });
        };

        gw('dev.api_object').then(function (objects) {
            tag.objects = objects;
            tag.update();
        }, function (err) {
            console.error(err);
        });
    </script>
</sidebarObject>
