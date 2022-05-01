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
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $("#saveActivityRemarkBtn").click(function () {
                var content = $.trim($("#remark").val());
                var customerId = '${customer.id}';
                /*console.log(activityId);
                console.log(content);*/
                if (content == "") {
                    layer.msg("备注不能为空O_O");
                    return;
                }
                $.ajax({
                    url: "customer/remark/detail/add.json",
                    data: {
                        noteContent: content,
                        customerId: customerId
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                        console.log(response);
                        if (response.result == "SUCCESS") {
                            layer.msg("添加成功O_O");
                            $("#remark").val("");
                            // 刷新备注列表
                            var htmlStr = "";
                            htmlStr +=
                                "<div id=\"div_" + response.data.id + "\" class=\"remarkDiv\" style=\"height: 60px;\">";
                            htmlStr +=
                                "<img title=\"${sessionScope.user.name}\" src=\"image/user-thumbnail.png\" style=\"width:30px;height:30px;\">";
                            htmlStr += "<div style=\"position: relative; top: -40px; left: 40px;\" >";
                            htmlStr += "<h5>" + response.data.noteContent + "</h5>";
                            htmlStr += "<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> " +
                                "<b>${customer.name}</b><small style=\"color: gray;\">" + response.data.createTime
                                + "由${sessionScope.user.name}</small>";
                            htmlStr += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">"
                            htmlStr += "<a class=\"myHref\" name=\"edit_remark\" remarkId=\"" + response.data.id + "\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "&nbsp;&nbsp;&nbsp;&nbsp;";
                            htmlStr += "<a class=\"myHref\" name=\"delete_remark\" remarkId=\"" + response.data.id + "\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "</div>";
                            htmlStr += "</div>";
                            htmlStr += "</div>";
                            $("#remarkDiv").before(htmlStr);

                        }
                        if (response.result == "FAILED") {
                            layer.msg(response.message);
                            $("#remark").val("");
                        }


                    },
                    error: function (response) {
                        layer.msg(response.message);
                    }
                });
            });

            $("#remarkDivList").on("click", "a[name=delete_remark]", function () {
                var id = $(this).attr("remarkId");
                /*alert(id);*/
                $.ajax({
                    url: "customer/detail/remark/delete.json",
                    data: {
                        id: id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                        /*console.log(response);*/
                        if (response.result == "SUCCESS") {
                            layer.confirm("是否删除O_O", function () {
                                $("#div_" + id).remove();

                                layer.msg("删除成功O_O");
                            });
                        }
                        if (response.result == "FAILED") {
                            layer.msg(response.message);
                        }
                    }
                });
            })

            $("#remarkDivList").on("click", "a[name=edit_remark]", function () {

                var id = $(this).attr("remarkId");
                var noteContent = $("#div_" + id + " h5").text();
                $("#remarkId").val(id);
                $("#noteContent").val(noteContent);
                $("#editRemarkModal").modal("show");
                var id = $(this).attr("remarkId");
                // layer.msg(id)/*;*/

            });

            $("#updateRemarkBtn").click(function () {
                // 收集参数
                var id = $("#remarkId").val();
                var noteContent = $("#noteContent").val();

                $.ajax({
                    url: "customer/remark/update.json",
                    data: {
                        id: id,
                        noteContent: noteContent
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                        console.log(response);
                        if (response.result == "SUCCESS") {
                            $("#editRemarkModal").modal("hide");
                            // 初始化刷新页面
                            $("#div_" + response.data.id + " h5").text(response.data.noteContent);
                            $("#div_" + response.data.id + " small").text(" " + response.data.editTime + " " +
                                "由${sessionScope.user.name}修改");

                        }
                        if (response.result == "FAILED") {
                            layer.msg(response.message);
                        }
                    }
                });

            });


            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $("#remarkDivList").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });


            /*$(".remarkDiv").mouseout(function(){
                $(this).children("div").children("div").hide();
            });*/
            $("#remarkDivList").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            /*$(".myHref").mouseover(function(){
                $(this).children("span").css("color","red");
            });*/
            $("#remarkDivList").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            /*$(".myHref").mouseout(function(){
                $(this).children("span").css("color","#E6E6E6");
            });*/
            $("#remarkDivList").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            $("#tranBody a[name=deleteTranBtn]").click(function () {
                window.id = $(this).attr("transactionId");

                $("#removeTransactionModal").modal("show");
            });

            $("#deleteTranCommit").click(function () {
                console.log(window.id);
                $.ajax({
                    url: "transaction/more/delete.json",
                    data: {
                        id: window.id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {

                        if (response.result == "SUCCESS") {
                            $("#div_" + window.id).remove();
                            $("#removeTransactionModal").modal("hide");
                        }
                    }
                });

            });

            $("#createContactsBtn").click(function () {
                $("#createTranForm").get(0).reset();
                $("#createContactsModal").modal("show");
            });


            //当容器加载完成之后，对容器调用工具函数
            $("#create-customerName").typeahead({
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
                            // $("#customerId").val(response.data.id);
                            process(response.data);
                        }

                    });

                }

            });


            $("#saveCreateContacts").click(function () {
                // 收集参数
                var owner = $("#create-contactsOwner").val();
                var source = $("#create-clueSource").val();
                var fullname = $("#create-surname").val()
                var appellation = $("#create-call").val();
                var job = $("#create-job").val();
                var mphone = $("#create-mphone").val();
                var email = $("#create-email").val();
                var description = $("#create-describe").val();
                var contactSummary = $("#edit-contactSummary").val();
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $("#edit-address1").val();
                var id = '${customer.id}';

                $.ajax({
                    url: "customer/detail/concat/add.json",
                    data: {
                        owner: owner,
                        source: source,
                        fullname: fullname,
                        appellation: appellation,
                        job: job,
                        mphone: mphone,
                        email: email,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address,
                        customerId: id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                        if (response.result == "SUCCESS") {

                            var htmlStr = "";
                            htmlStr += "<tr id=\"div_\"" + response.data.id + ">";
                            htmlStr += "<td><a href=\"contacts/detail.html\" style=\"text-decoration: none;\">" + response.data.fullname + "</a></td>";
                            htmlStr += "<td>" + response.data.email + "</td>";
                            htmlStr += "<td>" + response.data.mphone + "</td>";
                            htmlStr += "<td><a href=\"javascript:void(0);\" data-toggle=\"modal\" name=\"deleteContacts\"style=\"text-decoration: none;\">";
                            htmlStr += "<span class=\"glyphicon glyphicon-remove\"></span>删除</a>";
                            htmlStr += "</td>";
                            htmlStr += "</tr>";

                            $("#contactBody").append(htmlStr);
                            $("#createContactsModal").modal("hide");

                        } else {
                            layer.msg(response.message);
                        }


                    }
                });

            });

            $("#contactBody").on("click", "a[name=deleteContacts]", function () {
                window.conId = $(this).attr("contactsId");
                $("#removeContactsModal").modal("show");


            });

            $("#deleteContactsBtn").click(function () {
                $.ajax({
                    url: "customer/contacts/id/delete.json",
                    data: {id: window.conId},
                    type: "post",
                    dataType: "json",
                    success: function (response) {
                        if (response.result == "SUCCESS") {
                            $("#div_" + window.conId).remove();
                            $("#removeContactsModal").modal("hide");
                        }
                    }
                });
            });


        });

    </script>

</head>
<body>

<!-- 删除联系人的模态窗口 -->
<div class="modal fade" id="removeContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除联系人</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该联系人吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" id="deleteContactsBtn">删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 删除交易的模态窗口 -->
<div class="modal fade" id="removeTransactionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除交易</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该交易吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" id="deleteTranCommit">删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="createTranForm">

                    <div class="form-group">
                        <label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-contactsOwner">
                                <c:forEach items="${users}" var="user">
                                    <option>${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueSource">
                                <option></option>
                                <c:forEach items="${source}" var="source">
                                    <option>${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <option></option>
                                <c:forEach items="${appellation}" var="appellation">
                                    <option>${appellation.value}</option>
                                </c:forEach>

                            </select>
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                        <label for="create-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-birth">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建">
                            <input type="hidden" id="customerId">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3"
                                          id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-nextContactTime"
                                >
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address1"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateContacts">保存</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${customer.name}
            <small><a href="http://www.bjpowernode.com" target="_blank">${customer.website}</a></small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.createBy}&nbsp;
            &nbsp;</b><small
                style="font-size: 10px; color: gray;">${customer.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.editBy}&nbsp;
            &nbsp;</b><small
                style="font-size: 10px; color: gray;">${customer.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${customer.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.nextContactTime}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${customer.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${customer.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 10px; left: 40px;" id="remarkDivList">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->
    <c:forEach items="${remarkList}" var="remark">
        <div class="remarkDiv" style="height: 60px;" id="div_${remark.id}">
            <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>${remark.noteContent}</h5>
                <font color="gray">市场活动</font> <font color="gray">-</font> <b>${customer.name}</b> <small
                    style="color: gray;">
                    ${remark.editFlag=='1'? remark.editTime : remark.createTime}
                由${remark.editFlag == '1' ? remark.editBy :remark.createBy}${remark.editFlag=='1'?'修改':'创建'}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" href="javascript:void(0);" name="edit_remark" remarkId="${remark.id}">
                        <span class="glyphicon glyphicon-edit"
                              style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" href="javascript:void(0);" name="delete_remark" remarkId="${remark.id}">
                        <span class="glyphicon glyphicon-remove"
                              style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>


    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveActivityRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 交易 -->
<div>
    <div style="position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>交易</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable2" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>金额</td>
                    <td>阶段</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>类型</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="tranBody">
                <c:forEach items="${tranList}" var="tran">

                    <tr id="div_${tran.id}">
                        <td><a href="transaction/detail.html?id=${tran.id}"
                               style="text-decoration: none;">${tran.name}</a></td>
                        <td>${tran.money}</td>
                        <td>${tran.stage}</td>
                        <td>${tran.possibility}</td>
                        <td>${tran.nextContactTime}</td>
                        <td>${tran.type}</td>
                        <td><a href="" data-toggle="modal" style="text-decoration: none;"
                               transactionId="${tran.id}"
                               name="deleteTranBtn"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
                    </tr>

                </c:forEach>
                </tbody>
            </table>
        </div>

        <div>
            <a href="customer/save.html?customerId=${customer.id}" style="text-decoration: none;"><span
                    class="glyphicon glyphicon-plus"></span>新建交易</a>
        </div>
    </div>
</div>

<!-- 联系人 -->
<div>
    <div style="position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>联系人</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>邮箱</td>
                    <td>手机</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="contactBody">
                <c:forEach items="${contactsList}" var="contacts">

                    <tr id="div_${contacts.id}">
                        <td><a href="contacts/detail.html?id=${contacts.id}"
                               style="text-decoration: none;">${contacts.fullname}</a>
                        </td>
                        <td>${contacts.email}</td>
                        <td>${contacts.mphone}</td>
                        <td><a href="javascript:void(0);" data-toggle="modal" name="deleteContacts"
                               contactsId="${contacts.id}"
                               style="text-decoration: none;"><span
                                class="glyphicon glyphicon-remove"></span>删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" data-toggle="modal" id="createContactsBtn"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
        </div>
    </div>
</div>

<div style="height: 200px;"></div>
</body>
</html>