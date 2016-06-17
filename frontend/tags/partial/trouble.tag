<partial-trouble>
    <div class="column" if={troubles}>
        <h1>错误码</h1>

        <table class="ui table">
            <thead>
            <tr>
                <th>代码</th>
                <th>名称</th>
                <th>说明</th>
            </tr>
            </thead>
            <tbody if={currentTrouble}>
            <tr class="positive">
                <td>
                    <span class="ui label big">{currentTrouble.code}</span>
                </td>
                <td>{currentTrouble.name}</td>
                <td>{currentTrouble.comment}</td>
            </tr>
            </tbody>

            <tbody if={!currentTrouble}>
            <tr each={troubles}>
                <td>
                    <span class="ui label big">{code}</span>
                </td>
                <td>{name}</td>
                <td>{comment}</td>
            </tr>
            </tbody>
        </table>

    </div>

    <script>
        var tag = this;
        var $ = require('jquery');
        var gw = require('gateway');

        tag.name = tag.opts['trouble-name'];

        gw('dev.trouble_code').then(function (troubles) {
            tag.troubles = troubles;
            tag.currentTrouble = troubles.filter(function (trouble) {
                return trouble.name === tag.name;
            }).pop();

            tag.update();
        }, function (e) {
            console.error(e);
        });

    </script>
</partial-trouble>