<body>
<style scoped>
    :scope > .pusher {
        padding-top: 42px;
    }
</style>
<div class="ui sidebar menu left vertical very wide" name="sidebar" riot-tag="sidebar"></div>
<div class="ui sidebar menu left vertical wide" name="sidebarTable" riot-tag="sidebarTable"></div>
<div class="ui sidebar menu left vertical wide" name="sidebarObject" riot-tag="sidebarObject"></div>
<div class="ui sidebar menu left vertical wide" name="sidebarResource" riot-tag="sidebarResource"></div>

<div class="dimmed pusher">
    <div class="ui main menu fixed inverted">
        <a onclick={toggle} data-sidebar="sidebar" class="item">
            <i class="icon chevron circle right"></i>
            API列表
        </a>

        <div class="ui dropdown item simple">
            <i class="icon sidebar"></i>
            更多
            <i class="dropdown icon"></i>

            <div class="menu">
                <a onclick={toggle} data-sidebar="sidebarResource" class="item">
                    <i class="icon chevron circle right"></i>
                    资源API
                </a>
                <a onclick={toggle} data-sidebar="sidebarObject" class="item">
                    <i class="icon chevron circle right"></i>
                    结构体
                </a>
                <a onclick={toggle} data-sidebar="sidebarTable" class="item">
                    <i class="icon chevron circle right"></i>
                    数据表
                </a>
            </div>
        </div>
        <a href="#trouble" class="item">
            <i class="icon cube"></i>
            错误码
        </a>
        <a href="http://git.ephah.cf/php/king-gw#README" target="_blank" class="item">
            <i class="file pdf outline icon"></i>
            接口说明
        </a>
        <a href="#crontab" class="item">
            <i class="icon dashboard"></i>
            crontab
        </a>

        <div class="right menu">
            <a href="#option" class="item">
                <i class="icon university circle right"></i>
                配置
            </a>
            <a onclick={changeEnv} class="item">
                <i class="icon university circle right"></i>
                切换环境
            </a>
        </div>
    </div>

    <div id="main"></div>
</div>

<div name="modal" class="ui modal"></div>

<script>
    var tag = this;
    var toggled = false;
    var $ = require('jquery');
    var gw = require('gateway');

    tag.toggle = function (event) {
        $(tag[$(event.target).data('sidebar')]).sidebar('toggle');
        toggled = true;
    };

    tag.changeEnv = function (event) {
        localStorage.env = prompt('请输入') || '';
    }

    riot.route(function (method, ...params) {
        try {
            load(method);
        } catch (e) {
            method = '404';
            load(method);
        }


        console.info('route', method, params);

        if (toggled) {
            $(tag.sidebar).sidebar('hide');
            $(tag.sidebarTable).sidebar('hide');
            $(tag.sidebarObject).sidebar('hide');
        }
        $(tag.modal).modal('hide');

        var child = riot.mount(tag.main, 'page-' + method, {
            params: params,
            body: tag
        });

//        child[0].one('update', function () {
//            console.log($('[href^="#object/"]', child[0].root));
//        });
    });

    tag.on('mount', function () {
        riot.route((location.hash || '#index').substr(1));
    });

//    $(tag.modal).modal({
//        onHide: function () {
//            debugger;
//        }
//    });

    gw('dev.api_object')
        .then(function (objects) {
            $([tag.main, tag.modal]).on('click', '[href^="#object/"]', function (e) {
                var objName = $(this).attr('href').match(/#object\/(\w+)/)[1];

                var found = objects.some(function (obj) {
                    if(obj.name === objName) {
                        showModal('modalObject', {
                            object: obj
                        });
                        e.preventDefault();
                        return true;
                    }
                });

                if(!found) {
                    console.error(objName,  'object not found');
                }
            });
        });

    gw('dev.table_schema')
        .then(function (tables) {
            $([tag.main, tag.modal]).on('click', '[href^="#table/"]', function (e) {
                var tableName = $(this).attr('href').match(/#table\/(\w+)/)[1];

                var found = tables.some(function (table) {
                    if(table.name === tableName) {
                        showModal('modalTable', {
                            table: table
                        });

                        e.preventDefault();
                        return true;
                    }
                });

                if(!found) {
                    console.error(tableName,  'table not found');
                }
            });
        });

    $([tag.main, tag.modal]).on('click', '[href^="#trouble/"]', function (e) {
        var trouble = $(this).attr('href').match(/#trouble\/(\w+)/)[1];
        showModal('modalTrouble', {
            troubleName: trouble
        });

        e.preventDefault();
    });



    function showModal(name, opts) {
        //wait 1 frame or SUI will kill you
        requestAnimationFrame(function () {
            var child = riot.mount(tag.modal, name, opts).pop();

            $(tag.modal).modal('show');
        });
    }
    function load(name) {
        return require('page/' + name + '.tag');
    }
</script>
</body>
