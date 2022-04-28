<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <base
            href="http://${pageContext.request.serverName }:${pageContext.request.serverPort }${pageContext.request.contextPath }/"/>
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/layer/layer.js"></script>

    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">
        $(function () {
            $("#isCreateTransaction").click(function () {
                if (this.checked) {
                    $("#create-transaction2").show(200);
                } else {
                    $("#create-transaction2").hide(200);
                }
            });

            $("#searchActivityBtn").click(function () {
                $("#searchActivity").val("");
                $("#tBody").html("");
                $("#searchActivityModal").modal("show");
            });

            $("#searchActivity").keyup(function () {
                var activityName = this.value;
                var clueId = '${clue.id}';
                $.ajax({
                    url: "clue/query/convert.json",
                    data: {
                        activityName: activityName,
                        clueId: clueId
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {

                        if (response.result == "SUCCESS") {
                            var htmlStr = "";

                            $.each(response.data, function (index, obj) {
                                htmlStr += "<tr>";
                                htmlStr += "<td><input type=\"radio\" value=\"" + obj.id + "\" activityName=\"" + obj.name + "\" name=\"activity\"/></td>";
                                htmlStr += "<td>" + obj.name + "</td>";
                                htmlStr += "<td>" + obj.startDate + "</td>";
                                htmlStr += "<td>" + obj.endDate + "</td>";
                                htmlStr += "<td>" + obj.owner + "</td>";
                                htmlStr += "</tr>";
                            });
                            $("#tBody").html(htmlStr);
                        }
                    }

                });
            });

            //给所有市场活动的单选按钮添加单击事件
            $("#tBody").on("click", "input[type=radio]", function () {
                var activityName = $(this).attr("activityName");
                $("#activityId").val(this.value);
                $("#activity").val(activityName);
            });
            // 给转换添加点击事件
            $("#saveConvertClueBtn").click(function () {
                // 收集参数
			    var clueId = '${clue.id}';
			    var activityId = $("#activityId").val();
			    var money = $.trim($("#amountOfMoney").val());
			    var name = $("#tradeName").val();// 交易的名字
                var expectedDate = $("#expectedClosingDate").val();
                var stage = $("#stage").val();
                var isCreateTransaction = $("#isCreateTransaction").prop("checked");

                if(name==''||stage == '' || expectedDate=='' ){
                    layer.msg("请填写相关交易数据");
                    return false;
                }
                var regExp = new RegExp("^[1-9]\\d*$");
                if(!regExp.test(money)){
                    layer.msg("只能是非负整数O-O");
                    return false;
                }

                $.ajax({
                   url: "clue/convert.json",
                    data:{
                        clueId: clueId,
                        activityId: activityId,
                        money: money,
                        name: name,// 交易的名字
                        expectedDate: expectedDate,
                        stage: stage,
                        isCreateTransaction: isCreateTransaction
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                       console.log(response);
                       if(response.result == "SUCCESS"){
                           // 条转到主页面
                           window.location.href="clue/index.html";
                       }

                    }
                });

            });


        });
    </script>

</head>
<body>

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询" id="searchActivity">
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
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="tBody">
                    <%--							<tr>--%>
                    <%--								<td><input type="radio" name="activity"/></td>--%>
                    <%--								<td>发传单</td>--%>
                    <%--								<td>2020-10-10</td>--%>
                    <%--								<td>2020-10-20</td>--%>
                    <%--								<td>zhangsan</td>--%>
                    <%--							</tr>--%>
                    <%--							<tr>--%>
                    <%--								<td><input type="radio" name="activity"/></td>--%>
                    <%--								<td>发传单</td>--%>
                    <%--								<td>2020-10-10</td>--%>
                    <%--								<td>2020-10-20</td>--%>
                    <%--								<td>zhangsan</td>--%>
                    <%--							</tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="title" class="page-header" style="position: relative; left: 20px;">
    <h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
    新建客户：${clue.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
    新建联系人：${clue.fullname}${clue.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
    <input type="checkbox" id="isCreateTransaction"/>
    为客户创建交易
</div>
<div id="create-transaction2"
     style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;">

    <form>
        <input type="hidden" id="activityId">
        <div class="form-group" style="width: 400px; position: relative; left: 20px;">
            <label for="amountOfMoney">金额</label>
            <input type="text" class="form-control" id="amountOfMoney">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="tradeName">交易名称</label>
            <input type="text" class="form-control" id="tradeName" value="动力节点-">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="expectedClosingDate">预计成交日期</label>
            <input type="text" class="form-control" id="expectedClosingDate">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="stage">阶段</label>
            <select id="stage" class="form-control">
                <option></option>
                <%--<option>资质审查</option>
                <option>需求分析</option>
                <option>价值建议</option>
                <option>确定决策者</option>
                <option>提案/报价</option>
                <option>谈判/复审</option>
                <option>成交</option>
                <option>丢失的线索</option>
                <option>因竞争丢失关闭</option>--%>
                <c:forEach items="${stages}" var="satage">
                    <option>${satage.value}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" style="text-decoration:
													   none;" id="searchActivityBtn"><span
                    class="glyphicon glyphicon-search"></span></a></label>
            <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
        </div>
    </form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
    记录的所有者：<br>
    <b>${clue.owner}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
    <input class="btn btn-primary" type="button" value="转换" id="saveConvertClueBtn">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input class="btn btn-default" type="button" value="取消">
</div>
</body>
</html>