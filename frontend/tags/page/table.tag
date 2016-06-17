<page-table>
    <div class="ui grid page" if={table} riot-tag="partial-table" table={table}></div>

    <script>
        var $ = require('jquery');
        var gw = require('gateway');

        var tag = this;
        var name = tag.opts.params[0];


        gw('dev.table_schema').then(function (tables) {
            var found = tables.some(function (table) {
                if (table.name === name) {
                    tag.table = table;
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
</page-table>
