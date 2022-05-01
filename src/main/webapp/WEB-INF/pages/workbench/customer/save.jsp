<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <base
            href="http://${pageContext.request.serverName }:${pageContext.request.serverPort }${pageContext.request.contextPath }/"/>
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/layer/layer.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">
        $(function () {

            $(".mydate").datetimepicker({
                language: 'zh-CN', //语言
                format: 'yyyy-mm-dd',//日期的格式
                minView: 'month', //可以选择的最小视图
                initialDate: new Date(),//初始化显示的日期
                autoclose: true,//设置选择完日期或者时间之后，日否自动关闭日历
                todayBtn: true,//设置是否显示"今天"按钮,默认是false
                clearBtn: true//设置是否显示"清空"按钮，默认是false
            });

            // 查找联系人弹起模态框
            $("#searchCustomerBtn").click(function () {
                $("#textContacts").val("");
                $("#tBody").html("");
                $("#findContacts").modal("show");
            });

            // 搜索联系人的键盘弹起事件
            $("#textContacts").keyup(function () {
                var contactsName = $("#textContacts").val();
                $.ajax({
                    url: "transaction/contacts/query.json",
                    data: {
                        fullname: contactsName
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                        console.log(response);
                        if (response.result == "SUCCESS") {
                            var htmlStr = "";
                            $.each(response.data, function (index, obj) {
                                htmlStr += "<tr >";
                                htmlStr += "<td><input type=\"radio\" name=\"activity\" value=\"" + obj.id + "\" inputText=\"" + obj.fullname + "\"/></td>";
                                htmlStr += "<td>" + obj.fullname + "</td>";
                                htmlStr += "<td>" + obj.email + "</td>";
                                htmlStr += "<td>" + obj.mphone + "</td>";
                                htmlStr += "<tr >";
                            });
                            $("#tBody").append(htmlStr);
                        }
                    }
                });
            });


            $("#tBody").on("click", "input[type=radio]", function () {
                var contactsName = $(this).attr("inputText");
                $("#create-contactsName").val(contactsName);
                $("#contactsId").val(this.value);
            });


            $("#activitySearch").click(function () {
                $("#textActivity").val("");
                $("#activityBody").html("");
                $("#findMarketActivity").modal("show");
            });
            // 搜索市场的键盘弹起事件
            $("#textActivity").keyup(function () {
                var activityName = $("#textActivity").val();
                $.ajax({
                    url: "transaction/activity/query.json",
                    data: {
                        name: activityName
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {

                        if (response.result == "SUCCESS") {
                            var htmlStr = "";
                            $.each(response.data, function (index, obj) {
                                htmlStr += "<tr >";
                                htmlStr += "<td><input type=\"radio\" name=\"activity\" value=\"" + obj.id + "\" inputText=\"" + obj.name + "\"/></td>";
                                htmlStr += "<td>" + obj.name + "</td>";
                                htmlStr += "<td>" + obj.startDate + "</td>";
                                htmlStr += "<td>" + obj.endDate + "</td>";
                                htmlStr += "<td>" + obj.owner + "</td>";
                                htmlStr += "<tr >";
                            });
                            $("#activityBody").append(htmlStr);
                        }
                    }
                });
            });

            $("#activityBody").on("click", "input[type=radio]", function () {
                var activityName = $(this).attr("inputText");
                $("#create-activitySrc").val(activityName);
                $("#activityId").val(this.value);
            });


            //当容器加载完成之后，对容器调用工具函数
            $("#create-accountName").typeahead({
                source: function (jquery, process) {
                    //process：是个函数，能够将['xxx','xxxxx','xxxxxx',.....]字符串赋值给source，从而完成自动补全
                    //jquery：在容器中输入的关键字
                    //var customerName=$("#customerName").val();
                    //发送查询请求
                    $.ajax({
                        url: 'transaction/queryCustomer/auto.json',
                        data: {
                            customerName: jquery
                        },
                        type: 'post',
                        dataType: 'json',
                        success: function (response) {
                            console.log(response);
                            process(response.data);
                        }

                    });

                }

            });

            // 保存交易的点击事件
            $("#saveTran").click(function () {
                // 收集参数
                var owner = $("#create-transactionOwner").val();
                var money = $("#create-amountOfMoney").val();
                var name = $.trim($("#create-transactionName").val());
                var expectedDate = $("#create-expectedClosingDate").val();
                var customerName = $("#create-accountName").val();
                var stage = $("#create-transactionStage").val()
                var type = $("#create-transactionType").val();
                var source = $("#create-clueSource").val();
                var activityId = $("#activityId").val();
                var contactsId = $("#contactsId").val();
                var description = $("#create-describe").val();
                var contactSummary = $("#create-contactSummary").val();
                var nextContactTime = $("#create-nextContactTime").val();
                var customerId = '${customerId}';

                // 表单验证
                if (name == null || name == '' || customerName == '' || expectedDate == '' || stage == '') {
                    layer.msg("*的不能为空");
                    return false;
                }
                $.ajax({
                    url: "transaction/createTran/add.json",
                    data: {
                        owner: owner,
                        money: money,
                        name: name,
                        expectedDate: expectedDate,
                        customerName: customerName,
                        stage: stage,
                        type: type,
                        source: source,
                        activityId: activityId,
                        contactsId: contactsId,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        customerId:customerId

                    },
                    type:"post",
                    dataType: "json",
                    success: function (response) {
                        console.log(response);
                        if(response.result == "SUCCESS"){
                            // 跳转到交易的主页面
                            window.location.href='customer/detail.html?id=${customerId}';
                        }else{
                            layer.msg("系统繁忙请稍后重试O_O");
                        }
                    }
                })


            });


        });
    </script>

</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询" id="textActivity">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="activityBody">
                    <%--                    <tr>--%>
                    <%--                        <td><input type="radio" name="activity"/></td>--%>
                    <%--                        <td>发传单</td>--%>
                    <%--                        <td>2020-10-10</td>--%>
                    <%--                        <td>2020-10-20</td>--%>
                    <%--                        <td>zhangsan</td>--%>
                    <%--                    </tr>--%>
                    <%--                    <tr>--%>
                    <%--                        <td><input type="radio" name="activity"/></td>--%>
                    <%--                        <td>发传单</td>--%>
                    <%--                        <td>2020-10-10</td>--%>
                    <%--                        <td>2020-10-20</td>--%>
                    <%--                        <td>zhangsan</td>--%>
                    <%--                    </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="textContacts" style="width: 300px;"
                                   placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="tBody">
                    <%--							<tr>--%>
                    <%--								<td><input type="radio" name="activity" value=""/></td>--%>
                    <%--								<td>李四</td>--%>
                    <%--								<td>lisi@bjpowernode.com</td>--%>
                    <%--								<td>12345678901</td>--%>
                    <%--							</tr>--%>
                    <%--							<tr>--%>
                    <%--								<td><input type="radio" name="activity"/></td>--%>
                    <%--								<td>李四</td>--%>
                    <%--								<td>lisi@bjpowernode.com</td>--%>
                    <%--								<td>12345678901</td>--%>
                    <%--							</tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveTran">保存</button>
        <button type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <input type="hidden" id="contactsId">
    <input type="hidden" id="activityId">
    <div class="form-group">
        <label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionOwner">
                <c:forEach items="${users}" var="user1">
                    <c:if test="${sessionScope.user.name == user1.name}">
                        <option>${user1.name}</option>
                    </c:if>
                    <c:if test="${sessionScope.user.name != user1.name}">
                        <option>${user1.name}</option>
                    </c:if>
                </c:forEach>

            </select>
        </div>
        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-amountOfMoney">
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionName" class="col-sm-2 control-label">名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-transactionName">
        </div>
        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control mydate" id="create-expectedClosingDate">
        </div>
    </div>

    <div class="form-group">
        <label for="create-accountName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
        </div>
        <label for="create-transactionStage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionStage">
                <option></option>
                <c:forEach items="${stageList}" var="stage">
                    <option>${stage.value}</option>
                </c:forEach>

            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionType">
                <option></option>

                <c:forEach items="${transactionTypeList}" var="tran">
                    <option>${tran.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility">
        </div>
    </div>

    <div class="form-group">
        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-clueSource">
                <option></option>
                <c:forEach items="${sourceList}" var="source">
                    <option>${source.value}</option>
                </c:forEach>

            </select>
        </div>
        <label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a
                href="javascript:void(0);" data-toggle="modal" id="activitySearch"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-activitySrc">
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a
                href="javascript:void(0);" data-toggle="modal" id="searchCustomerBtn"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-contactsName">
        </div>
    </div>

    <div class="form-group">
        <label for="create-describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-describe"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control mydate" id="create-nextContactTime">
        </div>
    </div>

</form>
</body>
</html>