<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_title#></title>
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
var map_code = "";

function initial(){
	show_banner(0);
	show_menu(7,0,0);
	show_footer();
	show_sitemap();
}

function show_sitemap(){
	var l1 = tabtitle.length;
	var l2 = menuL2_title.length;

	if (l1 > 8) l1 = 8;
	if (l2 > 8) l2 = 8;

	for(var i=0, j=0; i<l1, j<l2;){
		if(tabtitle[i] == ""){
			tabtitle.splice(i,1);
			tablink.splice(i,1);
		}
		else
			i++;
		if(menuL2_title[j] == "")
			menuL2_title.splice(j,1);
		else
			j++;
	}

	l2 = menuL2_title.length;
	if (l2 > 8) l2 = 8;

	for(var i=0; i<l2; i++){
		var k = (i/4 < 1)?0:3;
		$("menu_body").rows[k].cells[i%4].innerHTML = "<b>" + menuL2_title[i] + "</b>";
		$("menu_body").rows[k].cells[i%4].className = "head";
	}

	l1 = tabtitle.length;
	if (l1 > 8) l1 = 8;

	for(var l = 0; l < l1; l++){
		map_code = '<ul class="sitemap_list">\n';
		for(var m = 1; m < tabtitle[l].length; m++){
			if(tablink[l][m] == "")
				continue;
			
			map_code += '    <li>\n';
			map_code += '        <a href="'+tablink[l][m]+'">'
			map_code += tabtitle[l][m];
			map_code += '</a>\n    </li>\n';
		}
		map_code += '</ul>\n';
		
		var n = (l/4 < 1)?0:3;
		$("menu_body").rows[n+2].cells[l%4].innerHTML = map_code;
	}
}
</script>

<style>
    table#menu_body tr td.head {
        text-align: center;
        color: #FFFFFF;
        font-weight: bold;
        background: #596e74;
    }
    table#menu_body tr td {
        vertical-align: top;
        background: #475a5f;
    }
    .sitemap_list {
        margin: 8px 0 0 0;
        padding: 0;
        list-style: none;
    }
    .sitemap_list li {
        padding: 4px 0;
    }
    .sitemap_list a {
        color: #FFFFFF;
        text-decoration: none;
    }
    .sitemap_list a:hover {
        color: #FFCC00;
    }
</style>

</head>

<body onload="initial();" onunload="return unload_body();" class="bg">
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
                                            <div class="formfonttitle"><#menu5_title#></div>
                                            <div style="margin:10px 0 10px 5px;" class="splitLine"></div>
                                            <table id="menu_body" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable sitemap">
                                                    <tr>
                                                        <td width="25%">&nbsp;</td>
                                                        <td width="25%">&nbsp;</td>
                                                        <td width="25%">&nbsp;</td>
                                                        <td width="25%">&nbsp;</td>
                                                    </tr>

                                                    <tr style="display: none;">
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                    </tr>

                                                    <tr valign="top">
                                                        <td height="120"></td>
                                                        <td height="120"></td>
                                                        <td height="120"></td>
                                                        <td height="120"></td>
                                                    </tr>

                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                    </tr>

                                                    <tr style="display: none;">
                                                        <td width="25%">&nbsp;</td>
                                                        <td width="25%">&nbsp;</td>
                                                        <td width="25%">&nbsp;</td>
                                                        <td width="25%">&nbsp;</td>
                                                    </tr>

                                                    <tr valign="top">
                                                        <td height="120"></td>
                                                        <td height="120"></td>
                                                        <td height="120"></td>
                                                        <td height="120"></td>
                                                    </tr>
                                            </table>
                                        </div>
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
