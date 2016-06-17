<partial-table>
    <div class="column" if={table}>
        <h1>{table.name}</h1>

        <div name="desc" class="markdown-body ui segment"></div>

        <!--<div class="ui label ribbon orange">主键</div>-->

        <div class="ui label orange large tag">枚举</div>

        <div class="ui raised segment" each={name, values in table.sourceReport.enumDesc}>
            <a class="ui label top attached large">
                <i class="icon code"></i>
                <span>{name}</span>
            </a>
            <div class="ui list relaxed">
                <div each={values} class="item">
                    <div class="content">
                        <span class="header">
                            {value} = {name}
                        </span>
                        <div class="description" if={doc}>
                            <pre>{doc}</pre>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="ui label green large tag">字段</div>
        <table class="ui table definition">
            <thead>
            <tr>
                <th></th>
                <th>类型</th>
                <th>类型补充</th>
                <th>说明</th>
            </tr>
            </thead>
            <tbody>
            <tr each={tableColumns} class={positive: parent.table.pk&& -1!== parent.table.pk.indexOf(name)}>
                <td>
                    <span class="ui label big">{name}</span>
                </td>
                <td>{type}</td>
                <td>
                    <pre style="margin: 0">{meta}</pre>
                </td>
                <td>{comment}</td>
            </tr>
            </tbody>
        </table>

        <div class="ui label blue large tag">索引</div>

        <table class="ui table">
            <tbody>
            <tr if={table.pk} class="positive">
                <td>
                    <strong>主键</strong>
                </td>
                <td>
                    <span class="ui label big" each={col in table.pk}>{col}</span>
                </td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr each={table.indexes}>
                <td if={name}>{name}</td>
                <td if={!name} class="disabled">未命名</td>
                <td>
                    <span class="ui label big" each={col in columns}>{col}</span>
                </td>
                <td>
                    <pre>{humanize(flags)}</pre>
                </td>
                <td>
                    <pre>{humanize(option)}</pre>
                </td>
                <td>{comment}</td>
            </tr>
            </tbody>
        </table>
    </div>

    <script>
        var tag = this;
        var marked = require('marked');
        var hljs = require('highlight.js');

        tag.humanize = function (obj) {
            return JSON.stringify(obj, null, 2).replace(/^{ *\n?|\s*}$/g, '');
        };

        tag.on('update', function () {
            var table = tag.table = tag.opts.table;

            if (table) {
                tag.tableColumns = table.columns.map(function (col) {
                    var option = $.extend({}, col.option);//clone
                    delete option.comment;

                    return $.extend({}, col, {
                        meta: tag.humanize(option)
                    });
                });
                tag.desc.innerHTML = marked(table.comment);
                $('pre code', tag.desc).each(function (i, block) {
                    hljs.highlightBlock(block);
                });

                tag.update();
            }
        });
    </script>
</partial-table>