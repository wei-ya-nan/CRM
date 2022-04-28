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


            //当容器加载完成之后，对容器调用工具函数
            //$("input[name='mydate']").datetimepicker({
            $(".mydate").datetimepicker({
                language: 'zh-CN', //语言
                format: 'yyyy-mm-dd',//日期的格式
                minView: 'month', //可以选择的最小视图
                initialDate: new Date(),//初始化显示的日期
                autoclose: true,//设置选择完日期或者时间之后，日否自动关闭日历
                todayBtn: true,//设置是否显示"今天"按钮,默认是false
                clearBtn: true//设置是否显示"清空"按钮，默认是false
            });
            queryCluePage(1, 5);

            // 查询并分页
            $("#clue_query_commit").click(function () {

                queryCluePage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
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


            $("#updateClueBtn").click(function () {
                var checkId = $("#tBody input[type=checkbox]:checked");
                if (checkId.size() == 0) {
                    layer.msg("请选择要修改的线索O_O");
                    return false;
                }
                if (checkId.size() > 1) {
                    layer.msg("每次只能选择一个修改的线索O_O");
                    return false;
                }
                var id = checkId.val();
                /*layer.msg(id);*/
                $.ajax({
                    url: "clue/get/id/queryOne.json",
                    data: {
                        id: id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                        if (response.result == "SUCCESS") {
                            var data = response.data;
                            $("#edit-clueOwner").val(data.owner);
                            $("#edit-call").val(data.appellation);
                            $("#edit-job").val(data.job);
                            $("#edit-phone").val(data.phone);
                            $("#edit-mphone").val(data.mphone);
                            $("#edit-source").val(data.source);
                            $("#edit-describe").val(data.description);
                            $("#edit-company").val(data.company);
                            $("#edit-surname").val(data.fullname);
                            $("#edit-email").val(data.email);
                            $("#edit-website").val(data.website);
                            $("#edit-status").val(data.state);
                            $("#edit-contactSummary").val(data.contactSummary);
                            $("#edit-nextContactTime").val(data.nextContactTime);
                            $("#edit-address").val(data.address);
                            $("#update_clue_id").val(data.id);
                            $("#editClueModal").modal("show");

                        }

                    }
                });


            });

            $("#update_clue_commit").click(function () {
                var owner = $("#edit-clueOwner").val();
                var appellation = $("#edit-call").val();
                var job = $("#edit-job").val();
                var phone = $("#edit-phone").val();
                var mphone = $("#edit-mphone").val();
                var source = $("#edit-source").val();
                var description = $("#edit-describe").val();
                var company = $("#edit-company").val();
                var fullname = $("#edit-surname").val();
                var email = $("#edit-email").val();
                var website = $("#edit-website").val();
                var state = $("#edit-status").val();
                var contactSummary = $("#edit-contactSummary").val();
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $("#edit-address").val();
                var id = $("#update_clue_id").val();

                $.ajax({
                    url: "clue/update/commit/updateSave.json",
                    data: {
                        id: id,
                        owner: owner,
                        appellation: appellation,
                        job: job,
                        phone: phone,
                        mphone: mphone,
                        source: source,
                        description: description,
                        company: company,
                        fullname: fullname,
                        email: email,
                        website: website,
                        state: state,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                        console.log(response);
                        if (response.result == "SUCCESS") {
                            layer.msg("修改成功O-O");
                            queryCluePage($("#demo_pag1").bs_pagination('getOption', 'currentPage'),
                                $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                            $("#editClueModal").modal("hide");

                        }
                        if (response.result == "FAILED") {
                            layer.msg(response.msg);
                        }

                    }
                });

            });


            $("#createClueBtn").click(function () {
                // 模态框表单的初始化。清除数据。
                $("#createClueForm")[0].reset();
                $("#createClueModal").modal("show");
            });

            $("#saveClueBtn").click(function () {
                var fullname = $("#create-surname").val();
                var owner = $("#create-clueOwner").val();
                var appellation = $("#create-call").val();
                var job = $("#create-job").val();
                var phone = $("#create-phone").val();
                var mphone = $("#create-mphone").val();
                var source = $("#create-source option:selected").val();
                var company = $("#create-company").val();
                var email = $("#create-email").val();
                var website = $("#create-website").val();
                var status = $("#create-status option:selected").val();
                var description = $("#create-describe").val();
                var nextContactTime = $("#create-nextContactTime").val();
                var address = $("#create-address").val();

                if (company == "") {
                    layer.msg("请输入公司O_O");
                    return false;
                }
                if (fullname == "") {
                    layer.msg("请输入姓名O_O");
                    return false;
                }
                var regExp = new RegExp(/^\w+@([\da-z\.-]+)\.([a-z]{2,6}|[\u2E80-\u9FFF]{2,3})$/);
                if (!regExp.test(email)) {
                    layer.msg("邮箱格式不正确O-O");
                    return false;
                }

                /* var source = $("#clue_source option:selected").val();
                 console.log(source);*/
                // 发送请求
                $.ajax({
                    url: "clue/add.json",
                    data: {
                        fullname: fullname,
                        owner: owner,
                        appellation: appellation,
                        company: company,
                        job: job,
                        email: email,
                        phone: phone,
                        mphone: mphone,
                        source: source,
                        company: company,
                        email: email,
                        website: website,
                        state: status,
                        description: description,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                        console.log(response);
                        if (response.result == "SUCCESS") {
                            layer.msg("添加成功O_O");
                            $("#createClueModal").modal("hide");
                            queryCluePage($("#demo_pag1").bs_pagination('getOption', 'currentPage'), $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                        }

                    }
                });


            });

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
                layer.confirm("是否删除？", {btn: ["确定", "取消"]}, function (index) {
                    $.ajax({
                        url: "clue/more/delete.json",
                        data: id,
                        type: "post",
                        dataType: "json",
                        success: function (response) {
                            if(response.result == "SUCCESS"){
                                queryCluePage($("#demo_pag1").bs_pagination('getOption', 'currentPage'), $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
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


            function queryCluePage(pageNo, pageSize) {
                // 获取参数
                var fullname = $("#clue_name").val();
                var company = $("#clue_company").val();
                var phone = $("#clue_phone").val();
                var source = $("#clue_source option:selected").val();
                var owner = $("#clue_owner").val();
                var mphone = $("#clue_mphone").val();
                var state = $("#clue_status option:selected").val();

                $.ajax({
                    url: "clue/condition/page.json",
                    data: {
                        fullname: fullname,
                        company: company,
                        phone: phone,
                        source: source,
                        owner: owner,
                        mphone: mphone,
                        state: state,
                        pageNo: pageNo,
                        pageSize: pageSize
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                        console.log(response);

                        var htmlStr = "";

                        $.each(response.data.list, function (index, obj) {
                            htmlStr += "<tr>";
                            htmlStr += "<td><input type=\"checkbox\" value=\"" + obj.id + "\"/></td>";
                            htmlStr += "<td><a style=\"text-decoration: none; " +
                                "cursor: pointer;\"onclick=\"window.location.href='clue/detail.html?id="+obj.id+"';\">" +
                                obj.fullname + "</a></td>"
                            htmlStr += "<td>" + obj.company + "</td>";
                            htmlStr += "<td>" + obj.phone + "</td>";
                            htmlStr += "<td>" + obj.mphone + "</td>";
                            htmlStr += "<td>" + obj.source + "</td>";
                            htmlStr += " <td>" + obj.owner + "</td>";
                            htmlStr += "<td>" + obj.state + "</td>"
                            htmlStr += "<tr>";

                        });
                        $("#tBody").html(htmlStr);


                        $("#demo_pag1").bs_pagination({
                            currentPage: pageNo,
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
                                queryCluePage(pageObj.currentPage, pageObj.rowsPerPage);
                            }
                        });

                    }
                });


            }


        });

    </script>
</head>
<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="createClueForm">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueOwner">
                                <c:forEach items="${requestScope.userList}" var="user">
                                    <option>${user.name}</option>
                                </c:forEach>

                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <option></option>
                                <option>先生</option>
                                <option>夫人</option>
                                <option>女士</option>
                                <option>博士</option>
                                <option>教授</option>
                            </select>
                        </div>
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-status">
                                <option></option>
                                <option>试图联系</option>
                                <option>将来联系</option>
                                <option>已联系</option>
                                <option>虚假线索</option>
                                <option>丢失线索</option>
                                <option>未联系</option>
                                <option>需要条件</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <option>广告</option>
                                <option>推销电话</option>
                                <option>员工介绍</option>
                                <option>外部介绍</option>
                                <option>在线商场</option>
                                <option>合作伙伴</option>
                                <option>公开媒介</option>
                                <option>销售邮件</option>
                                <option>合作伙伴研讨会</option>
                                <option>内部研讨会</option>
                                <option>交易会</option>
                                <option>web下载</option>
                                <option>web调研</option>
                                <option>聊天</option>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">线索描述</label>
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
                            <label for="create-nextContactTime" class="col-sm-2 control-label"
                            >下次联系时间
                            </label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control mydate" id="create-nextContactTime">
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
                <button type="button" class="btn btn-primary" id="saveClueBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="update_clue_id">

                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">

                            <select class="form-control" id="edit-clueOwner">
                                <c:forEach items="${requestScope.userList}" var="user">
                                    <option>${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <option></option>
                                <option selected>先生</option>
                                <option>夫人</option>
                                <option>女士</option>
                                <option>博士</option>
                                <option>教授</option>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-surname" value="李四">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-status">
                                <option></option>
                                <option>试图联系</option>
                                <option>将来联系</option>
                                <option selected>已联系</option>
                                <option>虚假线索</option>
                                <option>丢失线索</option>
                                <option>未联系</option>
                                <option>需要条件</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <option selected>广告</option>
                                <option>推销电话</option>
                                <option>员工介绍</option>
                                <option>外部介绍</option>
                                <option>在线商场</option>
                                <option>合作伙伴</option>
                                <option>公开媒介</option>
                                <option>销售邮件</option>
                                <option>合作伙伴研讨会</option>
                                <option>内部研讨会</option>
                                <option>交易会</option>
                                <option>web下载</option>
                                <option>web调研</option>
                                <option>聊天</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3"
                                          id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label"
                            >下次联系时间
                            </label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control mydate" id="edit-nextContactTime"
                                       value="2017-05-01">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="update_clue_commit">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <div class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="clue_name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" type="text" id="clue_company">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="clue_phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="clue_source">
                            <option></option>
                            <option>广告</option>
                            <option>推销电话</option>
                            <option>员工介绍</option>
                            <option>外部介绍</option>
                            <option>在线商场</option>
                            <option>合作伙伴</option>
                            <option>公开媒介</option>
                            <option>销售邮件</option>
                            <option>合作伙伴研讨会</option>
                            <option>内部研讨会</option>
                            <option>交易会</option>
                            <option>web下载</option>
                            <option>web调研</option>
                            <option>聊天</option>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="clue_owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" type="text" id="clue_mphone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="clue_status">
                            <option></option>
                            <option>试图联系</option>
                            <option>将来联系</option>
                            <option>已联系</option>
                            <option>虚假线索</option>
                            <option>丢失线索</option>
                            <option>未联系</option>
                            <option>需要条件</option>
                        </select>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="clue_query_commit">查询</button>

            </div>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createClueBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="updateClueBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="delete_clue"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkAll"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>

                <tbody id="tBody">
                <%--                <tr>--%>
                <%--                    <td><input type="checkbox"/></td>--%>
                <%--                    <td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--                           onclick="window.location.href='detail.html';">李四先生</a></td>--%>
                <%--                    <td>动力节点</td>--%>
                <%--                    <td>010-84846003</td>--%>
                <%--                    <td>12345678901</td>--%>
                <%--                    <td>广告</td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                    <td>已联系</td>--%>
                <%--                </tr>--%>
                <%--                <tr class="active">--%>
                <%--                    <td><input type="checkbox"/></td>--%>

<%--                                    <td><a style="text-decoration: none; cursor: pointer;"--%>
<%--                                           onclick="window.location.href='detail.html?'+obj.id;">李四先生</a></td>--%>
                <%--                    <td>动力节点</td>--%>
                <%--                    <td>010-84846003</td>--%>
                <%--                    <td>12345678901</td>--%>
                <%--                    <td>广告</td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                    <td>已联系</td>--%>
                <%--                </tr>--%>

            </table>
            <div id="demo_pag1"></div>
        </div>

        <%--<div style="height: 50px; position: relative;top: 60px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                        10
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href="#">20</a></li>
                        <li><a href="#">30</a></li>
                    </ul>
                </div>
                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
            </div>
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination">
                        <li class="disabled"><a href="#">首页</a></li>
                        <li class="disabled"><a href="#">上一页</a></li>
                        <li class="active"><a href="#">1</a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li><a href="#">下一页</a></li>
                        <li class="disabled"><a href="#">末页</a></li>
                    </ul>
                </nav>
            </div>
        </div>--%>

    </div>

</div>
</body>
</html>