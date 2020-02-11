<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
		<title>个人信息页面 - 医院药品库存管理系统</title>
		<meta name="description" content="个人信息页面 - 医院药品库存管理系统" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="../assets/css/bootstrap.min.css" />
		<link rel="stylesheet" href="../assets/font-awesome/4.5.0/css/font-awesome.min.css" />
		<!-- page specific plugin styles -->
		<link rel="stylesheet" href="../assets/css/jquery-ui.custom.min.css" />
		<link rel="stylesheet" href="../assets/css/jquery.gritter.min.css" />
		<link rel="stylesheet" href="../assets/css/select2.min.css" />
		<link rel="stylesheet" href="../assets/css/bootstrap-datepicker3.min.css" />
		<link rel="stylesheet" href="../assets/css/bootstrap-editable.min.css" />
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
					<a href="../doctor/index" class="navbar-brand">
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
											<a href="../doctor/query-solved-rx-list">
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
											<a href="../doctor/query-unsolved-rx-list">
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
													<span class="pull-left">由我开出的处方数目占比</span>
													<span class="pull-right">
														<fmt:formatNumber value="${myPrescribeRxsNum / (solvedRxsNum + unsolvedRxsNum) * 100}" pattern="#.00"/>
														%
													</span>
												</div>
												<div class="progress progress-mini progress-striped active">
													<div style="width:${myPrescribeRxsNum / (solvedRxsNum + unsolvedRxsNum) * 100}%" class="progress-bar progress-bar-success"></div>
												</div>
											</a>
										</li>
									</ul>
								</li>
							</ul>
						</li>
						<li class="light-blue dropdown-modal">
							<a data-toggle="dropdown" href="#" class="dropdown-toggle">
								<img class="nav-user-photo" src="../assets/images/avatars/${currentDoctor.dsex ? 'Male' : 'Female'}Doctor.png" alt="头像" />
								<span class="user-info">
									<small>欢迎，</small>
									${currentDoctor.dname}
								</span>
								<i class="ace-icon fa fa-caret-down"></i>
							</a>
							<ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">
								<li>
									<a href="../doctor/profile">
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
						<a href="../doctor/welcome">
							<i class="menu-icon fa fa-tachometer"></i>
							<span class="menu-text"> 欢迎页面 </span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="active">
						<a href="../doctor/profile">
							<i class="menu-icon fa fa-tag"></i>
							<span class="menu-text"> 个人信息页面 </span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="">
						<a href="../doctor/query-drug-list">
							<i class="menu-icon fa fa-list"></i>
							<span class="menu-text"> 查看库存药品列表 </span>
						</a>
						<b class="arrow"></b>
					</li>
					<li class="">
						<a href="../doctor/add-rx-form">
							<i class="menu-icon fa fa-pencil-square-o"></i>
							<span class="menu-text"> 填写新建处方表单 </span>
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
								<a href="../doctor/query-unsolved-rx-list">
									<i class="menu-icon fa fa-caret-right"></i>
									查看未处理处方列表
								</a>
								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="../doctor/query-solved-rx-list">
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
								<a href="../doctor/index">首页</a>
							</li>
							<li class="active">个人信息页面</li>
						</ul><!-- /.breadcrumb -->
					</div>
					<div class="page-content">
						<div class="page-header">
							<h1>个人信息</h1>
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
								<div>
									<div id="user-profile-3" class="user-profile row">
										<div class="col-sm-offset-1 col-sm-10">
											<div class="tabbable">
												<ul class="nav nav-tabs padding-16">
													<li class="active">
														<a data-toggle="tab" href="#edit-basic">
															<i class="green ace-icon fa fa-pencil-square-o bigger-125"></i>
															基本信息
														</a>
													</li>
													<li>
														<a data-toggle="tab" href="#edit-password">
															<i class="blue ace-icon fa fa-key bigger-125"></i>
															更改密码
														</a>
													</li>
												</ul>
												<div class="tab-content profile-edit-tab-content">
													<div id="edit-basic" class="tab-pane in active">
														<div class="tabbable">
															<div class="tab-content no-border padding-24">
																<div id="home" class="tab-pane in active">
																	<div class="row">
																		<div class="col-xs-12 col-sm-3 center">
																			<span class="profile-picture">
																				<img class="editable img-responsive" id="avatar" src="../assets/images/avatars/${currentDoctor.dsex ? 'Male' : 'Female'}Doctor.png" alt="头像" />
																			</span>
																		</div><!-- /.col -->
																		<div class="col-xs-12 col-sm-9">
																			<h4 class="blue">
																				<span class="middle">&nbsp; ${currentDoctor.dname}</span>
																				<span class="label label-purple arrowed-in-right">
																					<i class="ace-icon fa fa-circle smaller-80 align-middle"></i>
																					医生
																				</span>
																			</h4>
																			<div class="profile-user-info">
																				<div class="profile-info-row">
																					<div class="profile-info-name"> 编号 </div>
																					<div class="profile-info-value">
																						<span>${currentDoctor.dno}</span>
																					</div>
																				</div>
																				<div class="profile-info-row">
																					<div class="profile-info-name"> 姓名 </div>
																					<div class="profile-info-value">
																						<span>${currentDoctor.dname}</span>
																					</div>
																				</div>
																				<div class="profile-info-row">
																					<div class="profile-info-name"> 性别 </div>
																					<div class="profile-info-value">
																						<span>${currentDoctor.dsex ? '男' : '女'}</span>
																					</div>
																				</div>
																				<div class="profile-info-row">
																					<div class="profile-info-name"> 年龄 </div>
																					<div class="profile-info-value">
																						<span>${currentDoctor.dage}</span>
																					</div>
																				</div>
																			</div>
																		</div><!-- /.col -->
																	</div><!-- /.row -->
																</div><!-- /#home -->
															</div>
														</div>
													</div>
													<div id="edit-password" class="tab-pane">
														<form action="../doctor/changeDpwd" method="post" class="form-horizontal">
															<div class="space-20"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right" for="form-field-pass1">新密码</label>
																<div class="col-sm-9">
																	<input type="password" name="Dpwd1" required="required" id="form-field-pass1" />
																</div>
															</div>
															<div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right" for="form-field-pass2">确认密码</label>
																<div class="col-sm-9">
																	<input type="password" name="Dpwd2" required="required" id="form-field-pass2" />
																</div>
															</div>
															<div class="clearfix form-actions">
																<div class="col-md-offset-3 col-md-9">
																	<button class="btn btn-info" type="submit">
																		<i class="ace-icon fa fa-check bigger-110"></i>
																		保存
																	</button>
																	&nbsp; &nbsp;
																	<button class="btn" type="reset">
																		<i class="ace-icon fa fa-undo bigger-110"></i>
																		重置
																	</button>
																</div>
															</div>
														</form>
													</div>
												</div>
											</div>
										</div><!-- /.span -->
									</div><!-- /.user-profile -->
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
		<!--[if lte IE 8]>
			<script src="../assets/js/excanvas.min.js"></script>
		<![endif]-->
		<script src="../assets/js/jquery-ui.custom.min.js"></script>
		<script src="../assets/js/jquery.ui.touch-punch.min.js"></script>
		<script src="../assets/js/jquery.gritter.min.js"></script>
		<script src="../assets/js/bootbox.js"></script>
		<script src="../assets/js/jquery.easypiechart.min.js"></script>
		<script src="../assets/js/bootstrap-datepicker.min.js"></script>
		<script src="../assets/js/jquery.hotkeys.index.min.js"></script>
		<script src="../assets/js/bootstrap-wysiwyg.min.js"></script>
		<script src="../assets/js/select2.min.js"></script>
		<script src="../assets/js/spinbox.min.js"></script>
		<script src="../assets/js/bootstrap-editable.min.js"></script>
		<script src="../assets/js/ace-editable.min.js"></script>
		<script src="../assets/js/jquery.maskedinput.min.js"></script>
		<!-- ace scripts -->
		<script src="../assets/js/ace-elements.min.js"></script>
		<script src="../assets/js/ace.min.js"></script>
		<!-- inline scripts related to this page -->
		<script type="text/javascript">
			jQuery(function($) {
				//editables on first profile page
				$.fn.editable.defaults.mode = 'inline';
				$.fn.editableform.loading = "<div class='editableform-loading'><i class='ace-icon fa fa-spinner fa-spin fa-2x light-blue'></i></div>";
				$.fn.editableform.buttons = '<button type="submit" class="btn btn-info editable-submit"><i class="ace-icon fa fa-check"></i></button>'+
											'<button type="button" class="btn editable-cancel"><i class="ace-icon fa fa-times"></i></button>';
				//editables
				//text editable
				$('#username')
				.editable({
					type: 'text',
					name: 'username'
				});
				//select2 editable
				var countries = [];
				$.each({ "CA": "Canada", "IN": "India", "NL": "Netherlands", "TR": "Turkey", "US": "United States"}, function(k, v) {
					countries.push({id: k, text: v});
				});
				var cities = [];
				cities["CA"] = [];
				$.each(["Toronto", "Ottawa", "Calgary", "Vancouver"], function(k, v){
					cities["CA"].push({id: v, text: v});
				});
				cities["IN"] = [];
				$.each(["Delhi", "Mumbai", "Bangalore"], function(k, v){
					cities["IN"].push({id: v, text: v});
				});
				cities["NL"] = [];
				$.each(["Amsterdam", "Rotterdam", "The Hague"], function(k, v){
					cities["NL"].push({id: v, text: v});
				});
				cities["TR"] = [];
				$.each(["Ankara", "Istanbul", "Izmir"], function(k, v){
					cities["TR"].push({id: v, text: v});
				});
				cities["US"] = [];
				$.each(["New York", "Miami", "Los Angeles", "Chicago", "Wysconsin"], function(k, v){
					cities["US"].push({id: v, text: v});
				});
				var currentValue = "NL";
				$('#country').editable({
					type: 'select2',
					value : 'NL',
					//onblur:'ignore',
					source: countries,
					select2: {
						'width': 140
					},
					success: function(response, newValue) {
						if(currentValue == newValue) return;
						currentValue = newValue;
						var new_source = (!newValue || newValue == "") ? [] : cities[newValue];
						//the destroy method is causing errors in x-editable v1.4.6+
						//it worked fine in v1.4.5
						/**
						$('#city').editable('destroy').editable({
							type: 'select2',
							source: new_source
						}).editable('setValue', null);
						*/
						//so we remove it altogether and create a new element
						var city = $('#city').removeAttr('id').get(0);
						$(city).clone().attr('id', 'city').text('Select City').editable({
							type: 'select2',
							value : null,
							//onblur:'ignore',
							source: new_source,
							select2: {
								'width': 140
							}
						}).insertAfter(city);//insert it after previous instance
						$(city).remove();//remove previous instance
					}
				});
				$('#city').editable({
					type: 'select2',
					value : 'Amsterdam',
					//onblur:'ignore',
					source: cities[currentValue],
					select2: {
						'width': 140
					}
				});
				//custom date editable
				$('#signup').editable({
					type: 'adate',
					date: {
						//datepicker plugin options
						format: 'yyyy/mm/dd',
						viewformat: 'yyyy/mm/dd',
						weekStart: 1
						//,nativeUI: true//if true and browser support input[type=date], native browser control will be used
						//,format: 'yyyy-mm-dd',
						//viewformat: 'yyyy-mm-dd'
					}
				})
				$('#age').editable({
					type: 'spinner',
					name : 'age',
					spinner : {
						min : 16,
						max : 99,
						step: 1,
						on_sides: true
						//,nativeUI: true//if true and browser support input[type=number], native browser control will be used
					}
				});
				$('#login').editable({
					type: 'slider',
					name : 'login',
					slider : {
						min : 1,
						max: 50,
						width: 100
						//,nativeUI: true//if true and browser support input[type=range], native browser control will be used
					},
					success: function(response, newValue) {
						if(parseInt(newValue) == 1)
							$(this).html(newValue + " hour ago");
						else $(this).html(newValue + " hours ago");
					}
				});
				$('#about').editable({
					mode: 'inline',
					type: 'wysiwyg',
					name : 'about',
					wysiwyg : {
						//css : {'max-width':'300px'}
					},
					success: function(response, newValue) {
					}
				});
				// *** editable avatar *** //
				try {//ie8 throws some harmless exceptions, so let's catch'em
					//first let's add a fake appendChild method for Image element for browsers that have a problem with this
					//because editable plugin calls appendChild, and it causes errors on IE at unpredicted points
					try {
						document.createElement('IMG').appendChild(document.createElement('B'));
					} catch(e) {
						Image.prototype.appendChild = function(el){}
					}
					var last_gritter
					$('#avatar').editable({
						type: 'image',
						name: 'avatar',
						value: null,
						//onblur: 'ignore', //don't reset or hide editable onblur?!
						image: {
							//specify ace file input plugin's options here
							btn_choose: 'Change Avatar',
							droppable: true,
							maxSize: 110000,//~100Kb
							//and a few extra ones here
							name: 'avatar',//put the field name here as well, will be used inside the custom plugin
							on_error : function(error_type) {//on_error function will be called when the selected file has a problem
								if(last_gritter) $.gritter.remove(last_gritter);
								if(error_type == 1) {//file format error
									last_gritter = $.gritter.add({
										title: 'File is not an image!',
										text: 'Please choose a jpg|gif|png image!',
										class_name: 'gritter-error gritter-center'
									});
								} else if(error_type == 2) {//file size rror
									last_gritter = $.gritter.add({
										title: 'File too big!',
										text: 'Image size should not exceed 100Kb!',
										class_name: 'gritter-error gritter-center'
									});
								}
								else {//other error
								}
							},
							on_success : function() {
								$.gritter.removeAll();
							}
						},
						url: function(params) {
							// ***UPDATE AVATAR HERE*** //
							//for a working upload example you can replace the contents of this function with
							//examples/profile-avatar-update.js
							var deferred = new $.Deferred
							var value = $('#avatar').next().find('input[type=hidden]:eq(0)').val();
							if(!value || value.length == 0) {
								deferred.resolve();
								return deferred.promise();
							}
							//dummy upload
							setTimeout(function(){
								if("FileReader" in window) {
									//for browsers that have a thumbnail of selected image
									var thumb = $('#avatar').next().find('img').data('thumb');
									if(thumb) $('#avatar').get(0).src = thumb;
								}
								deferred.resolve({'status':'OK'});
								if(last_gritter) $.gritter.remove(last_gritter);
								last_gritter = $.gritter.add({
									title: 'Avatar Updated!',
									text: 'Uploading to server can be easily implemented. A working example is included with the template.',
									class_name: 'gritter-info gritter-center'
								});
							 }, parseInt(Math.random() * 800 + 800))
							return deferred.promise();
							// ***END OF UPDATE AVATAR HERE*** //
						},
						success: function(response, newValue) {
						}
					})
				}catch(e) {}
				/**
				//let's display edit mode by default?
				var blank_image = true;//somehow you determine if image is initially blank or not, or you just want to display file input at first
				if(blank_image) {
					$('#avatar').editable('show').on('hidden', function(e, reason) {
						if(reason == 'onblur') {
							$('#avatar').editable('show');
							return;
						}
						$('#avatar').off('hidden');
					})
				}
				*/
				//another option is using modals
				$('#avatar2').on('click', function(){
					var modal =
					'<div class="modal fade">\
						<div class="modal-dialog">\
							<div class="modal-content">\
								<div class="modal-header">\
									<button type="button" class="close" data-dismiss="modal">&times;</button>\
									<h4 class="blue">Change Avatar</h4>\
								</div>\
								\
								<form class="no-margin">\
						 			<div class="modal-body">\
										<div class="space-4"></div>\
										<div style="width:75%;margin-left:12%;"><input type="file" name="file-input" /></div>\
						 			</div>\
									\
						 			<div class="modal-footer center">\
										<button type="submit" class="btn btn-sm btn-success"><i class="ace-icon fa fa-check"></i> Submit</button>\
										<button type="button" class="btn btn-sm" data-dismiss="modal"><i class="ace-icon fa fa-times"></i> Cancel</button>\
						 			</div>\
								</form>\
							</div>\
						</div>\
					</div>';
					var modal = $(modal);
					modal.modal("show").on("hidden", function(){
						modal.remove();
					});
					var working = false;
					var form = modal.find('form:eq(0)');
					var file = form.find('input[type=file]').eq(0);
					file.ace_file_input({
						style:'well',
						btn_choose:'Click to choose new avatar',
						btn_change:null,
						no_icon:'ace-icon fa fa-picture-o',
						thumbnail:'small',
						before_remove: function() {
							//don't remove/reset files while being uploaded
							return !working;
						},
						allowExt: ['jpg', 'jpeg', 'png', 'gif'],
						allowMime: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
					});
					form.on('submit', function(){
						if(!file.data('ace_input_files')) return false;
						file.ace_file_input('disable');
						form.find('button').attr('disabled', 'disabled');
						form.find('.modal-body').append("<div class='center'><i class='ace-icon fa fa-spinner fa-spin bigger-150 orange'></i></div>");
						var deferred = new $.Deferred;
						working = true;
						deferred.done(function() {
							form.find('button').removeAttr('disabled');
							form.find('input[type=file]').ace_file_input('enable');
							form.find('.modal-body > :last-child').remove();
							modal.modal("hide");
							var thumb = file.next().find('img').data('thumb');
							if(thumb) $('#avatar2').get(0).src = thumb;
							working = false;
						});
						setTimeout(function(){
							deferred.resolve();
						}, parseInt(Math.random() * 800 + 800));
						return false;
					});
				});
				//////////////////////////////
				$('#profile-feed-1').ace_scroll({
					height: '250px',
					mouseWheelLock: true,
					alwaysVisible : true
				});
				$('a[ data-original-title]').tooltip();
				$('.easy-pie-chart.percentage').each(function(){
				var barColor = $(this).data('color') || '#555';
				var trackColor = '#E2E2E2';
				var size = parseInt($(this).data('size')) || 72;
				$(this).easyPieChart({
					barColor: barColor,
					trackColor: trackColor,
					scaleColor: false,
					lineCap: 'butt',
					lineWidth: parseInt(size/10),
					animate:false,
					size: size
				}).css('color', barColor);
				});
				///////////////////////////////////////////
				//right & left position
				//show the user info on right or left depending on its position
				$('#user-profile-2 .memberdiv').on('mouseenter touchstart', function(){
					var $this = $(this);
					var $parent = $this.closest('.tab-pane');
					var off1 = $parent.offset();
					var w1 = $parent.width();
					var off2 = $this.offset();
					var w2 = $this.width();
					var place = 'left';
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) place = 'right';
					$this.find('.popover').removeClass('right left').addClass(place);
				}).on('click', function(e) {
					e.preventDefault();
				});
				///////////////////////////////////////////
				$('#user-profile-3')
				.find('input[type=file]').ace_file_input({
					style:'well',
					btn_choose:'Change avatar',
					btn_change:null,
					no_icon:'ace-icon fa fa-picture-o',
					thumbnail:'large',
					droppable:true,
					allowExt: ['jpg', 'jpeg', 'png', 'gif'],
					allowMime: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
				})
				.end().find('button[type=reset]').on(ace.click_event, function(){
					$('#user-profile-3 input[type=file]').ace_file_input('reset_input');
				})
				.end().find('.date-picker').datepicker().next().on(ace.click_event, function(){
					$(this).prev().focus();
				})
				$('.input-mask-phone').mask('(999) 999-9999');
				$('#user-profile-3').find('input[type=file]').ace_file_input('show_file_list', [{type: 'image', name: $('#avatar').attr('src')}]);
				////////////////////
				//change profile
				$('[data-toggle="buttons"] .btn').on('click', function(e){
					var target = $(this).find('input[type=radio]');
					var which = parseInt(target.val());
					$('.user-profile').parent().addClass('hide');
					$('#user-profile-'+which).parent().removeClass('hide');
				});
				/////////////////////////////////////
				$(document).one('ajaxloadstart.page', function(e) {
					//in ajax mode, remove remaining elements before leaving page
					try {
						$('.editable').editable('destroy');
					} catch(e) {}
					$('[class*=select2]').remove();
				});
			});
		</script>
	</body>
</html>
