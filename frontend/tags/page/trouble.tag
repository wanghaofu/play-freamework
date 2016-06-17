<page-trouble>
    <div class="ui grid page" riot-tag="partial-trouble" trouble-name={name}></div>

    <script>
        var tag =this;
        tag.name = tag.opts.params[0];
    </script>
</page-trouble>
