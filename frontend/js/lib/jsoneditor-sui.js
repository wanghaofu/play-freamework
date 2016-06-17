var JSONEditor = require('json-editor');
var $ = require('jquery');
var wide = ' one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen'.split(' ');
var marked = require('marked');
JSONEditor.AbstractEditor.prototype.getTitle = function () {
    if(!this.schema.title) {
        return this.key;
    }

    return this.schema.title + ' (' + this.key + ')';
};

JSONEditor.defaults.themes.sui = JSONEditor.AbstractTheme.extend({
    getHeader: function (text) {
        var el = create('h5');
        el.className += 'ui header';
        var content = create('h3');
        content.className += 'content';
        if (typeof text === "string") {
            content.textContent = text;
        } else {
            content.appendChild(text);
        }
        el.appendChild(content);

        return el;
    },

    getSelectInput: function (options) {
        var el = this._super(options);
        el.className += 'ui dropdown';
        //el.style.width = 'auto';
        return el;
    },
    setGridColumnSize: function (el, size) {
        el.className = [wide[size], 'wide', 'column'].join(' ');
    },
    afterInputReady: function (input) {
        if (input.controlgroup) return;
        input.controlgroup = this.closest(input, '.field');
    },
    getTextareaInput: function () {
        var textarea = create('textarea');
        return textarea;
    },
    getRangeInput: function (min, max, step) {
        // TODO: use better slider
        return this._super(min, max, step);
    },
    //getFormInputField: function (type) {
    //    var el = this._super(type);
    //    return el;
    //},
    getFormControl: function (label, input, description) {
        var group = create('div');
        var left = create('div');

        group.className += ' field ui grid'
        left.className += ' ten wide column';

        if (label) {
            group.label = label;
            label.className += ' sixteen wide column';
            label.style.lineHeight = '2em';
            label.style.padding = '0';
            group.appendChild(label);
        }

        left.appendChild(input);
        group.appendChild(left);

        if (description) {
            description.className += ' six wide column';
            group.appendChild(description);
        }

        return group;
    },
    getIndentedPanel: function () {
        var el = create('div');
        el.className = 'ui form';
        return el;
    },
    getFormInputDescription: function (text) {
        var el = create('div');
        el.className = 'ui secondary segment markdown-body';
        el.style.padding = '5px';
        el.innerHTML = marked(text);
        return el;
    },
    getHeaderButtonHolder: function () {
        var el = this.getButtonHolder();
        el.style.marginLeft = '10px';
        return el;
    },
    getButtonHolder: function () {
        var el = create('div');
        el.className = 'ui buttons';
        return el;
    },
    getButton: function (text, icon, title) {
        var el = this._super(text, icon, title);
        el.className += 'ui button';
        return el;
    },
    getTable: function () {
        var el = create('table');
        el.className = 'ui table';
        el.style.width = 'auto';
        el.style.maxWidth = 'none';
        return el;
    },

    addInputError: function (input, text) {
        window.requestAnimationFrame(function () {
            if (!input.controlgroup) {
                console.error('failed to find controlgroup');
                return;
            }
            input.controlgroup.className += ' error';
            if (!input.errmsg) {
                input.errmsg = create('p');
                input.errmsg.className = 'ui label red pointing left';
                if(input.controlgroup.label) {
                    input.controlgroup.label.appendChild(input.errmsg);
                } else {
                    input.controlgroup.appendChild(input.errmsg);
                }
            } else {
                input.errmsg.style.display = '';
            }

            input.errmsg.textContent = text;
        });
    },
    removeInputError: function (input) {
        if (!input.errmsg) return;
        input.errmsg.style.display = 'none';
        input.controlgroup.className = input.controlgroup.className.replace(/\s?error/g, '');
    },
    getTabHolder: function () {
        var el = create('div');
        el.innerHTML = "<div class='tabs list-group col-md-2'></div><div class='col-md-10'></div>";
        el.className = 'rows';
        return el;
    },
    getTab: function (text) {
        var el = create('a');
        el.className = 'list-group-item';
        el.setAttribute('href', '#');
        el.appendChild(text);
        return el;
    },
    markTabActive: function (tab) {
        tab.className += ' active';
    },
    markTabInactive: function (tab) {
        tab.className = tab.className.replace(/\s?active/g, '');
    },
    getProgressBar: function () {
        var min = 0, max = 100, start = 0;

        var container = create('div');
        container.className = 'progress';

        var bar = create('div');
        bar.className = 'progress-bar';
        bar.setAttribute('role', 'progressbar');
        bar.setAttribute('aria-valuenow', start);
        bar.setAttribute('aria-valuemin', min);
        bar.setAttribute('aria-valuenax', max);
        bar.innerHTML = start + "%";
        container.appendChild(bar);

        return container;
    },
    updateProgressBar: function (progressBar, progress) {
        if (!progressBar) return;

        var bar = progressBar.firstChild;
        var percentage = progress + "%";
        bar.setAttribute('aria-valuenow', progress);
        bar.style.width = percentage;
        bar.innerHTML = percentage;
    },
    updateProgressBarUnknown: function (progressBar) {
        if (!progressBar) return;

        var bar = progressBar.firstChild;
        progressBar.className = 'progress progress-striped active';
        bar.removeAttribute('aria-valuenow');
        bar.style.width = '100%';
        bar.innerHTML = '';
    }
});

JSONEditor.defaults.theme = 'sui';

module.exports = JSONEditor;


function create(tagName) {
    return document.createElement(tagName);
}
