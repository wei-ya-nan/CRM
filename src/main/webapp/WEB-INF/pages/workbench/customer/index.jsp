<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<base
			href="http://${pageContext.request.serverName }:${pageContext.request.serverPort }${pageContext.request.contextPath }/"/>
	<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/layer/layer.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript">

	$(function(){
		$("#updateActivityBtn").click(function () {

			var checkboxList = $("#tBody input[type=checkbox]:checked");
			if (checkboxList.size() == 0) {
				layer.msg("请选择要修改的客户信息O_O");
				return false;
			}
			if (checkboxList.size() > 1) {
				layer.msg("只能选择一个要修改的客户信息O_O");
				return false;
			}
			if (checkboxList.size() == 1) {
				var checkedId = checkboxList[0].value;
				// layer.msg(checkedId);

				$.ajax({
					url: "customer/id/queryOne.json",
					type: "post",
					dataType: "json",
					data: {
						id: checkedId
					},
					success: function (response) {
						// console.log(response);
						window.id = response.data.id;
						$("#edit-customerOwner").val(response.data.owner);
						$("#edit-phone").val(response.data.phone);

						$("#edit-customerName").val(response.data.name);
						$("#edit-website").val(response.data.website);
						$("#edit-describe").val(response.data.description);
						$("#create-contactSummary1").val(response.data.contactSummary);
						$("#create-nextContactTime2").val(response.data.nextContactTime);
						$("#create-address").val(response.data.address);
						// 关闭模态框
						$("#editCustomerModal").modal("show");
					},
					error: function (response) {
						layer.msg("系统繁忙请稍后重试O_O");
					}
				});
			}
		});

		$("#updateActivityCommit").click(function () {

			var id = window.id;
			var owner = $("#edit-customerOwner").val();
			var phone = $("#edit-phone").val();

			var customerName= $("#edit-customerName").val();
			var website = $("#edit-website").val();
			var description = $("#edit-describe").val();
			var contactSummary = $("#create-contactSummary1").val();
			var  nextContactTime = $("#create-nextContactTime2").val();
			var address = $("#create-address").val();

			$("#editActivityModal").modal("show");

			/*layer.msg(id);*/
			$.ajax({
				url: "customer/id/update.json",
				data: "post",
				dataType: "json",
				data: {
					id: id,
					owner:owner,
					phone:phone,
					customerName:customerName,
					website:website,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				success: function (response) {

					if (response.result == "SUCCESS") {
						layer.msg("修改成功O_O");
						$("#editContactsModal").modal("hide");
						queryActivityConditionPage($("#demo_pag1").bs_pagination('getOption', 'currentPage'),
								$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
					}
					if (response.result == "FAILED") {
						layer.msg(response.message);
						return false;
					}
				},
				error: function (response) {
					layer.msg(response.message);
				}
			});


			return false;
		});


		$(".mydate").datetimepicker({
			language: 'zh-CN', //语言
			format: 'yyyy-mm-dd',//日期的格式
			minView: 'month', //可以选择的最小视图
			initialDate: new Date(),//初始化显示的日期
			autoclose: true,//设置选择完日期或者时间之后，日否自动关闭日历
			todayBtn: true,//设置是否显示"今天"按钮,默认是false
			clearBtn: true//设置是否显示"清空"按钮，默认是false
		});


		//给"创建"按钮添加单击事件
		$("#createActivityBtn").click(function () {
			//初始化工作
			//重置表单
			$("#createActivityForm").get(0).reset();

			//弹出创建市场活动的模态窗口
			$("#createCustomerModal").modal("show");
		});

		$("#addActivityModal").click(function () {
			//收集参数
			var owner = $("#create-customerOwner").val();
			var name = $.trim($("#create-customerName").val());
			var website = $("#create-website").val();
			var phone = $("#create-phone").val();
			var description = $("#create-describe").val();
			var contactSummary = $("#create-contactSummary").val()
			var nextContactTime = $("#create-nextContactTime").val();

			if (owner == "") {
				layer.msg("所有者不能为空");
				return false;
			}
			if (name == "") {
				layer.msg("名称不能为空");
				return false;
			}


			$.ajax({
				url: "customer/add.json",
				type: "post",
				dataType: "json",
				data: {
					owner: owner,
					name: name,
					website: website,
					phone :phone,
					contactSummary:contactSummary,
					nextContactTime: nextContactTime,
					description: description
				},
				success: function (response) {
					var result = response.result;
					if (result == "SUCCESS") {
						layer.msg("添加成功！！！");
						queryActivityConditionPage(1, $("#demo_pag1").bs_pagination('getOption',
								'rowsPerPage'));
						$("#createCustomerModal").modal("hide");
						$("#createActivityForm").get(0).reset();
					}
					if (result == "FAILED") {
						layer.msg(response.message);
						return false;
					}
				},
				error: function (response) {
					// console.log(response);
					layer.msg("系统错误，请重新输入！！！");
					$("#createActivityForm").get(0).reset();


				}

			});
		});


		queryActivityConditionPage(1,5);
		$("#checkBoxAll").click(function () {
			$("#tBody input[type=checkbox]").prop("checked", this.checked);
		});

		$("#tBody").on("click", "input[type='checkbox']", function () {
			if ($("#tBody input[type=checkbox]").size() == $("#tBody input[type=checkbox]:checked").size()) {
				$("#checkBoxAll").prop("checked", true);
			} else {
				$("#checkBoxAll").prop("checked", false);
			}
		});
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		$("#queryByLikePage").click(function () {
			//查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
			queryActivityConditionPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
			return false;
		});


		function queryActivityConditionPage(pageNum, PageSize) {
			var keyword = $.trim($("#queryName").val());
			var owner = $.trim($("#queryOwner").val());
			var phone = $("#queryPhone").val();
			var website = $("#queryWebsite").val();
			$.ajax({
				url: "customer/queryCondition/page.json",
				type: "post",
				dataType: "json",
				data: {
					name: keyword,
					owner: owner,
					phone: phone,
					website: website,
					pageNum: pageNum,
					PageSize: PageSize
				},
				success: function (response) {

					window.lastPage = response.data.lastPage;
					if (response.result == "SUCCESS") {
						//显示总条数
						//$("#totalRowsB").text(data.totalRows);
						//显示市场活动的列表
						//遍历activityList，拼接所有行数据
						var htmlStr = "";
						$.each(response.data.list, function (index, obj) {
							htmlStr += "<tr class=\"active\">";
							htmlStr += "<td><input type=\"checkbox\" value=\"" + obj.id + "\"/></td>";
							htmlStr +=
									"<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='customer/detail.html?id=" + obj.id+"';\">" + obj.name + "</a></td>";
							htmlStr += "<td>" + obj.owner + "</td>";
							htmlStr += "<td>" + obj.phone + "</td>";
							htmlStr += "<td>" + obj.website + "</td>";
							htmlStr += "</tr>";
						});
						$("#tBody").html(htmlStr);

						$("#demo_pag1").bs_pagination({
							currentPage: pageNum,
							rowsPerPage: PageSize,
							totalRows: response.data.total,
							totalPages: response.data.pages,// 显示有多少页吗，必填选项
							visiblePageLinks: 5,// 最多显示的的条数
							showGoToPage: true,//是否显示"跳转到"部分,默认true--显示
							showRowsPerPage: true,//是否显示"每页显示条数"部分。默认true--显示
							showRowsInfo: true,//是否显示记录的信息，默认true--显示
							//用户每次切换页号，都自动触发本函数;
							//每次返回切换页号之后的pageNo和pageSize
							onChangePage: function (event, pageObj) { // returns page_num and rows_per_page after a link has clicked
								//js代码
								//alert(pageObj.currentPage);
								//alert(pageObj.rowsPerPage);
								queryActivityConditionPage(pageObj.currentPage, pageObj.rowsPerPage);
							}
						});
					}
				}
			});

		}

		
	});
	
</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createActivityForm">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">
								 <c:forEach items="${users}" var="user">
								  <option>${user.name}</option>
								 </c:forEach>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control mydate" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="addActivityModal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
								  <c:forEach items="${users}" var="user">
									<option>${user.name}</option>
								  </c:forEach>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" id="create-nextContactTime2">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateActivityCommit">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="queryName">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="queryOwner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="queryPhone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" type="text" id="queryWebsite">
				    </div>
				  </div>
				  
				  <button type="submit" class="btn btn-default" id="queryByLikePage">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" id="createActivityBtn"><span
						  class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" id="updateActivityBtn"><span
						  class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkBoxAll"/></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="tBody">
<%--					<c:forEach items="${customers}" var="customer">--%>
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;"--%>
<%--								   onclick="window.location.href='customer/detail.html';">${customer.name}</a></td>--%>
<%--							<td>${customer.owner}</td>--%>
<%--							<td>${customer.phone}</td>--%>
<%--							<td>${customer.website}</td>--%>
<%--						</tr>--%>
<%--					</c:forEach>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>010-84846003</td>--%>
<%--                            <td>http://www.bjpowernode.com</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="demo_pag1"></div>
			</div>
			

			
		</div>
		
	</div>
</body>
</html>