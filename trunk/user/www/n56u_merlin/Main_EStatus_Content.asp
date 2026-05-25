<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/index_style.css">
<link rel="stylesheet" type="text/css" href="/form_style.css">
<link rel="stylesheet" type="text/css" href="/other.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/merlin_adapter.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script>
var $j = jQuery.noConflict();
var id_timer_mib = 0;
var eth_port_id = 0;

$j(window).bind('hashchange', function(){
	update_page();
	update_tabs();
	set_mib_data();
});

function initial(){
	show_banner(1);
	show_menu(5,9,get_page_id());
	show_footer();
	update_page();
	set_mib_data();
}

function getHashId(){
	var curHash = window.location.hash;
	if (curHash == '')
		curHash = '#0';
	var id = parseInt(curHash.replace('#', '0'));
	if (isNaN(id))
		return 0;
	return id;
}

function get_page_id(){
	var page_id = getHashId() + 1;
    if (support_2g_radio())
        page_id += 1;
	if (support_5g_radio())
		page_id += 1;
	return page_id;
}

function update_page(){
	var port_nm = 'WAN';
	eth_port_id = getHashId();
	if (eth_port_id > 0)
		port_nm = 'LAN' + eth_port_id.toString();
	$("hdr_port").innerHTML = '<#menu5_9#> - ' + port_nm;
	document.title = '<#Web_Title#> - ' + port_nm;
}

function update_tabs(){
	var page_id = get_page_id()-1;
	$j('#tabMenu').children('ul').children('li').removeClass("active");
	$j('#tabMenu').children("ul").children("li").eq(page_id).addClass("active");
}

function set_mib_data(){
	clearTimeout(id_timer_mib);
	$j.ajax({
		type: 'get',
		url: '/status_eth_mib.asp',
		data: {
			port_id: eth_port_id
		},
		dataType: 'html',
		success: function(data){
			$j('#mib_area').text(data);
			id_timer_mib = setTimeout('set_mib_data()', 5000);
		}
	});
}
</script>
<style>
.status_log_area {
	width: 100%;
	height: 403px;
	box-sizing: border-box;
	font-family: "Courier New", Courier, mono;
	font-size: 13px;
	background: #111;
	color: #EEE;
	border: 1px solid #6b8fa3;
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
                                                <div class="formfonttitle" id="hdr_port"></div>
                                                <div style="margin:10px 0 10px 5px;" class="splitLine"></div>

                                                <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                                    <tr>
                                                        <td>
                                                            <textarea id="mib_area" rows="23" class="status_log_area" readonly="readonly" wrap="off"></textarea>
                                                        </td>
                                                    </tr>
                                                </table>

                                                <div class="apply_gen">
                                                    <input type="button" onClick="set_mib_data();" value="<#CTL_refresh#>" class="button_gen">
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
