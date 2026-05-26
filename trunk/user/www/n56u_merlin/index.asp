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
<% wanlink(); %>

var all_disks = foreign_disks().concat(blank_disks());
var all_disk_interface = foreign_disk_interface_names().concat(blank_disk_interface_names());

var flag = '<% get_parameter("flag"); %>';
var disk_number = foreign_disks().length+blank_disks().length;

var ccount = <% get_static_ccount(); %>;
var ipmonitor = [<% get_static_client(); %>];
var wireless = {<% wl_auth_list(); %>};
var clientListViewMode = "All";

var nmClientListText = (function(){
	var zh = (typeof merlin_preferred_lang != "undefined" && merlin_preferred_lang == "CN");
	return {
		viewList: zh ? "浏览名单" : "View List",
		all: zh ? "全部" : "All",
		interfaceTab: zh ? "接口" : "Interface",
		allList: zh ? "全部列表" : "All list",
		hide: zh ? "隐藏" : "Hide",
		internet: zh ? "互联网" : "Internet",
		icon: zh ? "图标" : "Icon",
		name: zh ? "客户端名称" : "Clients Name",
		ip: zh ? "客户端 IP 地址" : "Client IP address",
		mac: zh ? "客户端 MAC 地址" : "Clients MAC Address",
		interfaceCol: zh ? "接口" : "Interface",
		tx: zh ? "Tx 速率 (Mbps)" : "Tx Rate (Mbps)",
		rx: zh ? "Rx 速率 (Mbps)" : "Rx Rate (Mbps)",
		access: zh ? "访问时间" : "Access time",
		exportBtn: zh ? "导出" : "Export",
		wired: zh ? "有线" : "Wired",
		wireless: zh ? "无线" : "Wireless",
		allow: zh ? "允许互联网访问" : "Allow Internet access",
		noData: zh ? "没有数据" : "No data"
	};
})();

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
	update_index_wan_info();
}

function detect_update_info(){
	var str = $("internetStatus").innerHTML;
	if(str == "<#QKSet_detect_freshbtn#>...")
		refreshpage();
}

function show_default_icon(){
	$("statusframe").src = "/device-map/router_status.asp";
	$("helpname").innerHTML = "<#menu5_8#>";
	$j(".mapNode").removeClass("mapNode-active");
	reset_map_icon(lastClicked);
	lastClicked = null;
	lastName = "";
}

function set_default_choice(){
	var icon_name;
	if(flag && flag.length > 0 && sw_mode != "3"){
		if(flag == "Internet")
			$("statusframe").src = "/device-map/internet.asp";
			else if(flag == "Client")
				$("statusframe").src = "/device-map/router_status.asp";
		else if(flag == "Router2g")
			$("statusframe").src = "/device-map/router2g.asp";
		else if(flag == "Router5g")
			$("statusframe").src = "/device-map/router.asp";
		else if(flag == "Router")
			$("statusframe").src = "/device-map/router_status.asp";
		else{
			show_default_icon();
			return;
		}
			if(flag == "Client"){
				show_default_icon();
				return;
			}
			else if(flag == "Router2g" || flag == "Router5g")
				icon_name = "iconRouter";
		else
			icon_name = "icon"+flag;
		clickEvent($(icon_name));
	}else
		show_default_icon();
}

function showMapWANStatus(flag){
	if(flag == 1){
		$j("#internetStatus").removeClass("mapStatus-warn mapStatus-off").addClass("mapStatus-on mapStatus-plain").html("<#Connected#>");
		$j("#NM_connect_status").removeClass("mapText-warn mapText-off").addClass("mapText-on mapText-plain").html("<#Connected#>");
		$j("#single_wan").removeClass("mapLine-warn mapLine-off").addClass("mapLine-on");
	}
	else if(flag == 2){
		$j("#internetStatus").removeClass("mapStatus-on mapStatus-off").addClass("mapStatus-warn mapStatus-plain").html("<#QKSet_detect_freshbtn#>");
		$j("#NM_connect_status").removeClass("mapText-on mapText-off").addClass("mapText-warn mapText-plain").html("<#QKSet_detect_freshbtn#>");
		$j("#single_wan").removeClass("mapLine-on mapLine-off").addClass("mapLine-warn");
	}
	else{
		$j("#internetStatus").removeClass("mapStatus-on mapStatus-warn").addClass("mapStatus-off mapStatus-plain").html("<#Disconnected#>");
		$j("#NM_connect_status").removeClass("mapText-on mapText-warn").addClass("mapText-off mapText-plain").html("<#Disconnected#>");
		$j("#single_wan").removeClass("mapLine-on mapLine-warn").addClass("mapLine-off");
	}
}

function update_index_wan_info(){
	if(typeof wanlink_ip4_wan != "function")
		return;

	var wan_ip = wanlink_ip4_wan();
	if(!wan_ip || wan_ip == "0.0.0.0")
		wan_ip = "--";

	$j("#wanIPStatus").html(wan_ip);

	var ddns_host = '<% nvram_get_x("", "ddns_hostname_x"); %>';
	if(ddns_host && ddns_host.length > 0){
		$j("#ddnsHostName").html(ddns_host);
		$j("#ddnsHostName_div").show();
	}
	else
		$j("#ddnsHostName_div").hide();
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
	applyClientListText();
}

function applyClientListText(){
	$j("#clientListButton").val(nmClientListText.viewList);
	$j("#clientListTabAll span").html(nmClientListText.all);
	$j("#clientListTabInterface span").html(nmClientListText.interfaceTab);
	$j("#clientListThInternet").html(nmClientListText.internet);
	$j("#clientListThIcon").html(nmClientListText.icon);
	$j("#clientListThName").html(nmClientListText.name);
	$j("#clientListThIp").html(nmClientListText.ip);
	$j("#clientListThMac").html(nmClientListText.mac);
	$j("#clientListThInterface").html(nmClientListText.interfaceCol);
	$j("#clientListThTx").html(nmClientListText.tx.replace(" (", "<br>("));
	$j("#clientListThRx").html(nmClientListText.rx.replace(" (", "<br>("));
	$j("#clientListThAccess").html(nmClientListText.access);
	$j("#clientListExportButton").val(nmClientListText.exportBtn);
}

function get_networkmap_clients(){
	if(typeof getclients != "function")
		return [];

	return getclients(1, 0);
}

function html_escape(str){
	if(str == null)
		return "";

	return String(str)
		.replace(/&/g, "&amp;")
		.replace(/</g, "&lt;")
		.replace(/>/g, "&gt;")
		.replace(/"/g, "&quot;")
		.replace(/'/g, "&#39;");
}

function get_client_name(client){
	return (client[0] && client[0] != "*") ? client[0] : client[2];
}

function get_client_interface(client){
	if(client[3] == 10)
		return {type:"wireless", label:nmClientListText.wireless, sort:1};

	return {type:"wired", label:nmClientListText.wired, sort:0};
}

function get_client_icon_html(client){
	var type = client[5] || "1";
	return "<img class='nmClientDeviceIcon' title='" + html_escape(type) + "' src='/bootstrap/img/wl_device/" + html_escape(type) + ".gif'>";
}

function get_client_interface_html(client){
	var iface = get_client_interface(client);
	if(iface.type == "wireless")
		return "<div class='nmClientInterface nmClientInterface-wifi'><span></span><strong>" + html_escape(iface.label) + "</strong></div>";

	return "<div class='nmClientInterface nmClientInterface-wired'><span></span><strong>" + html_escape(iface.label) + "</strong></div>";
}

function get_client_rows(){
	var rows = [];
	var list = get_networkmap_clients();

	for(var i = 0; i < list.length; i++){
		var client = list[i];
		var iface = get_client_interface(client);
		rows.push({
			internet: nmClientListText.allow,
			icon: get_client_icon_html(client),
			name: get_client_name(client),
			ip: client[1] || "-",
			mac: (typeof mac_add_delimiters == "function") ? mac_add_delimiters(client[2]) : client[2],
			interfaceHtml: get_client_interface_html(client),
			interfaceText: iface.label,
			tx: "-",
			rx: "-",
			access: "-",
			sort: iface.sort
		});
	}

	if(clientListViewMode == "ByInterface"){
		rows.sort(function(a, b){
			if(a.sort != b.sort)
				return a.sort - b.sort;
			return a.name.localeCompare(b.name);
		});
	}

	return rows;
}

function showClientlistModal(){
	clientListViewMode = "All";
	applyClientListText();
	$j("#clientListViewMask").show();
	$j("#clientListViewPanel").show();
	renderClientListView();
}

function hideClientlistModal(){
	$j("#clientListViewPanel").hide();
	$j("#clientListViewMask").hide();
}

function changeClientListViewMode(mode){
	clientListViewMode = mode;
	renderClientListView();
}

function renderClientListView(){
	var rows = get_client_rows();
	var headerText = (clientListViewMode == "ByInterface") ? nmClientListText.interfaceTab : nmClientListText.allList;
	var html = "";

	$j("#clientListTabAll").toggleClass("active", clientListViewMode == "All");
	$j("#clientListTabInterface").toggleClass("active", clientListViewMode == "ByInterface");
	$j("#clientListViewHeader").html(headerText + "<a href='javascript:void(0);' onclick='hideClientlistModal(); return false;'>[ " + nmClientListText.hide + " ]</a>");

	if(rows.length < 1){
		html += "<tr><td colspan='9' class='nmClientNoData'>" + nmClientListText.noData + "</td></tr>";
	}
	else{
		for(var i = 0; i < rows.length; i++){
			html += "<tr>";
			html += "<td><div class='nmClientInternetIcon' title='" + html_escape(rows[i].internet) + "'></div></td>";
			html += "<td>" + rows[i].icon + "</td>";
			html += "<td class='nmClientName'>" + html_escape(rows[i].name) + "</td>";
			html += "<td class='nmClientIp'>" + html_escape(rows[i].ip) + "<span>DHCP</span></td>";
			html += "<td>" + html_escape(rows[i].mac) + "</td>";
			html += "<td>" + rows[i].interfaceHtml + "</td>";
			html += "<td>" + html_escape(rows[i].tx) + "</td>";
			html += "<td>" + html_escape(rows[i].rx) + "</td>";
			html += "<td>" + html_escape(rows[i].access) + "</td>";
			html += "</tr>";
		}
	}

	$j("#clientListTableBody").html(html);
}

function exportClientListLog(){
	var rows = get_client_rows();
	var csv = [
		[
			"Internet access state",
			"Device Type",
			"Client Name",
			"Client IP address",
			"Clients MAC Address",
			"Interface",
			"Tx Rate",
			"Rx Rate",
			"Access time"
		]
	];

	for(var i = 0; i < rows.length; i++){
		csv.push([
			rows[i].internet,
			"",
			rows[i].name,
			rows[i].ip,
			rows[i].mac,
			rows[i].interfaceText,
			rows[i].tx,
			rows[i].rx,
			rows[i].access
		]);
	}

	var csvContent = "";
	for(var j = 0; j < csv.length; j++){
		for(var k = 0; k < csv[j].length; k++){
			csv[j][k] = '"' + String(csv[j][k]).replace(/"/g, '""') + '"';
		}
		csvContent += csv[j].join(",") + "\n";
	}

	var link = document.createElement("a");
	link.href = "data:text/csv;charset=utf-8," + encodeURIComponent(csvContent);
	link.download = "ClientList.csv";
	document.body.appendChild(link);
	link.click();
	document.body.removeChild(link);
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
		stitle = "<#menu5_8#>";
		current_src = $("statusframe").getAttribute("src") || "";
		if(current_src.indexOf("/device-map/router2g.asp") >= 0 || current_src.indexOf("/device-map/router.asp") >= 0)
			;
		else if(support_2g_radio())
			$("statusframe").src = "/device-map/router2g.asp";
		else if(support_5g_radio())
			$("statusframe").src = "/device-map/router.asp";
		else
			$("statusframe").src = "/device-map/router_status.asp";
	}
		else if(obj.id.indexOf("Client") > 0){
			return;
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
	activate_map_card(obj);
	update_map_icon_selection(obj);

	$('helpname').innerHTML = stitle;

	lastClicked = obj;
	lastName = obj.id;
}

function activate_map_card(obj){
	var cardClass = "";

	if(obj.id.indexOf("Internet") > 0)
		cardClass = "mapCard-internet";
	else if(obj.id.indexOf("Router") > 0)
		cardClass = "mapCard-router";

	if(cardClass)
		$j("." + cardClass).addClass("mapNode-active");
	else
		$j(obj).closest(".mapNode").addClass("mapNode-active");
}

function update_map_icon_selection(obj){
	if(lastClicked && lastClicked != obj)
		reset_map_icon(lastClicked);

	if(obj.id.indexOf("Internet") > 0 || obj.id.indexOf("Router") > 0 || obj.id.indexOf("Client") > 0)
		obj.style.backgroundPosition = "0% 100%";
	else if(obj.id.indexOf("USBdisk") > 0 || obj.id.indexOf("Printer") > 0 || obj.id.indexOf("Modem") > 0 || obj.id.indexOf("Hub") > 0 || obj.id.indexOf("SATA") > 0 || obj.id.indexOf("Card") > 0)
		obj.style.backgroundPosition = "0% 100%";
}

function reset_map_icon(obj){
	if(!obj || !obj.id)
		return;

	if(obj.id.indexOf("Internet") > 0 || obj.id.indexOf("Router") > 0 || obj.id.indexOf("Client") > 0)
		obj.style.backgroundPosition = "0% 0%";
	else if(obj.id.indexOf("USBdisk") > 0 || obj.id.indexOf("Printer") > 0 || obj.id.indexOf("Modem") > 0 || obj.id.indexOf("Hub") > 0 || obj.id.indexOf("SATA") > 0 || obj.id.indexOf("Card") > 0)
		obj.style.backgroundPosition = "0% 0%";
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
                <div id="NM_shift"></div>
                <div id="NM_table" class="NM_table">
                    <div id="NM_table_div">
                        <div style="width:50%;float:left;">
                            <table id="_NM_table" border="0" cellpadding="0" cellspacing="0" height="720" style="opacity:.95;">
                                <tr>
                                    <td width="40" rowspan="11" valign="center"></td>
                                    <td id="single_wan_icon" align="right" class="NM_radius_left mapNode mapCard-internet" valign="middle" bgcolor="#444f53" onclick="clickEvent($('iconInternet'));">
                                        <a id="linkInternet" href="/device-map/internet.asp" target="statusframe" style="outline:0;"><div id="iconInternet" onclick="clickEvent(this);"></div></a>
                                    </td>
                                    <td id="single_wan_status" colspan="2" valign="middle" bgcolor="#444f53" class="NM_radius_right mapNode mapCard-internet mapCardText" style="padding:5px;cursor:pointer;width:180px;height:130px" onclick="clickEvent($('iconInternet'));">
                                        <div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
                                        <div id="NM_connect_title" style="font-size:12px;font-family:Verdana, Arial, Helvetica, sans-serif;"><#statusTitle_Internet#>:</div>
                                        <div id="NM_connect_status" class="index_status mapText-warn" style="font-size:14px;"><#QIS_step2#>...</div>
                                        <div style="margin-top:10px;">
                                            <span style="font-size:12px;font-family:Verdana, Arial, Helvetica, sans-serif;">WAN IP:</span>
                                            <strong id="wanIPStatus" class="index_status mapText-warn" style="font-size:14px;">--</strong>
                                            <div id="internetStatus" class="mapStatus-warn" style="margin-top:5px;"><#QKSet_detect_freshbtn#></div>
                                        </div>
                                        <div id="ddnsHostName_div" style="margin-top:5px;word-break:break-all;word-wrap:break-word;width:180px;display:none;">
                                            <span style="font-size:12px;font-family:Verdana, Arial, Helvetica, sans-serif;">DDNS:</span>
                                            <strong id="ddnsHostName" class="index_status mapText-on" style="font-size:12px;"></strong>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td id="single_wan_line" colspan="3" align="center" height="35">
                                        <div id="single_wan" class="mapLine-warn"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" bgcolor="#444f53" class="NM_radius_left mapNode mapCard-router" onclick="clickEvent($('iconRouter'));" style="height:150px">
                                        <a id="iconRouterLink" href="javascript:void(0);" style="outline:0;"><div id="iconRouter" onclick="clickEvent(this);"></div></a>
                                    </td>
                                    <td colspan="2" valign="middle" bgcolor="#444f53" class="NM_radius_right mapNode mapCard-router mapCardText" onclick="clickEvent($('iconRouter'));">
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
                                    <td id="clients_td" width="150" bgcolor="#444f53" align="center" valign="top" class="NM_radius mapNode mapNode-passive" style="padding-bottom:15px;">
                                        <div id="clientsContainer">
                                            <div id="iconClient" style="margin:20px auto 0 auto;"></div>
                                            <div class="clients" id="clientNumber"></div>
                                            <input type="button" id="clientListButton" class="button_gen nmClientListButton" value="浏览名单" onclick="showClientlistModal(); return false;">
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
                                            <iframe id="statusframe" class="NM_radius_bottom" name="statusframe" src="/device-map/router_status.asp" frameborder="0"></iframe>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
	                        <br style="clear:both;">
	                    </div>
	                    <div id="clientListViewMask" onclick="hideClientlistModal();"></div>
	                    <div id="clientListViewPanel" class="clientlist_viewlist" onclick="event.cancelBubble=true; if(event.stopPropagation) event.stopPropagation();">
	                    <a class="nmClientListClose" href="javascript:void(0);" onclick="hideClientlistModal(); return false;">×</a>
	                    <div class="nmClientTabs">
	                        <div id="clientListTabAll" class="nmClientTab active" onclick="changeClientListViewMode('All');"><span>全部</span></div>
	                        <div id="clientListTabInterface" class="nmClientTab" onclick="changeClientListViewMode('ByInterface');"><span>接口</span></div>
	                    </div>
	                    <table width="100%" cellspacing="0" cellpadding="0" align="center" class="nmClientListTable">
	                        <thead>
	                            <tr>
	                                <td id="clientListViewHeader" colspan="9" class="nmClientListHeader">全部列表<a href="javascript:void(0);" onclick="hideClientlistModal(); return false;">[ 隐藏 ]</a></td>
	                            </tr>
	                            <tr>
	                                <th id="clientListThInternet" width="6%">互联网</th>
	                                <th id="clientListThIcon" width="6%">图标</th>
	                                <th id="clientListThName" width="27%">客户端名称</th>
	                                <th id="clientListThIp" width="20%">客户端 IP 地址</th>
	                                <th id="clientListThMac" width="15%">客户端 MAC 地址</th>
	                                <th id="clientListThInterface" width="6%">接口</th>
	                                <th id="clientListThTx" width="6%">Tx 速率<br>(Mbps)</th>
	                                <th id="clientListThRx" width="6%">Rx 速率<br>(Mbps)</th>
	                                <th id="clientListThAccess" width="8%">访问时间</th>
	                            </tr>
	                        </thead>
	                        <tbody id="clientListTableBody"></tbody>
	                    </table>
	                    <div class="nmClientExportBlock">
	                        <input type="button" id="clientListExportButton" class="button_gen nmClientExportButton" value="导出" onclick="exportClientListLog(); return false;">
	                    </div>
	                </div>
	                </div>
	            </td>
            <td width="10" align="center" valign="top">&nbsp;</td>
        </tr>
    </table>

    <div id="footer"></div>
    <script>
	    if(flag == "Internet")
	        $("statusframe").src = "";
    </script>
</body>
</html>
