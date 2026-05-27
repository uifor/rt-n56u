<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/index_style.css">
<link rel="stylesheet" type="text/css" href="/form_style.css">
<link rel="stylesheet" type="text/css" href="/other.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/highcharts.js"></script>
<script type="text/javascript" src="/bootstrap/js/highcharts_theme.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/merlin_adapter.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script>
var $j = jQuery.noConflict();

var arrCharts = [ null, null ];
var arrHashes = ["cpu", "mem"];

var cpu_chart = {
    chart: {
        renderTo: 'cpu_chart',
        zoomType: 'x',
        spacingRight: 15
    },
    title : {
        text : '<#menu5_8_1#> (%)',
        align: 'left'
    },
    xAxis: {
        type: 'datetime',
        minRange: 10*1000,
        title: {
            text: null
        },
        labels: {
            format: '{value:%H:%M:%S}'
        }
    },
    yAxis: {
        title: {
            text: 'CPU %'
        },
        min: 0,
        max: 100,
        minRange: 1,
        opposite: false,
        startOnTick: false,
        showFirstLabel: false
    },
    plotOptions: {
        series: {
            animation: false
        },
        areaspline: {
            lineWidth: 1
        },
        spline: {
            lineWidth: 1
        },
        area: {
            lineWidth: 1
        },
        line: {
            lineWidth: 1
        }
    },
    legend: {
        enabled: true,
        verticalAlign: 'top',
        floating: true,
        align: 'right'
    },
    rangeSelector: {
        buttons: [{
            count: 1,
            type: 'minute',
            text: '1M'
        },{
            count: 5,
            type: 'minute',
            text: '5M'
        },{
            count: 15,
            type: 'minute',
            text: '15M'
        },{
            type: 'all',
            text: 'All'
        }],
        inputEnabled: false,
        selected: 1
    },
    tooltip:{
        xDateFormat: '%H:%M:%S',
        valueSuffix: '%'
    },
    series: [{
        type: 'areaspline',
        name: 'Busy',
        gapSize: 5,
        threshold: null,
        fillColor: {
            linearGradient: {
                x1: 0,
                y1: 0,
                x2: 0,
                y2: 1
            },
            stops: [[0, Highcharts.getOptions().colors[0]], [1, 'rgba(0,0,0,0)']]
        },
        data: (prepare_array_chart)()
    },{
        type: 'spline',
        name: 'User',
        gapSize: 5,
        threshold: null,
        data: (prepare_array_chart)()
    },{
        type: 'spline',
        name: 'System',
        gapSize: 5,
        threshold: null,
        data: (prepare_array_chart)()
    },{
        type: 'spline',
        name: 'Sirq',
        gapSize: 5,
        threshold: null,
        data: (prepare_array_chart)()
    }]
};

var mem_chart = {
    chart: {
        renderTo: 'mem_chart',
        zoomType: 'x',
        spacingRight: 15
    },
    title : {
        text : '<#menu5_8_2#> (MB)',
        align: 'left'
    },
    xAxis: {
        type: 'datetime',
        minRange: 10*1000,
        title: {
            text: null
        },
        labels: {
            format: '{value:%H:%M:%S}'
        }
    },
    yAxis: {
        title: {
            text: '<#HSTOCK_RAM#>'
        },
        min: 0,
        minRange: 16,
        opposite: false,
        startOnTick: false,
        showFirstLabel: false
    },
    plotOptions: {
        series: {
            animation: false
        }
    },
    legend: {
        enabled: true,
        verticalAlign: 'top',
        floating: true,
        align: 'right'
    },
    rangeSelector: {
        buttons: [{
            count: 1,
            type: 'minute',
            text: '1M'
        },{
            count: 5,
            type: 'minute',
            text: '5M'
        },{
            count: 15,
            type: 'minute',
            text: '15M'
        },{
            type: 'all',
            text: 'All'
        }],
        inputEnabled: false,
        selected: 1
    },
    tooltip:{
        xDateFormat: '%H:%M:%S',
        valueSuffix: ' MB',
        valueDecimals: 2
    },
    series: [{
        type: 'spline',
        name: 'Used',
        gapSize: 5,
        data: (prepare_array_chart)()
    },{
        type: 'spline',
        name: 'Buffers',
        gapSize: 5,
        data: (prepare_array_chart)()
    },{
        type: 'spline',
        name: 'Cached',
        gapSize: 5,
        data: (prepare_array_chart)()
    }]
};

Highcharts.setOptions({
    global : {
        useUTC : false
    },
    lang: {
        months: ['<#MF_Jan#>', '<#MF_Feb#>', '<#MF_Mar#>', '<#MF_Apr#>', '<#MF_May#>', '<#MF_Jun#>', '<#MF_Jul#>', '<#MF_Aug#>', '<#MF_Sep#>', '<#MF_Oct#>', '<#MF_Nov#>', '<#MF_Dec#>'],
        shortMonths: ['<#MS_Jan#>', '<#MS_Feb#>', '<#MS_Mar#>', '<#MS_Apr#>', '<#MS_May#>', '<#MS_Jun#>', '<#MS_Jul#>', '<#MS_Aug#>', '<#MS_Sep#>', '<#MS_Oct#>', '<#MS_Nov#>', '<#MS_Dec#>'],
        weekdays: ['<#WF_Sun#>', '<#WF_Mon#>', '<#WF_Tue#>', '<#WF_Wed#>', '<#WF_Thu#>', '<#WF_Fri#>', '<#WF_Sat#>'],
        rangeSelectorZoom: '<#HSTOCK_Zoom#>'
    }
});

$j(document).ready(function(){
    $j("#tab_cpu_chart, #tab_mem_chart").click(function(){
        var newHash = $j(this).attr('href').toLowerCase();
        showChart(newHash,0);
        return false;
    });
    arrCharts[0] = new Highcharts.StockChart(cpu_chart);
    arrCharts[1] = new Highcharts.StockChart(mem_chart);
});

$j(window).bind('hashchange', function(){
    showChart(getHash(),1);
});

function initial(){
    show_banner(0);
    show_menu(6,-1,0);
    show_footer();

    showChart(getHash(),0);
}

function showChart(curHash,rdw){
    for(var i = 0; i < arrHashes.length; i++){
        if(curHash == ('#'+arrHashes[i])){
            $j('#tab_'+arrHashes[i]+'_chart').parents('li').addClass('active');
            $j('#'+arrHashes[i]+'_chart').show();
            if (rdw)
               arrCharts[i].redraw();
        }else{
            $j('#tab_'+arrHashes[i]+'_chart').parents('li').removeClass('active');
            $j('#'+arrHashes[i]+'_chart').hide();
        }
    }
    window.location.hash = curHash.toUpperCase();
}

function prepare_array_chart(){
    var data = [], x = (new Date()).getTime(), p = -450, i;
    x = parseInt(x/1000)*1000;
    for(i = p; i <= 0; i++)
        data.push([x+i*2000, 0]);
    return data;
}

function getHash(){
    var curHash = window.location.hash.toLowerCase();
    return (curHash != '#cpu' && curHash != '#mem') ? '#cpu' : curHash;
}

function bytesToMegabytes(bytes, precision){
    var kilobyte = 1024;
    var megabyte = kilobyte * 1024;
    return parseFloat((bytes / megabyte).toFixed(precision));
}

function getSystemJsonData(cpu,ram){
    if(typeof(cpu) !== 'object' || typeof(ram) !== 'object')
        return;
    var x = (new Date()).getTime();
    x = parseInt(x/1000)*1000;

    arrCharts[0].series[0].addPoint([x, parseInt(cpu.busy)], false, false);
    arrCharts[0].series[1].addPoint([x, parseInt(cpu.user)], false, false);
    arrCharts[0].series[2].addPoint([x, parseInt(cpu.system)], false, false);
    arrCharts[0].series[3].addPoint([x, parseInt(cpu.sirq)], false, false);

    arrCharts[1].yAxis[0].setExtremes(0, bytesToMegabytes(ram.total*1024, 2), false);
    arrCharts[1].series[0].addPoint([x, bytesToMegabytes(ram.used*1024, 2)], false, false);
    arrCharts[1].series[1].addPoint([x, bytesToMegabytes(ram.buffers*1024, 2)], false, false);
    arrCharts[1].series[2].addPoint([x, bytesToMegabytes(ram.cached*1024, 2)], false, false);

    if ($('cpu_chart').style.display == 'none')
        arrCharts[1].redraw();
    else
        arrCharts[0].redraw();
}
</script>
<style>
    #tabs {margin: 0 0 8px 0; padding: 0; list-style: none;}
    .info_tabs li {display: inline-block; margin-right: 4px;}
    .info_tabs a {
        display: inline-block;
        padding: 6px 16px;
        color: #c9d6dc;
        background: #2f3d42;
        border: 1px solid #6b8fa3;
        text-decoration: none;
    }
    .info_tabs li.active a {
        color: #FFFFFF;
        background: #596e74;
    }
    .system_chart {
        width: 100%;
        padding-left: 0;
    }
    .system_chart_wrap {
        width: 100%;
    }
</style>
</head>
<body onload="initial();" class="bg">
    <div id="TopBanner"></div>

    <div id="Loading" class="popup_bg"></div>

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

    <table class="content" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td width="17">&nbsp;</td>
            <td valign="top" width="202">
                <div id="mainMenu"></div>
                <div id="subMenu"></div>
            </td>
            <td valign="top">
                <div id="tabMenu" class="submenuBlock"></div>
                <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="left" valign="top">
                            <table width="760px" border="0" cellpadding="5" cellspacing="0" class="FormTitle" id="FormTitle">
                                <tbody>
                                    <tr>
                                        <td bgcolor="#4D595D" valign="top">
                                            <div class="container">
                                                <div>&nbsp;</div>
                                                <div class="formfonttitle"><#menu5_8#></div>
                                                <div style="margin:10px 0 10px 5px;" class="splitLine"></div>

                                                <div id="tab-area">
                                                    <ul id="tabs" class="info_tabs">
                                                        <li><a href="#CPU" id="tab_cpu_chart"><#menu5_8_1#></a></li>
                                                        <li><a href="#MEM" id="tab_mem_chart"><#menu5_8_2#></a></li>
                                                    </ul>
                                                </div>

                                                <div class="system_chart_wrap">
                                                    <div id="cpu_chart" class="system_chart"></div>
                                                    <div id="mem_chart" class="system_chart"></div>
                                                </div>
                                            </div>
                                            <div class="popup_container popup_element_second"></div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
            <td width="10" align="center" valign="top">&nbsp;</td>
        </tr>
    </table>

    <div id="footer"></div>
</body>
</html>
