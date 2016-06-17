<partial-object>
    <div class="column" if={object}>
        <h1 class="ui header">
            {object.name}
            <div class="sub header">{object.title}</div>
        </h1>

        <table class="ui table definition large striped">
            <tbody>
            <tr each={name, desc in object.field.desc}>
                <td>{name}</td>
                <td>{desc}</td>
                <td>{parent.object.field.type[name]}</td>
                <td>
                    <a if={parent.object.field.ref[name]} href="{parent.object.field.ref[name]}">参考</a>
                </td>
            </tr>
            </tbody>
        </table>

        <div name="desc" class="markdown-body ui segment"></div>
    </div>


    <script>
        var tag = this;
        var marked = require('marked');
        var hljs = require('highlight.js');

        tag.on('update', function () {
            var object = tag.object = tag.opts.object;

            if (object) {
                tag.desc.innerHTML = marked(object.desc);
                $('pre code', tag.desc).each(function (i, block) {
                    hljs.highlightBlock(block);
                });

                tag.update();
            }
        });


    </script>
</partial-object>