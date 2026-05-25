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
<link rel="stylesheet" type="text/css" href="/NM_style.css">
<link rel="stylesheet" type="text/css" href="/other.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/merlin_adapter.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/disk_functions.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script>
var $j = jQuery.noConflict();

<% disk_pool_mapping_info(); %>
<% available_disk_names_and_sizes(); %>
<% get_usb_ports_info(); %>
<% get_ext_ports_info(); %>

var all_disks = foreign_disks().concat(blank_disks());
var all_disk_interface = foreign_disk_interface_names().concat(blank_disk_interface_names());

var flag = '<% get_parameter("flag"); %>';
var disk_number = foreign_disks().length+blank_disks().length;

var ccount = <% get_static_ccount(); %>;

function initial(){
	show_banner(0);
	show_menu(1, -1, 0);
	show_footer();
	show_usb_ports();
	show_ata_pool();
	show_mmc_card();
	show_middle_status();
	show_client_status(ccount);
	set_default_choice();

	if (!support_2g_radio() && !support_5g_radio()) {
		$("wlSecurityContext").style.display = "none";
	}

	if(sw_mode == '3')
		$("linkInternet").href = "/device-map/intranet.asp"

	update_internet_status();
}

function detect_update_info(){
	var str = $("internetStatus").innerHTML;
	if(str == "<#QKSet_detect_freshbtn#>...")
		refreshpage();
}

function show_default_icon(){
	var icon_name = "iconRouter";
	$("statusframe").src = "/device-map/router.asp";
	clickEvent($(icon_name));
}

function set_default_choice(){
	var icon_name;
	if(flag && flag.length > 0 && sw_mode != "3"){
		if(flag == "Internet")
			$("statusframe").src = "/device-map/internet.asp";
		else if(flag == "Client")
			$("statusframe").src = "/device-map/clients.asp";
		else if(flag == "Router2g")
			$("statusframe").src = "/device-map/router2g.asp";
		else if(flag == "Router5g")
			$("statusframe").src = "/device-map/router.asp";
		else{
			show_default_icon();
			return;
		}
		if(flag == "Router2g" || flag == "Router5g")
			icon_name = "iconRouter";
		else
			icon_name = "icon"+flag;
		clickEvent($(icon_name));
	}else
		show_default_icon();
}

function showMapWANStatus(flag){
	if(flag == 1){
		$j("#internetStatus").removeClass("mapStatus-warn mapStatus-off").addClass("mapStatus-on").html("<#Connected#>");
		$j("#NM_connect_status").removeClass("mapText-warn mapText-off").addClass("mapText-on").html("<#Connected#>");
		$j("#single_wan").removeClass("mapLine-warn mapLine-off").addClass("mapLine-on");
	}
	else if(flag == 2){
		$j("#internetStatus").removeClass("mapStatus-on mapStatus-off").addClass("mapStatus-warn").html("<#QKSet_detect_freshbtn#>");
		$j("#NM_connect_status").removeClass("mapText-on mapText-off").addClass("mapText-warn").html("<#QKSet_detect_freshbtn#>");
		$j("#single_wan").removeClass("mapLine-on mapLine-off").addClass("mapLine-warn");
	}
	else{
		$j("#internetStatus").removeClass("mapStatus-on mapStatus-warn").addClass("mapStatus-off").html("<#Disconnected#>");
		$j("#NM_connect_status").removeClass("mapText-on mapText-warn").addClass("mapText-off").html("<#Disconnected#>");
		$j("#single_wan").removeClass("mapLine-on mapLine-warn").addClass("mapLine-off");
	}
}

function show_middle_status(){
	var auth_mode = document.form.rt_auth_mode.value;
	var wpa_mode = document.form.rt_wpa_mode.value;
	var wl_wep_x = parseInt(document.form.rt_wep_x.value);
	var security_mode;

	if(auth_mode == "open")
		security_mode = "Open System";
	else if(auth_mode == "shared")
		security_mode = "Shared Key";
	else if(auth_mode == "psk"){
		if(wpa_mode == "1")
			security_mode = "WPA-Personal";
		else if(wpa_mode == "2")
			security_mode = "WPA2-Personal";
		else if(wpa_mode == "0")
			security_mode = "WPA-Auto-Personal";
		else
			alert("System error for showing auth_mode!");
	}
	else if(auth_mode == "wpa"){
		if(wpa_mode == "3")
			security_mode = "WPA-Enterprise";
		else if(wpa_mode == "4")
			security_mode = "WPA-Auto-Enterprise";
		else
			alert("System error for showing auth_mode!");
	}
	else if(auth_mode == "wpa2")
		security_mode = "WPA2-Enterprise";
	else if(auth_mode == "radius")
		security_mode = "Radius with 802.1x";

	if(auth_mode == "open" && wl_wep_x == 0) {
		$j("#wl_securitylevel_span").removeClass("mapText-on").addClass("mapText-off").html(security_mode);
		$("iflock").src = "images/New_ui/networkmap/unlock.png";
	} else {
		$j("#wl_securitylevel_span").removeClass("mapText-off").addClass("mapText-on").html(security_mode);
		$("iflock").src = "images/New_ui/networkmap/lock.png";
	}
}

function show_client_status(clients_count){
	var client_str = "";
	var wired_num = 0, wireless_num = 0;

	client_str += "<#Full_Clients#>: <span>"+clients_count+"</span>";
	$j("#clientNumber").html(client_str);
}

function show_usb_ports(){
	var i;
	var dev_type_usb;
	var usb_ports_num = get_usb_ports_num();

	if (usb_ports_num < 1) {
		$("row_usb_port1").style.display = "none";
		return;
	}

	dev_type_usb = get_device_type_usb(1);
	switch(dev_type_usb){
		case "hub":
			hub_html(0);
			break;
		case "storage":
			for(i = 0; i < all_disks.length; ++i)
				if(foreign_disk_interface_names()[i] == "1"){
					disk_html(0, i);
					break;
				}
			break;
		case "printer":
			for(i = 0; i < printer_ports().length; ++i)
				if(printer_ports()[i] == "1"){
					printer_html(0, i);
					break;
				}
			break;
		case "modem_tty":
		case "modem_eth":
			for(i = 0; i < modem_ports().length; ++i)
				if(modem_ports()[i] == "1"){
					modem_html(0, i);
					break;
				}
			break;
		default:
			no_usb_device_html(0);
	}

	if (usb_ports_num < 2)
		return;

	$("row_usb_port2").style.display = "";

	dev_type_usb = get_device_type_usb(2);
	switch(dev_type_usb){
		case "hub":
			hub_html(1);
			break;
		case "storage":
			for(i = 0; i < all_disks.length; ++i)
				if(foreign_disk_interface_names()[i] == "2"){
					disk_html(1, i);
					break;
				}
			break;
		case "printer":
			for(i = 0; i < printer_ports().length; ++i)
				if(printer_ports()[i] == "2"){
					printer_html(1, i);
					break;
				}
			break;
		case "modem_tty":
		case "modem_eth":
			for(i = 0; i < modem_ports().length; ++i)
				if(modem_ports()[i] == "2"){
					modem_html(1, i);
					break;
				}
			break;
		default:
			no_usb_device_html(1);
	}
}

function show_ata_pool(){
	var i;
	var dev_found = 0;

	if (typeof(get_ata_support) !== 'function')
		return;

	if (!get_ata_support())
		return;

	$("row_ata_pool").style.display = "";

	for(i = 0; i < all_disks.length; ++i){
		if(foreign_disk_interface_names()[i] == "1000"){
			dev_found = 1;
			ata_html(i);
			break;
		}
	}

	if (!dev_found)
		no_device_html("sataIcon");
}

function show_mmc_card(){
	var i;
	var dev_found = 0;

	if (typeof(get_mmc_support) !== 'function')
		return;

	if (!get_mmc_support())
		return;

	$("row_mmc_slot").style.display = "";

	for(i = 0; i < all_disks.length; ++i){
		if(foreign_disk_interface_names()[i] == "2000"){
			dev_found = 1;
			mmc_html(i);
			break;
		}
	}

	if (!dev_found)
		no_device_html("cardIcon");
}

function dec_html(all_disk_order){
	var dec_html_code = '';
	var TotalSize;
	var all_accessable_size;
	var percentbar = 0;
	var alertPercentbar = 'progress-info';
	var mount_num = getDiskMountedNum(all_disk_order);

	if(mount_num > 0){
		if(all_disk_order < foreign_disks().length)
			TotalSize = simpleNum(foreign_disk_total_size()[all_disk_order]);
		else
			TotalSize = simpleNum(blank_disk_total_size()[all_disk_order-foreign_disks().length]);
		
		all_accessable_size = simpleNum2(computeallpools(all_disk_order, "size")-computeallpools(all_disk_order, "size_in_use"));
		
		percentbar = simpleNum2((all_accessable_size)/TotalSize*100);
		percentbar = Math.round(100-percentbar);
		if(percentbar >= 66 && percentbar < 85)
			alertPercentbar = 'progress-warning';
		else if(percentbar >= 85)
			alertPercentbar = 'progress-danger';
		dec_html_code += '<div id="diskquota">\n';
		dec_html_code += '<div style="margin-bottom: 10px;" class="progress ' + alertPercentbar + '"><div class="bar" style="width:'+percentbar+'%">'+(percentbar > 10 ? (percentbar + '%') : '')+'</div></div>';
		dec_html_code += '</div>\n';
		dec_html_code += '<strong><#Totaldisk#></strong>: '+TotalSize+' GB<br>\n';
		dec_html_code += '<span class="style1"><strong><#Availdisk#></strong>: '+(all_accessable_size)+' GB</span>\n';
	}else
		dec_html_code += '<span class="style1"><strong><#DISK_UNMOUNTED#></strong></span>\n';

	return dec_html_code;
}

function dec_share_icon(device_dec){
	device_dec.removeClass("mapStatus-off").addClass("mapStatus-on");
	device_dec.html("<#CTL_Enabled#>");
}

function disk_html(device_order,all_disk_order){
	var device_icon = $("deviceIcon_"+device_order);
	var device_dec = $j("#deviceDec_"+device_order);
	var icon_html_code = '';
	var dec_html_code = '';
	var disk_model_name = "";

	if(all_disk_order < foreign_disks().length)
		disk_model_name = foreign_disk_model_info()[all_disk_order];
	else
		disk_model_name = blank_disks()[all_disk_order-foreign_disks().length];

	dec_html_code = dec_html(all_disk_order);

	icon_html_code += '<a href="device-map/disk.asp" target="statusframe" style="outline:0;">\n';
	icon_html_code += '    <div id="iconUSBdisk'+all_disk_order+'" class="iconUSBdisk mapDeviceIcon" rel="rollover_disk" data-original-title="'+disk_model_name+'" data-content="'+(dec_html_code.replace(new RegExp('"', 'g'), "'"))+'" onclick="setSelectedDiskOrder(this.id);clickEvent(this);"></div>\n';
	icon_html_code += '</a>\n';

	device_icon.innerHTML = icon_html_code;

	dec_share_icon(device_dec);
}

function printer_html(device_seat, printer_order){
	var device_icon = $("deviceIcon_"+device_seat);
	var device_dec = $j("#deviceDec_"+device_seat);
	var icon_html_code = '';

	icon_html_code += '<a href="device-map/printer.asp" target="statusframe" style="outline:0;">\n';
	icon_html_code += '    <div id="iconPrinter'+printer_order+'" class="iconPrinter mapDeviceIcon" onclick="clickEvent(this);"></div>\n';
	icon_html_code += '</a>\n';

	device_icon.innerHTML = icon_html_code;

	dec_share_icon(device_dec);
}

function modem_html(device_seat, modem_order){
	var device_icon = $("deviceIcon_"+device_seat);
	var device_dec = $j("#deviceDec_"+device_seat);
	var icon_html_code = '';

	icon_html_code += '<a href="device-map/modem.asp" target="statusframe" style="outline:0;">\n';
	icon_html_code += '    <div id="iconModem'+modem_order+'" class="iconmodem mapDeviceIcon" onclick="clickEvent(this);"></div>\n';
	icon_html_code += '</a>\n';

	device_icon.innerHTML = icon_html_code;

	dec_share_icon(device_dec);
}

function hub_html(device_seat){
	var device_icon = $("deviceIcon_"+device_seat);
	var device_dec = $j("#deviceDec_"+device_seat);
	var icon_html_code = '';

	icon_html_code += '<a href="device-map/hub.asp" target="statusframe" style="outline:0;">\n';
	icon_html_code += '    <div id="iconHub'+device_seat+'" class="iconUSBdisk mapDeviceIcon" onclick="clickEvent(this);"></div>\n';
	icon_html_code += '</a>\n';

	device_icon.innerHTML = icon_html_code;

	dec_share_icon(device_dec);
}

function ata_html(){
	var device_icon = $("sataIcon");
	var device_dec = $j("#sataDec");
	var icon_html_code = '';

	icon_html_code += '<a href="device-map/sata.asp" target="statusframe" style="outline:0;">\n';
	icon_html_code += '    <div id="iconSATA" class="iconM2 mapDeviceIcon" onclick="clickEvent(this);"></div>\n';
	icon_html_code += '</a>\n';

	device_icon.innerHTML = icon_html_code;

	dec_share_icon(device_dec);
}

function mmc_html(all_disk_order){
	var device_icon = $("cardIcon");
	var device_dec = $j("#cardDec");
	var icon_html_code = '';
	var dec_html_code = '';
	var disk_model_name = "";

	if(all_disk_order < foreign_disks().length)
		disk_model_name = foreign_disk_model_info()[all_disk_order];
	else
		disk_model_name = blank_disks()[all_disk_order-foreign_disks().length];

	dec_html_code = dec_html(all_disk_order);

	icon_html_code += '<a href="device-map/disk.asp" target="statusframe" style="outline:0;">\n';
	icon_html_code += '    <div id="iconCard'+all_disk_order+'" class="iconM2 mapDeviceIcon" rel="rollover_disk" data-original-title="'+disk_model_name+'" data-content="'+(dec_html_code.replace(new RegExp('"', 'g'), "'"))+'" onclick="setSelectedDiskOrder(this.id);clickEvent(this);"></div>\n';
	icon_html_code += '</a>\n';

	device_icon.innerHTML = icon_html_code;

	dec_share_icon(device_dec);
}

function no_device_html(device_name){
	var device_icon = $(device_name);
	device_icon.innerHTML = '<div class="iconNo mapDeviceIcon"></div>'
}

function no_usb_device_html(device_seat){
	no_device_html("deviceIcon_"+device_seat);
}


var avoidkey;
var lastClicked;
var lastName;
var clicked_device_order;

function get_clicked_device_order(){
	return clicked_device_order;
}

function clickEvent(obj){
	var stitle;
	var seat;
	var current_src;

	clicked_device_order = -1;

	if(obj.id == "iflock"){
		obj = $("iconRouter");
	}

	if(obj.id.indexOf("Internet") > 0){
		if (sw_mode == '3'){
			stitle = "<#statusTitle_Intranet#>";
			$("statusframe").src = "/device-map/intranet.asp";
		}else{
			stitle = "<#statusTitle_Internet#>";
			$("statusframe").src = "/device-map/internet.asp";
		}
	}
	else if(obj.id.indexOf("Router") > 0){
		stitle = "<#statusTitle_System#>";
		current_src = $("statusframe").getAttribute("src") || "";
		if(current_src.indexOf("/device-map/router") < 0)
			$("statusframe").src = "/device-map/router.asp";
	}
	else if(obj.id.indexOf("Client") > 0){
		stitle = "<#statusTitle_Client#>";
		$("statusframe").src = "/device-map/clients.asp";
	}
	else if(obj.id.indexOf("USBdisk") > 0){
		stitle = "<#statusTitle_USB_Disk#>";
		$("statusframe").src = "/device-map/disk.asp";
	}
	else if(obj.id.indexOf("Printer") > 0){
		seat = obj.id.indexOf("Printer")+7;
		clicked_device_order = parseInt(obj.id.substring(seat, seat+1));
		stitle = "<#statusTitle_Printer#>";
		$("statusframe").src = "/device-map/printer.asp";
	}
	else if(obj.id.indexOf("Modem") > 0){
		seat = obj.id.indexOf("Modem")+5;
		clicked_device_order = parseInt(obj.id.substring(seat, seat+1));
		stitle = "<#statusTitle_Modem#>";
		$("statusframe").src = "/device-map/modem.asp";
	}
	else if(obj.id.indexOf("Hub") > 0){
		seat = obj.id.indexOf("Hub")+3;
		clicked_device_order = parseInt(obj.id.substring(seat, seat+1));
		stitle = "<#statusTitle_Hub#>";
		$("statusframe").src = "/device-map/hub.asp";
	}
	else if(obj.id.indexOf("SATA") > 0){
		stitle = "<#statusTitle_SATA#>";
		$("statusframe").src = "/device-map/sata.asp";
	}
	else if(obj.id.indexOf("Card") > 0){
		stitle = "<#statusTitle_Card#>";
		$("statusframe").src = "/device-map/disk.asp";
	}
	else if(obj.id.indexOf("No") > 0){
		return;
	}

	$j(".mapNode").removeClass("mapNode-active");
	$j(obj).closest(".mapNode").addClass("mapNode-active");

	$('helpname').innerHTML = stitle;

	lastClicked = obj;
	lastName = obj.id;
}

function mouseEvent(obj, key){
	return;
}

$j(document).ready(function(){
	$j('div[rel=rollover_disk]').popover();
});
</script>

	<style>
		.badge{
			display: inline-block;
			min-width: 14px;
		padding: 2px 5px 3px 5px;
		border-radius: 10px;
		color: #FFF;
		font-size: 11px;
		font-weight: bold;
		line-height: 14px;
		text-align: center;
		background-color: #999;
		}
		.badge-success{ background-color: #468847; }
		.badge-warning{ background-color: #f89406; }
		.badge-important{ background-color: #b94a48; }
		.progress{
			height: 18px;
		margin-bottom: 8px;
		overflow: hidden;
		background: #D8E0E3;
		border-radius: 3px;
	}
	.progress .bar{
		height: 18px;
		color: #FFF;
		font-size: 11px;
		line-height: 18px;
		text-align: center;
		background: #3A87AD;
	}
		.progress-warning .bar{ background: #F89406; }
		.progress-danger .bar{ background: #B94A48; }
		.index_status{
			font-family: Verdana, Arial, Helvetica, MS UI Gothic, MS P Gothic, Microsoft Yahei UI, sans-serif;
			font-weight: bold;
		}
		.NM_table{
			width: 740px;
			min-height: 820px;
		}
		.mapNode{
			cursor: pointer;
			transition: filter .15s ease-out, outline-color .15s ease-out;
		}
		.mapNode-active{
			outline: 2px solid #9fd8ff;
			outline-offset: -2px;
			filter: brightness(1.08);
		}
		.mapStatus-on,
		.mapStatus-warn,
		.mapStatus-off{
			display: inline-block;
			min-width: 52px;
			padding: 3px 8px;
			border-radius: 10px;
			font-size: 11px;
			font-weight: bold;
			line-height: 14px;
			color: #FFF;
		}
		.mapStatus-on{ background-color: #2f855a; }
		.mapStatus-warn{ background-color: #b7791f; }
		.mapStatus-off{ background-color: #b94a48; }
		.mapText-on{ color: #9fd8ff; }
		.mapText-warn{ color: #ffd36a; }
		.mapText-off{ color: #ff8f8f; }
		.mapLine-on{
			width: 3px;
			height: 35px;
			margin: 0 auto;
			background: #76b900;
			box-shadow: 0 0 8px #76b900;
		}
		.mapLine-warn{
			width: 3px;
			height: 35px;
			margin: 0 auto;
			background: #ffcc00;
			box-shadow: 0 0 8px #ffcc00;
		}
		.mapLine-off{
			width: 3px;
			height: 35px;
			margin: 0 auto;
			background: #9b2c2c;
		}
		.mapDeviceCell{
			width: 160px;
			padding-bottom: 14px;
		}
		.mapDeviceIcon{
			margin: 18px auto 6px auto;
		}
		.mapDeviceTitle{
			font: bold 13px Verdana, Arial, Helvetica, MS UI Gothic, MS P Gothic, Microsoft Yahei UI, sans-serif;
			color: #FFF;
			margin-top: 4px;
		}
		.mapDeviceStatus{
			min-height: 22px;
			margin-top: 8px;
		}
		#statusframe{
			display: block;
			margin-left: 0;
			height: 760px;
			width: 320px;
			background-color: #2A3539;
		}
	</style>
</head>

<body onload="initial();" onunload="return unload_body();" class="bg">

    <noscript>
        <div class="popup_bg" style="visibility:visible; z-index:999;">
            <div style="margin:200px auto; width:300px; background-color:#006699; color:#FFFFFF; line-height:150%; border:3px solid #FFF; padding:5px;"><#not_support_script#></p></div>
        </div>
    </noscript>

    <div id="TopBanner"></div>

    <div id="Loading" class="popup_bg"></div>

    <iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0" scrolling="no" style="position: absolute;"></iframe>

    <form name="form">
    <input type="hidden" name="current_page" value="index.asp">
    <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get_x("", "preferred_lang"); %>">
    <input type="hidden" name="wl_auth_mode" value="<% nvram_get_x("",  "wl_auth_mode"); %>">
    <input type="hidden" name="wl_wpa_mode" value="<% nvram_get_x("",  "wl_wpa_mode"); %>">
    <input type="hidden" name="wl_wep_x" value="<% nvram_get_x("",  "wl_wep_x"); %>">
    <input type="hidden" name="rt_auth_mode" value="<% nvram_get_x("",  "rt_auth_mode"); %>">
    <input type="hidden" name="rt_wpa_mode" value="<% nvram_get_x("",  "rt_wpa_mode"); %>">
    <input type="hidden" name="rt_wep_x" value="<% nvram_get_x("",  "rt_wep_x"); %>">
    </form>

    <form name="rt_form">
    <input type="hidden" name="rt_ssid" value="">
    <input type="hidden" name="rt_wpa_mode" value="">
    <input type="hidden" name="rt_key1" value="">
    <input type="hidden" name="rt_key2" value="">
    <input type="hidden" name="rt_key3" value="">
    <input type="hidden" name="rt_key4" value="">
    <input type="hidden" name="rt_ssid2" value="">
    <input type="hidden" name="rt_key_type" value="">
    <input type="hidden" name="rt_auth_mode" value="">
    <input type="hidden" name="rt_wep_x" value="">
    <input type="hidden" name="rt_key" value="">
    <input type="hidden" name="rt_asuskey1" value="">
    <input type="hidden" name="rt_crypto" value="">
    <input type="hidden" name="rt_wpa_psk" value="">
    </form>

    <form name="wl_form">
    <input type="hidden" name="wl_ssid" value="">
    <input type="hidden" name="wl_wpa_mode" value="">
    <input type="hidden" name="wl_key1" value="">
    <input type="hidden" name="wl_key2" value="">
    <input type="hidden" name="wl_key3" value="">
    <input type="hidden" name="wl_key4" value="">
    <input type="hidden" name="wl_gmode" value="">
    <input type="hidden" name="wl_ssid2" value="">
    <input type="hidden" name="wl_key_type" value="">
    <input type="hidden" name="wl_auth_mode" value="">
    <input type="hidden" name="wl_wep_x" value="">
    <input type="hidden" name="wl_key" value="">
    <input type="hidden" name="wl_asuskey1" value="">
    <input type="hidden" name="wl_crypto" value="">
    <input type="hidden" name="wl_wpa_psk" value="">
    </form>

    <table class="content" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td width="17">&nbsp;</td>
            <td valign="top" width="202">
                <div id="mainMenu"></div>
                <div id="subMenu"></div>
            </td>
            <td valign="top">
                <div id="tabMenu"></div>
                <div id="NM_table" class="NM_table">
                    <div id="NM_table_div">
                        <div style="width:50%;float:left;">
                            <table id="_NM_table" border="0" cellpadding="0" cellspacing="0" height="720" style="opacity:.95;">
                                <tr>
                                    <td width="40" rowspan="11" valign="center"></td>
                                    <td id="single_wan_icon" align="right" class="NM_radius_left mapNode" valign="middle" bgcolor="#444f53" onclick="clickEvent($('iconInternet'));">
                                        <a id="linkInternet" href="/device-map/internet.asp" target="statusframe" style="outline:0;"><div id="iconInternet" onclick="clickEvent(this);"></div></a>
                                    </td>
                                    <td id="single_wan_status" colspan="2" valign="middle" bgcolor="#444f53" class="NM_radius_right mapNode" style="padding:5px;cursor:pointer;width:180px;height:130px" onclick="clickEvent($('iconInternet'));">
                                        <div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
                                        <div id="NM_connect_title" style="font-size:12px;font-family:Verdana, Arial, Helvetica, sans-serif;"><#statusTitle_Internet#>:</div>
                                        <div id="NM_connect_status" class="index_status mapText-warn" style="font-size:14px;"><#QIS_step2#>...</div>
                                        <div style="margin-top:10px;">
                                            <span style="font-size:12px;font-family:Verdana, Arial, Helvetica, sans-serif;"><#Status_Str#>:</span>
                                            <div id="internetStatus" class="mapStatus-warn" style="margin-top:5px;"><#QKSet_detect_freshbtn#></div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td id="single_wan_line" colspan="3" align="center" height="35">
                                        <div id="single_wan" class="mapLine-warn"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" bgcolor="#444f53" class="NM_radius_left mapNode" onclick="clickEvent($('iconRouter'));" style="height:150px">
                                        <a id="iconRouterLink" href="device-map/router.asp" target="statusframe" style="outline:0;"><div id="iconRouter" onclick="clickEvent(this);"></div></a>
                                    </td>
                                    <td colspan="2" valign="middle" bgcolor="#444f53" class="NM_radius_right mapNode" onclick="clickEvent($('iconRouter'));">
                                        <div id="wlSecurityContext">
                                            <span style="font-size:14px;font-family:Verdana, Arial, Helvetica, sans-serif;"><#Security#>:</span><br>
                                            <strong id="wl_securitylevel_span" class="index_status"></strong>
                                            <img id="iflock" onclick="clickEvent(this);" style="vertical-align:middle;margin-left:6px;">
                                        </div>
                                        <div style="margin-top:12px;font-size:12px;font-family:Verdana, Arial, Helvetica, sans-serif;">
                                            <#menu5_1#>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td id="line3_td" colspan="3" align="center" height="35">
                                        <img id="line3_img" src="/images/New_ui/networkmap/line_two.png" style="margin-top:-5px;">
                                    </td>
                                </tr>
                                <tr>
                                    <td id="clients_td" width="150" bgcolor="#444f53" align="center" valign="top" class="NM_radius mapNode" style="padding-bottom:15px;" onclick="clickEvent($('iconClient'));">
                                        <div id="clientsContainer">
                                            <a id="clientStatusLink" href="device-map/clients.asp" target="statusframe" style="outline:0;"><div id="iconClient" style="margin:20px auto 0 auto;" onclick="clickEvent(this);"></div></a>
                                            <div class="clients" id="clientNumber" style="cursor:pointer;"></div>
                                        </div>
                                    </td>
                                    <td width="36" rowspan="6" id="clientspace_td"></td>
                                    <td id="usb_td" width="160" bgcolor="#444f53" align="center" valign="top" class="NM_radius mapDeviceCell" style="min-height:420px;">
                                        <div id="row_usb_port1" class="mapNode" onclick="if($('deviceIcon_0').firstChild){clickEvent($('deviceIcon_0').getElementsByTagName('div')[0]);}">
                                            <div id="deviceIcon_0"><div class="iconNo mapDeviceIcon"></div></div>
                                            <div class="mapDeviceTitle">USB 1</div>
                                            <div id="deviceDec_0" class="mapDeviceStatus mapStatus-off"><#Disconnected#></div>
                                        </div>
                                        <div id="row_usb_port2" class="mapNode" style="display:none" onclick="if($('deviceIcon_1').firstChild){clickEvent($('deviceIcon_1').getElementsByTagName('div')[0]);}">
                                            <div id="deviceIcon_1"><div class="iconNo mapDeviceIcon"></div></div>
                                            <div class="mapDeviceTitle">USB 2</div>
                                            <div id="deviceDec_1" class="mapDeviceStatus mapStatus-off"><#Disconnected#></div>
                                        </div>
                                        <div id="row_ata_pool" class="mapNode" style="display:none" onclick="if($('sataIcon').firstChild){clickEvent($('sataIcon').getElementsByTagName('div')[0]);}">
                                            <div id="sataIcon"><div class="iconNoM2 mapDeviceIcon"></div></div>
                                            <div class="mapDeviceTitle">SATA</div>
                                            <div id="sataDec" class="mapDeviceStatus mapStatus-off"><#Disconnected#></div>
                                        </div>
                                        <div id="row_mmc_slot" class="mapNode" style="display:none" onclick="if($('cardIcon').firstChild){clickEvent($('cardIcon').getElementsByTagName('div')[0]);}">
                                            <div id="cardIcon"><div class="iconNoM2 mapDeviceIcon"></div></div>
                                            <div class="mapDeviceTitle">MMC</div>
                                            <div id="cardDec" class="mapDeviceStatus mapStatus-off"><#Disconnected#></div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style="width:50%;float:left;">
                            <table id="_NM_table_status" border="0" cellpadding="0" cellspacing="0" style="opacity:.95;">
                                <tr>
                                    <td valign="top">
                                        <div class="statusTitle" id="statusTitle_NM">
                                            <div id="helpname" style="padding-top:10px;font-size:16px;"></div>
                                        </div>
                                        <div class="NM_radius_bottom_container">
                                            <iframe id="statusframe" class="NM_radius_bottom" name="statusframe" src="/device-map/router.asp" frameborder="0"></iframe>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <br style="clear:both;">
                    </div>
                </div>
            </td>
            <td width="10" align="center" valign="top">&nbsp;</td>
        </tr>
    </table>

    <div id="footer"></div>
    <script>
    if(flag == "Internet" || flag == "Client")
        $("statusframe").src = "";
    </script>
</body>
</html>
