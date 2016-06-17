<page-object>


    <div class="ui grid page" if={object} riot-tag="partial-object" object={object}></div>


    <script>
        var $ = require('jquery');
        var gw = require('gateway');

        var tag = this;
        var name = tag.opts.params[0];

        gw('dev.api_object').then(function (objects) {
            var found = objects.some(function (object) {
                if (object.name === name) {
                    tag.object = object;
                    tag.update();

                    return true;
                }
            });

            if (!found) {
                riot.route('404');
            }
        }, function (err) {
            console.error(err);
        });
    </script>
</page-object>
