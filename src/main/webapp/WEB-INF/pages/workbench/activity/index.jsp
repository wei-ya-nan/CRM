<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core" %>
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
            //给"创建"按钮添加单击事件
            $("#createActivityBtn").click(function () {
                //初始化工作
                //重置表单
                $("#createActivityForm").get(0).reset();

                //弹出创建市场活动的模态窗口
                $("#createActivityModal").modal("show");
            });

            $("#addActivityModal").click(function () {
                //收集参数
                var owner = $("#create-marketActivityOwner").val();
                var name = $.trim($("#create-marketActivityName").val());
                var startDate = $("#create-startTime").val();
                var endDate = $("#create-endTime").val();
                var cost = $.trim($("#create-cost").val());
                var description = $.trim($("#create-describe").val());

                if (owner == "") {
                    layer.msg("所有者不能为空");
                    return false;
                }
                if (name == "") {
                    layer.msg("名称不能为空");
                    return false;
                }
                if (startDate != "" && endDate != "") {
                    //使用字符串的大小代替日期的大小
                    if (endDate < startDate) {
                        layer.msg("结束日期不能比开始日期小");
                        return false;
                    }
                }
                var regExp = /^(([1-9]\d*)|0)$/;
                if (!regExp.test(cost)) {
                    layer.msg("成本只能值非负整数！！！");
                    return false;
                }
                $.ajax({
                    url: "activity/add.json",
                    type: "post",
                    dataType: "json",
                    data: {
                        owner: owner,
                        name: name,
                        startDate: startDate,
                        endDate: endDate,
                        cost: cost,
                        description: description
                    },
                    success: function (response) {
                        var result = response.result;
                        if (result == "SUCCESS") {
                            layer.msg("添加成功！！！");
                            queryActivityConditionPage(1, $("#demo_pag1").bs_pagination('getOption',
                                'rowsPerPage'));
                            $("#createActivityModal").modal("hide");
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


            $(".mydate").datetimepicker({
                language: 'zh-CN', //语言
                format: 'yyyy-mm-dd',//日期的格式
                minView: 'month', //可以选择的最小视图
                initialDate: new Date(),//初始化显示的日期
                autoclose: true,//设置选择完日期或者时间之后，日否自动关闭日历
                todayBtn: true,//设置是否显示"今天"按钮,默认是false
                clearBtn: true//设置是否显示"清空"按钮，默认是false
            });

            queryActivityConditionPage(1, 5);
            $("#queryByLikePage").click(function () {
                //查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
                queryActivityConditionPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                return false;
            });

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

            $("#deleteActivityBtn").click(function () {
                var checkBoxList = $("#tBody input[type=checkbox]:checked");
                if (checkBoxList.size() == 0) {
                    layer.msg("请选择要删除的市场活动！！！");
                    return false;
                }
                layer.confirm("是否删除？", {btn: ["确定", "取消"]}, function (index) {
                    // layer.msg("aaa");
                    var ids = "";
                    $.each(checkBoxList, function () {
                        ids = ids + "ids=" + this.value + "&";
                    });
                    ids = ids.substr(0, ids.length - 1);

                    $.ajax({
                        url: "activity/id/delete.json",
                        type: "post",
                        dataType: "json",
                        data: ids,
                        success: function (response) {
                            console.log(response);
                            if (response.result == "SUCCESS") {
                                queryActivityConditionPage(1, $("#demo_pag1").bs_pagination('getOption',
                                    'rowsPerPage'));
                                layer.msg("删除成功O_O");

                            }

                        },
                        error: function (response) {
                            layer.msg("系统繁忙请稍后重试o_o");

                        }
                    });
                    layer.close(index);

                }, function () {
                    console.log("close");
                });
            });

            $("#updateActivityBtn").click(function () {

                var checkboxList = $("#tBody input[type=checkbox]:checked");
                if (checkboxList.size() == 0) {
                    layer.msg("请选择要修改的市场活动O_O");
                    return false;
                }
                if (checkboxList.size() > 1) {
                    layer.msg("只能选择一个要修改的市场活动O_O");
                    return false;
                }
                if (checkboxList.size() == 1) {
                    var checkedId = checkboxList[0].value;
                    // layer.msg(checkedId);

                    $.ajax({
                        url: "activity/id/queryOne.json",
                        type: "post",
                        dataType: "json",
                        data: {
                            id: checkedId
                        },
                        success: function (response) {
                            console.log(response);
                            window.id = response.data.id;
                            $("#edit-marketActivityOwner").val(response.data.owner);
                            $("#edit-startTime").val(response.data.startDate);
                            $("#edit-marketActivityName").val(response.data.name);
                            $("#edit-cost").val(response.data.cost);
                            $("#edit-describe").val(response.data.description);
                            $("#edit-endTime").val(response.data.endDate);
                            // 关闭模态框
                            $("#editActivityModal").modal("show");
                        },
                        error: function (response) {
                            layer.msg("系统繁忙请稍后重试O_O");
                        }
                    });
                }
            });

            $("#updateActivityCommit").click(function () {

                var id = window.id;
                var owner = $("#edit-marketActivityOwner").val();
                var startTime = $("#edit-startTime").val();
                var name = $("#edit-marketActivityName").val();
                var cost = $("#edit-cost").val();
                var description = $("#edit-describe").val();
                var endDate = $("#edit-endTime").val();

                $("#editActivityModal").modal("show");

                /*layer.msg(id);*/
                $.ajax({
                    url: "activity/id/update.json",
                    data: "post",
                    dataType: "json",
                    data: {
                        id: id,
                        owner: owner,
                        startDate: startTime,
                        name: name,
                        cost: cost,
                        description: description,
                        endDate: endDate
                    },
                    success: function (response) {

                        if (response.result == "SUCCESS") {
                            layer.msg("修改成功O_O");
                            $("#editActivityModal").modal("hide");
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

            $("#importActivityBtn").click(function () {
                //收集参数
                var activityFileName = $("#activityFile").val();
                var suffix = activityFileName.substr(activityFileName.lastIndexOf(".") + 1).toLocaleLowerCase();//xls,XLS,Xls,xLs,....
                if (suffix != "xls") {
                    alert("只支持xls文件");
                    return;
                }
                var activityFile = $("#activityFile")[0].files[0];
                if (activityFile.size > 5 * 1024 * 1024) {
                    alert("文件大小不超过5MB");
                    return;
                }

                //FormData是ajax提供的接口,可以模拟键值对向后台提交参数;
                //FormData最大的优势是不但能提交文本数据，还能提交二进制数据
                var formData = new FormData();
                formData.append("file", activityFile);
                formData.append("userName", "张三");
                console.log(formData);
                $.ajax({
                    url: "import/activity/xls.json",
                    // type: "post",
                    // data: formData,
                    // dataType: "json",
                    // processDate: false, // 告诉jquery不要处理 发送的数据 对data数据进行序列化处理
                    // contentType: false,// 告诉jquery不要设置Content-type请求 头,

                    data: formData,
                    // async: false,
                    processData: false,//设置ajax向后台提交参数之前，是否把参数统一转换成字符串：true--是,false--不是,默认是true
                    contentType: false,//设置ajax向后台提交参数之前，是否把所有的参数统一按urlencoded编码：true--是,false--不是，默认是true
                    type: 'post',
                    dataType: 'json',
                    // mimeType: "multipart/form-data",
                    success: function (response) {
                        if (response.result == "SUCCESS") {
                            layer.msg("添加成功O_O");
                            $("#importActivityModal").modal("hide");
                            queryActivityConditionPage($("#demo_pag1").bs_pagination('getOption', 'currentPage'),
                                $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                        }
                    },
                    error: function (response) {
                        layer.msg("文件内容格式不对O_O");

                        $("#importActivityModal").modal("show");
                    }
                });

            });

            $("#exportActivityAllBtn").click(function () {
                window.location.href = "activity/exportAll.html";
            });


            // $("#exportActivityXzBtn").on("click","input[type=checkbox]",function () {
            //     var checkboxlist = $("tBody [type=checkbox]:checked");
            //     if(checkboxlist.size() == 0){
            //         layer.msg("请选在要导出的数据O_O");
            //
            //     }
            // });

            $("#exportActivityXzBtn").click(function () {
                var ids = "";
                var checkboxlist = $("tBody [type='checkbox']:checked");
                if (checkboxlist.size() == 0) {
                    layer.msg("请选在要导出的数据O_O");
                }
                // var list = new Array();

                $.each(checkboxlist, function () {
                    ids = ids + "ids=" + this.value + "&";
                    // list.push(this.value);
                })

                ids = ids.substr(0, ids.length - 1);
                window.location.href="activity/exportMore.html?"+ids

                // $.ajax({
                //     url: "activity/exportMore.json",
                //     dataType: "json",
                //     type: "post",
                //     data:ids,
                //     success: function (response) {
                //         console.log(response);
                //     }
                //
                // });


                // window.location.href="activity/exportMore.html";
            });


            function queryActivityConditionPage(pageNum, PageSize) {
                var keyword = $.trim($("#queryName").val());
                var owner = $.trim($("#queryOwner").val());
                var startDate = $("#startTime").val();
                var endDate = $("#endTime").val();

                $.ajax({
                    url: "activity/queryCondition/page.json",
                    type: "post",
                    dataType: "json",
                    data: {
                        keyword: keyword,
                        owner: owner,
                        startDate: startDate,
                        endDate: endDate,
                        pageNum: pageNum,
                        PageSize: PageSize
                    },
                    success: function (response) {
                        console.log(response.data);
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
                                    "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='activity/detail.html?id=" + obj.id+"';\">" + obj.name + "</a></td>";
                                htmlStr += "<td>" + obj.owner + "</td>";
                                htmlStr += "<td>" + obj.startDate + "</td>";
                                htmlStr += "<td>" + obj.endDate + "</td>";
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

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="createActivityForm">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">
                                <c:forEach items="${requestScope.users}" var="user">
                                    <option>${user.name}</option>
                                </c:forEach>

                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="create-startTime">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="create-endTime">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="addActivityModal">保存
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input class="form-control" id="edit-marketActivityOwner" type="text">
                                <%-- <C:forEach items="${requestScope.users}" var="user">
                                     <option>${user.name}</option>
                                 </C:forEach>
                                 <option>zhangsan</option>
                                 <option>lisi</option>
                                 <option>wangwu</option>--%>
                            </input>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="updateActivityCommit">更新
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile" multiple="multiple">
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
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
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control mydate" type="text" id="startTime"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control mydate" type="text" id="endTime">
                    </div>
                </div>

                <button type="submit" class="btn btn-default" id="queryByLikePage">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" id="createActivityBtn" class="btn btn-primary"
                        data-target="#createActivityModal"><span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="updateActivityBtn">
                    <span class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal"
                        data-target="#importActivityModal" <%--id="importActivityBtn2"--%>><span
                        class="glyphicon glyphicon-import"></span>
                    上传列表数据（导入）
                </button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）
                </button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）
                </button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkBoxAll"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="tBody">

                <%--					<c:forEach items="${requestScope.users}" var="user">--%>
                <%--						<tr class="active">--%>
                <%--							<td><input type="checkbox" /></td>--%>
                <%--							<td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--								   onclick="window.location.href='detail.html';">${user.name}</a></td>--%>
                <%--							<td>${user.owner}</td>--%>
                <%--							<td>${user.createtime}</td>--%>
                <%--							<td>${user.endDate}</td>--%>
                <%--						</tr>--%>
                <%--					</c:forEach>--%>
                <%--						<tr class="active">--%>
                <%--							<td><input type="checkbox" /></td>--%>
                <%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
                <%--                            <td>zhangsan</td>--%>
                <%--							<td>2020-10-10</td>--%>
                <%--							<td>2020-10-20</td>--%>
                <%--						</tr>--%>
                <%--                        <tr class="active">--%>
                <%--                            <td><input type="checkbox" /></td>--%>
                <%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
                <%--                            <td>zhangsan</td>--%>
                <%--                            <td>2020-10-10</td>--%>
                <%--                            <td>2020-10-20</td>--%>
                <%--                        </tr>--%>
                </tbody>
            </table>
            <div id="demo_pag1"></div>
        </div>

        <%--        <div style="height: 50px; position: relative;top: 30px;">--%>
        <%--            <div>--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
        <%--            </div>--%>
        <%--            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
        <%--                <div class="btn-group">--%>
        <%--                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
        <%--                        10--%>
        <%--                        <span class="caret"></span>--%>
        <%--                    </button>--%>
        <%--                    <ul class="dropdown-menu" role="menu">--%>
        <%--                        <li><a href="#">20</a></li>--%>
        <%--                        <li><a href="#">30</a></li>--%>
        <%--                    </ul>--%>
        <%--                </div>--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
        <%--            </div>--%>
        <%--            <div style="position: relative;top: -88px; left: 285px;">--%>
        <%--                <nav>--%>
        <%--                    <ul class="pagination">--%>
        <%--                        <li class="disabled"><a href="#">首页</a></li>--%>
        <%--                        <li class="disabled"><a href="#">上一页</a></li>--%>
        <%--                        <li class="active"><a href="#">1</a></li>--%>
        <%--                        <li><a href="#">2</a></li>--%>
        <%--                        <li><a href="#">3</a></li>--%>
        <%--                        <li><a href="#">4</a></li>--%>
        <%--                        <li><a href="#">5</a></li>--%>
        <%--                        <li><a href="#">下一页</a></li>--%>
        <%--                        <li class="disabled"><a href="#">末页</a></li>--%>
        <%--                    </ul>--%>
        <%--                </nav>--%>
        <%--            </div>--%>
        <%--        </div>--%>

    </div>

</div>
</body>
</html>