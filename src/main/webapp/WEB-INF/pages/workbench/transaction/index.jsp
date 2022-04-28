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
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <script type="text/javascript">

        $(function () {


            $("#delete_clue").click(function () {
                var deleteCheckBox = $("#tBody input[type=checkbox]:checked");
                if (deleteCheckBox.size() == 0) {
                    layer.msg("至少选择一个要删除的O_O");
                    return false;
                }
                var id = "";
                $.each(deleteCheckBox, function () {
                    id = id + "ids=" + this.value + "&";
                });
                id = id.substr(0, id.length - 1);
                console.log(id);
                layer.confirm("是否删除？", {btn: ["确定", "取消"]}, function (index) {
                    $.ajax({
                        url: "transaction/more/delete.json",
                        data: id,
                        type: "post",
                        dataType: "json",
                        success: function (response) {
                            if(response.result == "SUCCESS"){
                                page($("#demo_pag1").bs_pagination('getOption', 'currentPage'),
                                    $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                                layer.msg("删除成功O_O");
                            }
                            if(response.result =="SUCCESS"){
                                layer.msg(response.msg);
                            }

                        }
                    });
                    layer.close(index);

                }, function () {
                    console.log("close");
                });

            });

            // 全选按钮
            $("#checkAll").click(function () {
                $("#tBody input[type=checkbox]").prop("checked", this.checked);
            });

            $("#tBody").on("click", "input[type=checkbox]", function () {
                if ($("#tBody input[type=checkbox]").size() == $("#tBody input[type=checkbox]:checked").size()) {
                    $("#checkAll").prop("checked", true);
                } else {
                    $("#checkAll").prop("checked", false);
                }
            })
            $("#toEditBtn").click(function () {
                var ids= $("#tBody input[type=checkbox]:checked");
                if (ids.size() == 0 || ids.size() > 1) {
                    layer.msg("选择一个要修改的O_O");
                    return false;
                }
                var id =ids.val();
                window.location.href = 'transaction/edit.html?id=' + id;
            });
            page(1, 5);


            function page(pageNum, pageSize) {
                // 收集参数
                var owner = $("#owner").val();
                var name = $("#name").val();
                var customerName = $("#customerName").val();
                var stage = $("#stage").val();
                var type = $("#type").val();
                var source = $("#create-source").val();
                var contactsName = $("#contactsName").val();

                $.ajax({
                    url: "transaction/index/page.json",
                    data: {
                        owner: owner,
                        name: name,
                        customerName: customerName,
                        stage: stage,
                        type: type,
                        source: source,
                        contactsName: contactsName,
                        pageNum: pageNum,
                        pageSize: pageSize
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                        console.log(response);
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
                                    "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='transaction/detail.html?id=" + obj.id + "';\">" + obj.name + "</a></td>";
                                htmlStr += "<td>" + obj.customerId + "</td>";
                                htmlStr += "<td>" + obj.stage + "</td>";
                                htmlStr += "<td>" + obj.type + "</td>";
                                htmlStr += "<td>" + obj.owner + "</td>";
                                htmlStr += "<td>" + obj.source + "</td>";
                                htmlStr += "<td>" + obj.contactsId + "</td>";
                                htmlStr += "</tr>";
                            });
                            $("#tBody").html(htmlStr);

                            $("#demo_pag1").bs_pagination({
                                currentPage: pageNum,
                                rowsPerPage: pageSize,
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
                                    page(pageObj.currentPage, pageObj.rowsPerPage);
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


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>交易列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="customerName">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">阶段</div>
                        <select class="form-control" id="stage">
                            <option></option>
                            <c:forEach items="${stageList}" var="stage">
                                <option>${stage.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <select class="form-control" id="type">
                            <option></option>
                            <c:forEach items="${transactionTypeList}" var="transaction">
                                <option>${transaction.value}</option>
                            </c:forEach>
                            <%--<option>已有业务</option>
                            <option>新业务</option>--%>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="create-clueSource">
                            <option></option>
                            <c:forEach items="${sourceList}" var="source">
                                <option>${source.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">联系人名称</div>
                        <input class="form-control" type="text" id="contactsName">
                    </div>
                </div>

                <button type="submit" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary"
                        onclick="window.location.href='transaction/save.html';"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="toEditBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="delete_clue"><span class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkAll"/></td>
                    <td>名称</td>
                    <td>客户名称</td>
                    <td>阶段</td>
                    <td>类型</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>
                <tbody id="tBody">
                </tbody>
            </table>
            <div id="demo_pag1"></div>
        </div>


    </div>

</div>
</body>
</html>