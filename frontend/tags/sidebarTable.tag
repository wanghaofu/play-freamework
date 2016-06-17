<sidebarTable>
    <div class="item">
        <div class="ui input fluid">
            <input oninput={update} type="text" placeholder="Search..." name="term" >
        </div>
    </div>
    <a class="item" href="#table/{name}" each={tables.filter(filter)}>
        <i class="table icon"></i>
        {name}
    </a>

    <script>
        var gw = require('gateway');
        var tag = this;

        tag.filter = function (table) {
            return 'name'
                    .split(/ /g)
                    .some(function (k) {
                        return table[k] && -1 !== table[k].indexOf(tag.term.value);
                    });
        };

        gw('dev.table_schema').then(function (tables) {
            tag.tables = tables;
            tag.update();
        }, function (err) {
            console.error(err);
        });
    </script>
</sidebarTable>
