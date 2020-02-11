<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
		<title>欢迎 - 医院药品库存管理系统</title>
		<meta name="description" content="欢迎 - 医院药品库存管理系统" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="../assets/css/bootstrap.min.css" />
		<link rel="stylesheet" href="../assets/font-awesome/4.5.0/css/font-awesome.min.css" />
		<!-- page specific plugin styles -->
		<!-- text fonts -->
		<link rel="stylesheet" href="../assets/css/fonts.googleapis.com.css" />
		<!-- ace styles -->
		<link rel="stylesheet" href="../assets/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />
		<!--[if lte IE 9]>
			<link rel="stylesheet" href="../assets/css/ace-part2.min.css" class="ace-main-stylesheet" />
		<![endif]-->
		<link rel="stylesheet" href="../assets/css/ace-skins.min.css" />
		<link rel="stylesheet" href="../assets/css/ace-rtl.min.css" />
		<!--[if lte IE 9]>
			<link rel="stylesheet" href="../assets/css/ace-ie.min.css" />
		<![endif]-->
		<!-- inline styles related to this page -->
		<!-- ace settings handler -->
		<script src="../assets/js/ace-extra.min.js"></script>
		<!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->
		<!--[if lte IE 8]>
			<script src="../assets/js/html5shiv.min.js"></script>
			<script src="../assets/js/respond.min.js"></script>
		<![endif]-->
	</head>
	<body class="no-skin">
		<div id="navbar" class="navbar navbar-default ace-save-state">
			<div class="navbar-container ace-save-state" id="navbar-container">
				<button type="button" class="navbar-toggle menu-toggler pull-left" id="menu-toggler" data-target="#sidebar">
					<span class="sr-only">Toggle sidebar</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<div class="navbar-header pull-left">
					<a href="../nurse/index" class="navbar-brand">
						<small>
							<i class="fa fa-leaf"></i>
							医院药品库存管理系统 DIMS
						</small>
					</a>
				</div>
				<div class="navbar-buttons navbar-header pull-right" role="navigation">
					<ul class="nav ace-nav">
						<li class="grey dropdown-modal">
							<a data-toggle="dropdown" class="dropdown-toggle" href="#">
								<i class="ace-icon fa fa-tasks"></i>
								<span class="badge badge-grey">3</span>
							</a>
							<ul class="dropdown-menu-right dropdown-navbar dropdown-menu dropdown-caret dropdown-close">
								<li class="dropdown-header">
									<i class="ace-icon fa fa-check"></i>
									统计信息
								</li>
								<li class="dropdown-content">
									<ul class="dropdown-menu dropdown-navbar">
										<li>
											<a href="../nurse/query-solved-rx-list">
												<div class="clearfix">
													<span class="pull-left">已处理处方数目占比</span>
													<span class="pull-right">
														<fmt:formatNumber value="${solvedRxsNum / (solvedRxsNum + unsolvedRxsNum) * 100}" pattern="#.00"/>
														%
													</span>
												</div>
												<div class="progress progress-mini progress-striped active">
													<div style="width:${solvedRxsNum / (solvedRxsNum + unsolvedRxsNum) * 100}%" class="progress-bar"></div>
												</div>
											</a>
										</li>
										<li>
											<a href="../nurse/query-unsolved-rx-list">
												<div class="clearfix">
													<span class="pull-left">未处理处方数目占比</span>
													<span class="pull-right">
														<fmt:formatNumber value="${unsolvedRxsNum / (solvedRxsNum + unsolvedRxsNum) * 100}" pattern="#.00"/>
														%
													</span>
												</div>
												<div class="progress progress-mini progress-striped active">
													<div style="width:${unsolvedRxsNum / (solvedRxsNum + unsolvedRxsNum) * 100}%" class="progress-bar progress-bar-warning"></div>
												</div>
											</a>
										</li>
										<li>
											<a href="#">
												<div class="clearfix">
													<span class="pull-left">由我处理的处方数目占比</span>
													<span class="pull-right">
														<fmt:formatNumber value="${mySolvedRxsNum / solvedRxsNum * 100}" pattern="#.00"/>
														%
													</span>
												</div>
												<div class="progress progress-mini progress-striped active">
													<div style="width:${mySolvedRxsNum / solvedRxsNum * 100}%" class="progress-bar progress-bar-success"></div>
												</div>
											</a>
										</li>
									</ul>
								</li>
							</ul>
						</li>
						<li class="light-blue dropdown-modal">
							<a data-toggle="dropdown" href="#" class="dropdown-toggle">
								<img class="nav-user-photo" src="../assets/images/avatars/${currentNurse.nsex ? 'Male' : 'Female'}Nurse.png" alt="头像" />
								<span class="user-info">
									<small>欢迎，</small>
									${currentNurse.nname}
								</span>
								<i class="ace-icon fa fa-caret-down"></i>
							</a>
							<ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">
								<li>
									<a href="../nurse/profile">
										<i class="ace-icon fa fa-user"></i>
										个人信息
									</a>
								</li>
								<li class="divider"></li>
								<li>
									<a href="../logout">
										<i class="ace-icon fa fa-power-off"></i>
										登出
									</a>
								</li>
							</ul>
						</li>
					</ul>
				</div>
			</div><!-- /.navbar-container -->
		</div>
		<div class="main-container ace-save-state" id="main-container">
			<script type="text/javascript">
				try{ace.settings.loadState('main-container')}catch(e){}
			</script>
			<div id="sidebar" class="sidebar responsive ace-save-state">
				<script type="text/javascript">
					try{ace.settings.loadState('sidebar')}catch(e){}
				</script>
				<div class="sidebar-shortcuts" id="sidebar-shortcuts">
					<div class="sidebar-shortcuts-large" id="sidebar-shortcuts-large">
						<button class="btn btn-success">
							<i class="ace-icon fa fa-signal"></i>
						</button>
						<button class="btn btn-info">
							<i class="ace-icon fa fa-pencil"></i>
						</button>
						<button class="btn btn-warning">
							<i class="ace-icon fa fa-users"></i>
						</button>
						<button class="btn btn-danger">
							<i class="ace-icon fa fa-cogs"></i>
						</button>
					</div>
					<div class="sidebar-shortcuts-mini" id="sidebar-shortcuts-mini">
						<span class="btn btn-success"></span>
						<span class="btn btn-info"></span>
						<span class="btn btn-warning"></span>
						<span class="btn btn-danger"></span>
					</div>
				</div><!-- /.sidebar-shortcuts -->
				<ul class="nav nav-list">
					<li class="active">
						<a href="../nurse/welcome">
							<i class="menu-icon fa fa-tachometer"></i>
							<span class="menu-text"> 欢迎页面 </span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="">
						<a href="../nurse/profile">
							<i class="menu-icon fa fa-tag"></i>
							<span class="menu-text"> 个人信息页面 </span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="">
						<a href="../nurse/query-drug-list">
							<i class="menu-icon fa fa-list"></i>
							<span class="menu-text"> 查看库存药品列表 </span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="">
						<a href="#" class="dropdown-toggle">
							<i class="menu-icon fa fa-list-alt"></i>
							<span class="menu-text"> 查看处方列表 </span>
							<b class="arrow fa fa-angle-down"></b>
						</a>
						<b class="arrow"></b>
						<ul class="submenu">
							<li class="">
								<a href="../nurse/query-unsolved-rx-list">
									<i class="menu-icon fa fa-caret-right"></i>
									查看未处理处方列表
								</a>
								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="../nurse/query-solved-rx-list">
									<i class="menu-icon fa fa-caret-right"></i>
									查看已处理处方列表
								</a>
								<b class="arrow"></b>
							</li>
						</ul>
					</li>
				</ul><!-- /.nav-list -->
				<div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
					<i id="sidebar-toggle-icon" class="ace-icon fa fa-angle-double-left ace-save-state" data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
				</div>
			</div>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="breadcrumbs ace-save-state" id="breadcrumbs">
						<ul class="breadcrumb">
							<li>
								<i class="ace-icon fa fa-home home-icon"></i>
								<a href="../nurse/index">首页</a>
							</li>
							<li class="active">欢迎页面</li>
						</ul><!-- /.breadcrumb -->
					</div>
					<div class="page-content">
						<div class="page-header">
							<h1>统计信息</h1>
						</div><!-- /.page-header -->
						<c:choose>
							<c:when test="${echo != null}">
								<div class="alert alert-info">
									<button class="close" data-dismiss="alert">
										<i class="ace-icon fa fa-times"></i>
									</button>
									<i class="ace-icon fa fa-hand-o-right"></i>
									${echo}
								</div>
							</c:when>
						</c:choose>
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div class="alert alert-block alert-success">
									<button type="button" class="close" data-dismiss="alert">
										<i class="ace-icon fa fa-times"></i>
									</button>
									<i class="ace-icon fa fa-check green"></i>
									欢迎使用
									<strong class="green">
										医院药品库存管理系统 DIMS (v1.0)
									</strong>
								</div>
								<div class="row">
									<div class="space-6"></div>
									<div class="col-sm-7 infobox-container">
										<div class="infobox infobox-green">
											<div class="infobox-icon">
												<i class="ace-icon fa fa-flask"></i>
											</div>
											<div class="infobox-data">
												<span class="infobox-data-number">${solvedRxsNum}</span>
												<div class="infobox-content">已处理处方数目</div>
											</div>
										</div>
										<div class="infobox infobox-red">
											<div class="infobox-icon">
												<i class="ace-icon fa fa-flask"></i>
											</div>
											<div class="infobox-data">
												<span class="infobox-data-number">${unsolvedRxsNum}</span>
												<div class="infobox-content">未处理处方数目</div>
											</div>
										</div>
										<div class="infobox infobox-blue">
											<div class="infobox-icon">
												<i class="ace-icon fa fa-flask"></i>
											</div>
											<div class="infobox-data">
												<span class="infobox-data-number">${mySolvedRxsNum}</span>
												<div class="infobox-content">由我处理的处方数目</div>
											</div>
										</div>
										<div class="space-6"></div>
										<div class="infobox infobox-green2">
											<div class="infobox-progress">
												<div class="easy-pie-chart percentage" data-percent="${solvedRxsNum / (solvedRxsNum + unsolvedRxsNum) * 100}" data-size="46">
													<span class="percent">
														<fmt:formatNumber value="${solvedRxsNum / (solvedRxsNum + unsolvedRxsNum) * 100}" pattern="#"/>
													</span>%
												</div>
											</div>
											<div class="infobox-data">
												<span class="infobox-text">已处理处方数目</span>
												<div class="infobox-content">
													<span class="bigger-110">~</span>
													占总处方数目比例
												</div>
											</div>
										</div>
										<div class="infobox infobox-red2">
											<div class="infobox-progress">
												<div class="easy-pie-chart percentage" data-percent="${unsolvedRxsNum / (solvedRxsNum + unsolvedRxsNum) * 100}" data-size="46">
													<span class="percent">
														<fmt:formatNumber value="${unsolvedRxsNum / (solvedRxsNum + unsolvedRxsNum) * 100}" pattern="#"/>
													</span>%
												</div>
											</div>
											<div class="infobox-data">
												<span class="infobox-text">未处理处方数目</span>
												<div class="infobox-content">
													<span class="bigger-110">~</span>
													占总处方数目比例
												</div>
											</div>
										</div>
										<div class="infobox infobox-blue2">
											<div class="infobox-progress">
												<div class="easy-pie-chart percentage" data-percent="${mySolvedRxsNum / solvedRxsNum * 100}" data-size="46">
													<span class="percent">
														<fmt:formatNumber value="${mySolvedRxsNum / solvedRxsNum * 100}" pattern="#"/>
													</span>%
												</div>
											</div>
											<div class="infobox-data">
												<span class="infobox-text">由我处理的处方数目</span>
												<div class="infobox-content">
													<span class="bigger-110">~</span>
													占处理处方数目比例
												</div>
											</div>
										</div>
									</div>
								</div><!-- /.row -->
								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
						</div><!-- /.row -->
					</div><!-- /.page-content -->
				</div>
			</div><!-- /.main-content -->
			<div class="footer">
				<div class="footer-inner">
					<div class="footer-content">
						<span class="bigger-120">
							<span class="blue bolder">医院药品库存管理系统</span>
							DIMS &copy; 2019-2020
						</span>
					</div>
				</div>
			</div>
			<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
				<i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
			</a>
		</div><!-- /.main-container -->
		<!-- basic scripts -->
		<!--[if !IE]> -->
			<script src="../assets/js/jquery-2.1.4.min.js"></script>
		<!-- <![endif]-->
		<!--[if IE]>
			<script src="../assets/js/jquery-1.11.3.min.js"></script>
		<![endif]-->
		<script type="text/javascript">
			if('ontouchstart' in document.documentElement) document.write("<script src='../assets/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>
		<script src="../assets/js/bootstrap.min.js"></script>
		<!-- page specific plugin scripts -->
		<!--[if lte IE 8]>
			<script src="../assets/js/excanvas.min.js"></script>
		<![endif]-->
		<script src="../assets/js/jquery-ui.custom.min.js"></script>
		<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
		<script src="../assets/js/jquery.easypiechart.min.js"></script>
		<script src="../assets/js/jquery.sparkline.index.min.js"></script>
		<script src="../assets/js/jquery.flot.min.js"></script>
		<script src="../assets/js/jquery.flot.pie.min.js"></script>
		<script src="../assets/js/jquery.flot.resize.min.js"></script>
		<!-- ace scripts -->
		<script src="../assets/js/ace-elements.min.js"></script>
		<script src="../assets/js/ace.min.js"></script>
		<!-- inline scripts related to this page -->
		<script type="text/javascript">
			jQuery(function($) {
				$('.easy-pie-chart.percentage').each(function(){
					var $box = $(this).closest('.infobox');
					var barColor = $(this).data('color') || (!$box.hasClass('infobox-dark') ? $box.css('color') : 'rgba(255,255,255,0.95)');
					var trackColor = barColor == 'rgba(255,255,255,0.95)' ? 'rgba(255,255,255,0.25)' : '#E2E2E2';
					var size = parseInt($(this).data('size')) || 50;
					$(this).easyPieChart({
						barColor: barColor,
						trackColor: trackColor,
						scaleColor: false,
						lineCap: 'butt',
						lineWidth: parseInt(size/10),
						animate: ace.vars['old_ie'] ? false : 1000,
						size: size
					});
				})
				$('.sparkline').each(function(){
					var $box = $(this).closest('.infobox');
					var barColor = !$box.hasClass('infobox-dark') ? $box.css('color') : '#FFF';
					$(this).sparkline('html',
										{
											tagValuesAttribute:'data-values',
											type: 'bar',
											barColor: barColor,
											chartRangeMin:$(this).data('min') || 0
										});
				});
				//flot chart resize plugin, somehow manipulates default browser resize event to optimize it!
				//but sometimes it brings up errors with normal resize event handlers
				$.resize.throttleWindow = false;
				var placeholder = $('#piechart-placeholder').css({'width':'90%', 'min-height':'150px'});
				var data = [
					{ label: "social networks", data: 38.7, color: "#68BC31"},
					{ label: "search engines", data: 24.5, color: "#2091CF"},
					{ label: "ad campaigns", data: 8.2, color: "#AF4E96"},
					{ label: "direct traffic", data: 18.6, color: "#DA5430"},
					{ label: "other", data: 10, color: "#FEE074"}
				]
				function drawPieChart(placeholder, data, position) {
			 		$.plot(placeholder, data, {
						series: {
							pie: {
								show: true,
								tilt:0.8,
								highlight: {
									opacity: 0.25
								},
								stroke: {
									color: '#fff',
									width: 2
								},
								startAngle: 2
							}
						},
						legend: {
							show: true,
							position: position || "ne",
							labelBoxBorderColor: null,
							margin:[-30,15]
						}
						,
						grid: {
							hoverable: true,
							clickable: true
						}
					 })
				}
				drawPieChart(placeholder, data);
				/**
				we saved the drawing function and the data to redraw with different position later when switching to RTL mode dynamically
				so that's not needed actually.
				*/
				placeholder.data('chart', data);
				placeholder.data('draw', drawPieChart);
				//pie chart tooltip example
				var $tooltip = $("<div class='tooltip top in'><div class='tooltip-inner'></div></div>").hide().appendTo('body');
				var previousPoint = null;
				placeholder.on('plothover', function (event, pos, item) {
					if(item) {
						if (previousPoint != item.seriesIndex) {
							previousPoint = item.seriesIndex;
							var tip = item.series['label'] + " : " + item.series['percent']+'%';
							$tooltip.show().children(0).text(tip);
						}
						$tooltip.css({top:pos.pageY + 10, left:pos.pageX + 10});
					} else {
						$tooltip.hide();
						previousPoint = null;
					}
				});
				/////////////////////////////////////
				$(document).one('ajaxloadstart.page', function(e) {
					$tooltip.remove();
				});
				var d1 = [];
				for (var i = 0; i < Math.PI * 2; i += 0.5) {
					d1.push([i, Math.sin(i)]);
				}
				var d2 = [];
				for (var i = 0; i < Math.PI * 2; i += 0.5) {
					d2.push([i, Math.cos(i)]);
				}
				var d3 = [];
				for (var i = 0; i < Math.PI * 2; i += 0.2) {
					d3.push([i, Math.tan(i)]);
				}
				var sales_charts = $('#sales-charts').css({'width':'100%', 'height':'220px'});
				$.plot("#sales-charts", [
					{ label: "Domains", data: d1 },
					{ label: "Hosting", data: d2 },
					{ label: "Services", data: d3 }
				], {
					hoverable: true,
					shadowSize: 0,
					series: {
						lines: { show: true },
						points: { show: true }
					},
					xaxis: {
						tickLength: 0
					},
					yaxis: {
						ticks: 10,
						min: -2,
						max: 2,
						tickDecimals: 3
					},
					grid: {
						backgroundColor: { colors: [ "#fff", "#fff" ] },
						borderWidth: 1,
						borderColor:'#555'
					}
				});
				$('#recent-box [data-rel="tooltip"]').tooltip({placement: tooltip_placement});
				function tooltip_placement(context, source) {
					var $source = $(source);
					var $parent = $source.closest('.tab-content')
					var off1 = $parent.offset();
					var w1 = $parent.width();
					var off2 = $source.offset();
					//var w2 = $source.width();
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) return 'right';
					return 'left';
				}
				$('.dialogs,.comments').ace_scroll({
					size: 300
				});
				//Android's default browser somehow is confused when tapping on label which will lead to dragging the task
				//so disable dragging when clicking on label
				var agent = navigator.userAgent.toLowerCase();
				if(ace.vars['touch'] && ace.vars['android']) {
					$('#tasks').on('touchstart', function(e){
						var li = $(e.target).closest('#tasks li');
						if(li.length == 0) return;
						var label = li.find('label.inline').get(0);
						if(label == e.target || $.contains(label, e.target)) e.stopImmediatePropagation() ;
					});
				}
				$('#tasks').sortable({
					opacity:0.8,
					revert:true,
					forceHelperSize:true,
					placeholder: 'draggable-placeholder',
					forcePlaceholderSize:true,
					tolerance:'pointer',
					stop: function( event, ui ) {
						//just for Chrome!!!! so that dropdowns on items don't appear below other items after being moved
						$(ui.item).css('z-index', 'auto');
					}
				});
				$('#tasks').disableSelection();
				$('#tasks input:checkbox').removeAttr('checked').on('click', function(){
					if(this.checked) $(this).closest('li').addClass('selected');
					else $(this).closest('li').removeClass('selected');
				});
				//show the dropdowns on top or bottom depending on window height and menu position
				$('#task-tab .dropdown-hover').on('mouseenter', function(e) {
					var offset = $(this).offset();
					var $w = $(window)
					if (offset.top > $w.scrollTop() + $w.innerHeight() - 100)
						$(this).addClass('dropup');
					else $(this).removeClass('dropup');
				});
			})
		</script>
	</body>
</html>
