<page-crontab>

    <div class="ui grid page">
        <div class="column">

            <h1>Crontab</h1>

            <table class="ui table">
                <thead>
                <tr>
                    <th>名称</th>
                    <th>维护者</th>
                    <th>频率</th>
                    <th>说明</th>
                </tr>
                </thead>
                <tbody>
                <tr each="{crontab}">
                    <td>{basename}</td>
                    <td>{info.author}</td>
                    <td>{info.crontab}</td>
                    <td>{info.title}</td>
                </tr>

                </tbody>
            </table>


            <div class="ui segment">
                <p each="{crontab}">
                    # {info.title}<br/>
                    {line}<br/>
                </p>
            </div>
        </div>
    </div>
    <script>
        var tag =this;
        var $ = require('jquery');
        var gw = require('gateway');


        tag.crontab = [];
        gw('dev.crontab_inspect').then(function (o) {
            tag.crontab = o;
            tag.update();
        });
    </script>
</page-crontab>
