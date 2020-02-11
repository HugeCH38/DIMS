<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
		<title>查看库存紧张的药品列表 - 医院药品库存管理系统</title>
		<meta name="description" content="查看库存紧张的药品列表 - 医院药品库存管理系统" />
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
					<a href="../admin/index" class="navbar-brand">
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
											<a href="../admin/query-specific-admin?Ano=${currentAdmin.ano}">
												<div class="clearfix">
													<span class="pull-left">由我入库的药品总批数占比</span>
													<span class="pull-right">
														<fmt:formatNumber value="${myPDbatchesNum / (inventoryPDbatchesNum + destroyedPDbatchesNum) * 100}" pattern="#.00"/>
														%
													</span>
												</div>
												<div class="progress progress-mini progress-striped active">
													<div style="width:${myPDbatchesNum / (inventoryPDbatchesNum + destroyedPDbatchesNum) * 100}%" class="progress-bar"></div>
												</div>
											</a>
										</li>
										<li>
											<a href="../admin/query-specific-admin?Ano=${currentAdmin.ano}">
												<div class="clearfix">
													<span class="pull-left">由我入库的库存药品批数占比</span>
													<span class="pull-right">
														<fmt:formatNumber value="${myInventoryPDbatchesNum / inventoryPDbatchesNum * 100}" pattern="#.00"/>
														%
													</span>
												</div>
												<div class="progress progress-mini progress-striped active">
													<div style="width:${myInventoryPDbatchesNum / inventoryPDbatchesNum * 100}%" class="progress-bar progress-bar-warning"></div>
												</div>
											</a>
										</li>
										<li>
											<a href="../admin/query-specific-admin?Ano=${currentAdmin.ano}">
												<div class="clearfix">
													<span class="pull-left">由我销毁的药品批数占比</span>
													<span class="pull-right">
														<fmt:formatNumber value="${myDestroyedPDbatchesNum / destroyedPDbatchesNum * 100}" pattern="#.00"/>
														%
													</span>
												</div>
												<div class="progress progress-mini progress-striped active">
													<div style="width:${myDestroyedPDbatchesNum / destroyedPDbatchesNum * 100}%" class="progress-bar progress-bar-success"></div>
												</div>
											</a>
										</li>
									</ul>
								</li>
							</ul>
						</li>
						<li class="green dropdown-modal">
							<a data-toggle="dropdown" class="dropdown-toggle" href="#">
								<i class="ace-icon fa fa-bell icon-animated-bell"></i>
								<span class="badge badge-success">${lowInventoryDrugsNum + close2ExpiryPDbatchesNum}</span>
							</a>
							<ul class="dropdown-menu-right dropdown-navbar dropdown-menu dropdown-caret dropdown-close">
								<li class="dropdown-header">
									<i class="ace-icon fa fa-exclamation-triangle"></i>
									警报
								</li>
								<li class="dropdown-content">
									<ul class="dropdown-menu dropdown-navbar navbar-pink">
										<li>
											<a href="../admin/query-low-inventory-drug-list">
												<div class="clearfix">
													<span class="pull-left">
														<i class="btn btn-xs no-hover btn-pink fa fa-comment"></i>
														库存药品数量到达下限警报
													</span>
													<span class="pull-right badge badge-info">${lowInventoryDrugsNum}</span>
												</div>
											</a>
										</li>
										<li>
											<a href="../admin/query-close-2-expiry-pdbatch-list">
												<div class="clearfix">
													<span class="pull-left">
														<i class="btn btn-xs no-hover btn-success fa fa-shopping-cart"></i>
														库存药品批次临期警报
													</span>
													<span class="pull-right badge badge-success">${close2ExpiryPDbatchesNum}</span>
												</div>
											</a>
										</li>
									</ul>
								</li>
							</ul>
						</li>
						<li class="light-blue dropdown-modal">
							<a data-toggle="dropdown" href="#" class="dropdown-toggle">
								<img class="nav-user-photo" src="../assets/images/avatars/Admin.png" alt="头像" />
								<span class="user-info">
									<small>欢迎，</small>
									${currentAdmin.aname}
								</span>
								<i class="ace-icon fa fa-caret-down"></i>
							</a>
							<ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">
								<li>
									<a href="../admin/profile">
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
					<li class="">
						<a href="../admin/welcome">
							<i class="menu-icon fa fa-tachometer"></i>
							<span class="menu-text"> 欢迎页面 </span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="">
						<a href="../admin/profile">
							<i class="menu-icon fa fa-tag"></i>
							<span class="menu-text"> 个人信息页面 </span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="">
						<a href="../admin/query-supplier-list">
							<i class="menu-icon fa fa-briefcase"></i>
							<span class="menu-text"> 查看供应商信息列表 </span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="">
						<a href="../admin/add-supplier-form">
							<i class="menu-icon fa fa-desktop"></i>
							<span class="menu-text"> 填写新增供应商表单 </span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="active">
						<a href="../admin/query-low-inventory-drug-list">
							<i class="menu-icon fa fa-cogs"></i>
							<span class="menu-text"> 查看库存紧张的药品 </span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="">
						<a href="../admin/query-close-2-expiry-pdbatch-list">
							<i class="menu-icon fa fa-exclamation-circle"></i>
							<span class="menu-text"> 查看临期的药品批次 </span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="">
						<a href="#" class="dropdown-toggle">
							<i class="menu-icon fa fa-list"></i>
							<span class="menu-text"> 查看药品库存信息 </span>
							<b class="arrow fa fa-angle-down"></b>
						</a>
						<b class="arrow"></b>
						<ul class="submenu">
							<li class="">
								<a href="../admin/query-drug-list">
									<i class="menu-icon fa fa-caret-right"></i>
									查看库存药品列表
								</a>
								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="../admin/query-pdbatch-list">
									<i class="menu-icon fa fa-caret-right"></i>
									查看库存药品批次明细
								</a>
								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="../admin/query-destroyed-pdbatch-list">
									<i class="menu-icon fa fa-caret-right"></i>
									查看已销毁药品批次列表
								</a>
								<b class="arrow"></b>
							</li>
						</ul>
					</li>
					<li class="">
						<a href="../admin/add-storage-form">
							<i class="menu-icon fa fa-pencil-square-o"></i>
							<span class="menu-text"> 填写药品入库表单 </span>
						</a>
						<b class="arrow"></b>
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
								<a href="../admin/index">首页</a>
							</li>
							<li class="active">查看库存紧张的药品列表</li>
						</ul><!-- /.breadcrumb -->
					</div>
					<div class="page-content">
						<div class="page-header">
							<h1>
								查看库存紧张的药品列表
								<small>
									<i class="ace-icon fa fa-angle-double-right"></i>
									库存紧张的药品列表
								</small>
							</h1>
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
						<a href="../admin/add-storage-form" role="button" class="green" data-toggle="modal">
							<button class="btn btn-sm btn-primary">
								<i class="ace-icon fa fa-pencil-square-o bigger-110"></i>
								添加药品批次入库记录
								<i class="ace-icon fa fa-arrow-right icon-on-right"></i>
							</button>
						</a>
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div class="row">
									<div class="col-xs-12">
										<div class="clearfix">
											<div class="pull-right tableTools-container"></div>
										</div>
										<div class="table-header">
											查询结果
										</div>
										<!-- div.table-responsive -->
										<!-- div.dataTables_borderWrap -->
										<div>
											<table id="dynamic-table" class="table table-striped table-bordered table-hover">
												<thead>
													<tr>
														<th>药品编号</th>
														<th>药品名称</th>
														<th>药品保质期 (天数)</th>
														<th>药品数量</th>
														<th>操作</th>
													</tr>
												</thead>
												<tbody>
													<c:forEach items="${drugs}" var="drug">
														<tr>
															<td>
																<a href="../admin/query-specific-drug?PDno=${drug.PDno}" title="查看该药品的库存明细">${drug.PDno}</a>
															</td>
															<td>
																<a href="../admin/query-specific-drug?PDno=${drug.PDno}" title="查看该药品的库存明细">${drug.PDname}</a>
															</td>
															<td>${drug.PDlife}</td>
															<td>${drug.PDnum}</td>
															<td>
																<div class="hidden-sm hidden-xs action-buttons">
																	<a class="blue" href="../admin/query-specific-drug?PDno=${drug.PDno}" title="查看该药品的库存明细">
																		<i class="ace-icon fa fa-search-plus bigger-130"></i>
																	</a>
																	<a class="green" href="../admin/specific-storage-form?PDno=${drug.PDno}" title="入库一批该药品">
																		<i class="ace-icon fa fa-pencil bigger-130"></i>
																	</a>
																</div>
																<div class="hidden-md hidden-lg">
																	<div class="inline pos-rel">
																		<button class="btn btn-minier btn-yellow dropdown-toggle" data-toggle="dropdown" data-position="auto">
																			<i class="ace-icon fa fa-caret-down icon-only bigger-120"></i>
																		</button>
																		<ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
																			<li>
																				<a href="../admin/query-specific-drug?PDno=${drug.PDno}" class="tooltip-info" data-rel="tooltip" title="查看该药品的库存明细">
																					<span class="blue">
																						<i class="ace-icon fa fa-search-plus bigger-120"></i>
																					</span>
																				</a>
																			</li>
																			<li>
																				<a href="../admin/specific-storage-form?PDno=${drug.PDno}" class="tooltip-success" data-rel="tooltip" title="入库一批该药品">
																					<span class="green">
																						<i class="ace-icon fa fa-pencil-square-o bigger-120"></i>
																					</span>
																				</a>
																			</li>
																		</ul>
																	</div>
																</div>
															</td>
														</tr>
													</c:forEach>
												</tbody>
											</table>
										</div>
									</div>
								</div>
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
		<script src="../assets/js/jquery.dataTables.min.js"></script>
		<script src="../assets/js/jquery.dataTables.bootstrap.min.js"></script>
		<script src="../assets/js/dataTables.buttons.min.js"></script>
		<script src="../assets/js/buttons.flash.min.js"></script>
		<script src="../assets/js/buttons.html5.min.js"></script>
		<script src="../assets/js/buttons.print.min.js"></script>
		<script src="../assets/js/buttons.colVis.min.js"></script>
		<script src="../assets/js/dataTables.select.min.js"></script>
		<!-- ace scripts -->
		<script src="../assets/js/ace-elements.min.js"></script>
		<script src="../assets/js/ace.min.js"></script>
		<!-- inline scripts related to this page -->
		<script type="text/javascript">
			jQuery(function($) {
				//initiate dataTables plugin
				var myTable =
				$('#dynamic-table')
				//.wrap("<div class='dataTables_borderWrap' />") //if you are applying horizontal scrolling (sScrollX)
				.DataTable( {
					bAutoWidth: false,
					"aoColumns": [
						null, null, null, null, { "bSortable": false }
					],
					"aaSorting": [],
					"iDisplayLength": 5,
					"aLengthMenu": [
						[5, 10, 15, 20, 25, 30, 35, 40, 45, 50, -1],
						["5 条", "10 条", "15 条", "20 条", "25 条", "30 条", "35 条", "40 条", "45 条", "50 条", "全部"]
					],
					"oLanguage": { // 自定义提示信息
						"sLengthMenu": "每页显示 _MENU_ 记录",
						"sZeroRecords": "抱歉，没有找到",
						"sInfo": "从 _START_ 到 _END_ / 共 _TOTAL_ 条数据 ",
						"sInfoEmpty": "没有数据",
						"sInfoFiltered": "(从 _MAX_ 条数据中检索) ",
						"sSearch": "检索",
						"oPaginate": {
							"sFirst": "首页",
							"sPrevious": "前一页",
							"sNext": "后一页",
							"sLast": "尾页"
						}
					}
					//"bProcessing": true,
					//"bServerSide": true,
					//"sAjaxSource": "http://127.0.0.1/table.php"	,
					//,
					//"sScrollY": "200px",
					//"bPaginate": false,
					//"sScrollX": "100%",
					//"sScrollXInner": "120%",
					//"bScrollCollapse": true,
					//Note: if you are applying horizontal scrolling (sScrollX) on a ".table-bordered"
					//you may want to wrap the table inside a "div.dataTables_borderWrap" element
					//"iDisplayLength": 50
				} );
				$.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';
				new $.fn.dataTable.Buttons( myTable, {
					buttons: [
						{
							"extend": "colvis",
							"text": "<i class='fa fa-search bigger-110 blue'></i> <span class='hidden'>显示/隐藏列</span>",
							"className": "btn btn-white btn-primary btn-bold",
							columns: ':not(:first):not(:last)'
						},
						{
							"extend": "copy",
							"text": "<i class='fa fa-copy bigger-110 pink'></i> <span class='hidden'>复制到剪贴板</span>",
							"className": "btn btn-white btn-primary btn-bold"
						},
						{
							"extend": "csv",
							"text": "<i class='fa fa-database bigger-110 orange'></i> <span class='hidden'>导出到 CSV 文件</span>",
							"className": "btn btn-white btn-primary btn-bold"
						},
						/* {
							"extend": "excel",
							"text": "<i class='fa fa-file-excel-o bigger-110 green'></i> <span class='hidden'>导出到 Excel 文件</span>",
							"className": "btn btn-white btn-primary btn-bold"
						},
						{
							"extend": "pdf",
							"text": "<i class='fa fa-file-pdf-o bigger-110 red'></i> <span class='hidden'>导出到 PDF 文件</span>",
							"className": "btn btn-white btn-primary btn-bold"
						}, */
						{
							"extend": "print",
							"text": "<i class='fa fa-print bigger-110 grey'></i> <span class='hidden'>打印</span>",
							"className": "btn btn-white btn-primary btn-bold",
							autoPrint: false
						}
					]
				} );
				myTable.buttons().container().appendTo( $('.tableTools-container') );
				//style the message box
				var defaultCopyAction = myTable.button(1).action();
				myTable.button(1).action(function (e, dt, button, config) {
					defaultCopyAction(e, dt, button, config);
					$('.dt-button-info').addClass('gritter-item-wrapper gritter-info gritter-center white');
				});
				var defaultColvisAction = myTable.button(0).action();
				myTable.button(0).action(function (e, dt, button, config) {
					defaultColvisAction(e, dt, button, config);
					if($('.dt-button-collection > .dropdown-menu').length == 0) {
						$('.dt-button-collection')
						.wrapInner('<ul class="dropdown-menu dropdown-light dropdown-caret dropdown-caret" />')
						.find('a').attr('href', '#').wrap("<li />")
					}
					$('.dt-button-collection').appendTo('.tableTools-container .dt-buttons')
				});
				////
				setTimeout(function() {
					$($('.tableTools-container')).find('a.dt-button').each(function() {
						var div = $(this).find(' > div').first();
						if(div.length == 1) div.tooltip({container: 'body', title: div.parent().text()});
						else $(this).tooltip({container: 'body', title: $(this).text()});
					});
				}, 500);
				myTable.on( 'select', function ( e, dt, type, index ) {
					if ( type === 'row' ) {
						$( myTable.row( index ).node() ).find('input:checkbox').prop('checked', true);
					}
				} );
				myTable.on( 'deselect', function ( e, dt, type, index ) {
					if ( type === 'row' ) {
						$( myTable.row( index ).node() ).find('input:checkbox').prop('checked', false);
					}
				} );
				/////////////////////////////////
				//table checkboxes
				$('th input[type=checkbox], td input[type=checkbox]').prop('checked', false);
				//select/deselect all rows according to table header checkbox
				$('#dynamic-table > thead > tr > th input[type=checkbox], #dynamic-table_wrapper input[type=checkbox]').eq(0).on('click', function(){
					var th_checked = this.checked;//checkbox inside "TH" table header
					$('#dynamic-table').find('tbody > tr').each(function(){
						var row = this;
						if(th_checked) myTable.row(row).select();
						else myTable.row(row).deselect();
					});
				});
				//select/deselect a row when the checkbox is checked/unchecked
				$('#dynamic-table').on('click', 'td input[type=checkbox]', function(){
					var row = $(this).closest('tr').get(0);
					if(this.checked) myTable.row(row).deselect();
					else myTable.row(row).select();
				});
				$(document).on('click', '#dynamic-table .dropdown-toggle', function(e) {
					e.stopImmediatePropagation();
					e.stopPropagation();
					e.preventDefault();
				});
				//And for the first simple table, which doesn't have TableTools or dataTables
				//select/deselect all rows according to table header checkbox
				var active_class = 'active';
				$('#simple-table > thead > tr > th input[type=checkbox]').eq(0).on('click', function(){
					var th_checked = this.checked;//checkbox inside "TH" table header
					$(this).closest('table').find('tbody > tr').each(function(){
						var row = this;
						if(th_checked) $(row).addClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', true);
						else $(row).removeClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', false);
					});
				});
				//select/deselect a row when the checkbox is checked/unchecked
				$('#simple-table').on('click', 'td input[type=checkbox]', function(){
					var $row = $(this).closest('tr');
					if($row.is('.detail-row ')) return;
					if(this.checked) $row.addClass(active_class);
					else $row.removeClass(active_class);
				});
				/********************************/
				//add tooltip for small view action buttons in dropdown menu
				$('[data-rel="tooltip"]').tooltip({placement: tooltip_placement});
				//tooltip placement on right or left
				function tooltip_placement(context, source) {
					var $source = $(source);
					var $parent = $source.closest('table')
					var off1 = $parent.offset();
					var w1 = $parent.width();
					var off2 = $source.offset();
					//var w2 = $source.width();
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) return 'right';
					return 'left';
				}
				/***************/
				$('.show-details-btn').on('click', function(e) {
					e.preventDefault();
					$(this).closest('tr').next().toggleClass('open');
					$(this).find(ace.vars['.icon']).toggleClass('fa-angle-double-down').toggleClass('fa-angle-double-up');
				});
				/***************/
				/**
				//add horizontal scrollbars to a simple table
				$('#simple-table').css({'width':'2000px', 'max-width': 'none'}).wrap('<div style="width: 1000px;" />').parent().ace_scroll(
					{
						horizontal: true,
						styleClass: 'scroll-top scroll-dark scroll-visible',//show the scrollbars on top(default is bottom)
						size: 2000,
						mouseWheelLock: true
					}
				).css('padding-top', '12px');
				*/
			})
		</script>
	</body>
</html>
