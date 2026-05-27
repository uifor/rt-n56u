function merlin_itoggle_sync($wrap, state)
{
    var $checkbox = $wrap.children('input:first');
    var $label = $wrap.children('label.itoggle:first');
    var $radios = $wrap.parents('.main_itoggle').next().children('input[type="radio"]');
    var enabled = state > 0;

    $checkbox.attr('value', enabled ? 1 : 0);
    $checkbox.prop('checked', enabled);
    if (enabled)
        $checkbox.attr('checked', 'checked');
    else
        $checkbox.removeAttr('checked');
    $label.toggleClass('iTon', enabled).toggleClass('iToff', !enabled);
    $label.attr('aria-checked', enabled ? 'true' : 'false');

    if ($radios.length >= 2) {
        $radios.eq(0).prop('checked', enabled);
        $radios.eq(1).prop('checked', !enabled);
        if (enabled) {
            $radios.eq(0).attr('checked', 'checked');
            $radios.eq(1).removeAttr('checked');
        }
        else {
            $radios.eq(0).removeAttr('checked');
            $radios.eq(1).attr('checked', 'checked');
        }
    }
}

function merlin_itoggle_disabled($wrap, disabled)
{
    $wrap.children('input:first').prop('disabled', disabled);
    $wrap.children('label.itoggle:first').toggleClass('disabled', disabled).attr('aria-disabled', disabled ? 'true' : 'false');
}

function merlin_itoggle_inject_style()
{
    if (document.getElementById('merlin_itoggle_style'))
        return;

    var css = [
        'div.main_itoggle label{margin-bottom:0;}',
        'div.main_itoggle input.iT_checkbox{position:absolute;left:-9999px;top:-9999px;}',
        'div.main_itoggle label.itoggle{position:relative;display:inline-block;width:62px;height:30px;box-sizing:border-box;margin:0;cursor:pointer;text-indent:-9999px;overflow:hidden;vertical-align:middle;border:1px solid #6b8fa3;border-radius:999px;background:#25363b;box-shadow:inset 0 1px 2px rgba(0,0,0,.45),0 1px 0 rgba(255,255,255,.08);transition:background-color .18s ease,border-color .18s ease,box-shadow .18s ease;}',
        'div.main_itoggle label.itoggle span{position:absolute;left:3px;top:3px;display:block;width:22px;height:22px;margin:0;border-radius:50%;background:#d5e2e6;box-shadow:0 1px 3px rgba(0,0,0,.55),inset 0 1px 0 rgba(255,255,255,.55);transition:transform .18s ease,background-color .18s ease;}',
        'div.main_itoggle label.itoggle.iTon{border-color:#7fb5ce;background:#1d6f92;box-shadow:inset 0 1px 2px rgba(0,0,0,.35),0 0 0 1px rgba(120,190,220,.12);}',
        'div.main_itoggle label.itoggle.iTon span{transform:translateX(32px);background:#f1f8fa;}',
        'div.main_itoggle label.itoggle:hover{border-color:#92c3d8;}',
        'div.main_itoggle label.itoggle:focus{outline:none;}',
        'div.main_itoggle label.itoggle:focus-visible{box-shadow:0 0 0 2px rgba(127,181,206,.35),inset 0 1px 2px rgba(0,0,0,.35);}',
        'div.main_itoggle label.itoggle.disabled{cursor:not-allowed;opacity:.48;filter:saturate(.7);}',
        'div.main_itoggle label.itoggle.disabled span{background:#aebbc0;}'
    ].join('\n');
    var style = document.createElement('style');
    style.id = 'merlin_itoggle_style';
    style.type = 'text/css';
    if (style.styleSheet)
        style.styleSheet.cssText = css;
    else
        style.appendChild(document.createTextNode(css));
    document.getElementsByTagName('head')[0].appendChild(style);
}

function init_itoggle(id, func)
{
    merlin_itoggle_inject_style();

    var $wrap = $j('#' + id + '_on_of');
    var $checkbox = $j('#' + id + '_fake');

    if (!$wrap.length || !$checkbox.length)
        return;

    if (!$checkbox.hasClass('iT_checkbox'))
        $checkbox.addClass('iT_checkbox');

    if (!$wrap.children('label.itoggle').length)
        $checkbox.before('<label class="itoggle" for="' + id + '_fake" role="switch" tabindex="0"><span></span></label>');

    merlin_itoggle_sync($wrap, $checkbox.is(':checked') ? 1 : 0);
    merlin_itoggle_disabled($wrap, $checkbox.is(':disabled'));

    $wrap.off('click.merlin_itoggle keydown.merlin_itoggle', 'label.itoggle');
    $wrap.on('click.merlin_itoggle', 'label.itoggle', function(e) {
        e.preventDefault();
        if ($checkbox.is(':disabled'))
            return false;
        merlin_itoggle_sync($wrap, $checkbox.is(':checked') ? 0 : 1);
        if (typeof(func) === 'function')
            func();
        return false;
    });
    $wrap.on('keydown.merlin_itoggle', 'label.itoggle', function(e) {
        if (e.which == 13 || e.which == 32)
            $j(this).trigger('click');
    });
}

(function($j){
    $j.fn.iClickable = function(flag) {
        this.each(function(){
            merlin_itoggle_disabled($j(this), !(flag === true || flag === 1));
        });
        return this;
    };
})(jQuery);

(function($j){
    $j.fn.iState = function(new_state) {
        this.each(function(){
            merlin_itoggle_sync($j(this), new_state);
        });
        return this;
    };
})(jQuery);
