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

    <style type="text/css">
        .mystage {
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }

        .closingDate {
            font-size: 15px;
            cursor: pointer;
            vertical-align: middle;
        }
    </style>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/layer/layer.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
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


            //阶段提示框
            $(".mystage").popover({
                trigger: 'manual',
                placement: 'bottom',
                html: 'true',
                animation: false
            }).on("mouseenter", function () {
                var _this = this;
                $(this).popover("show");
                $(this).siblings(".popover").on("mouseleave", function () {
                    $(_this).popover('hide');
                });
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide")
                    }
                }, 100);
            });
			$("#remarkDivList").on("click","a[name=edit_remark]",function () {

				var id = $(this).attr("remarkId");
				var noteContent = $("#div_"+id+" h5").text();
				$("#remarkId").val(id);
				$("#noteContent").val(noteContent);
				$("#editRemarkModal").modal("show");
				var id = $(this).attr("remarkId");
				// layer.msg(id)/*;*/

			});
			$("#remarkDivList").on("click", "a[name=delete_remark]", function () {
				var id = $(this).attr("remarkId");
				/*alert(id);*/
				$.ajax({
					url: "transaction/detail/remark/delete.json",
					data: {
						id: id
					},
					type: "post",
					dataType: "json",
					success: function (response) {
						/*console.log(response);*/
						if(response.result == "SUCCESS"){
							layer.confirm("是否删除O_O",function () {
								$("#div_"+id).remove();

								layer.msg("删除成功O_O");
							});
						}
						if(response.result =="FAILED"){
							layer.msg(response.message);
						}
					}
				});
			})

			$("#updateRemarkBtn").click(function () {
				// 收集参数
				var id = $("#remarkId").val();
				var noteContent = $("#noteContent").val();

				$.ajax({
					url: "transaction/remark/update.json",
					data: {
						id: id,
						noteContent: noteContent
					},
					type: "post",
					dataType: "json",
					success: function (response) {
						console.log(response);
						if(response.result == "SUCCESS"){
							$("#editRemarkModal").modal("hide");
							// 初始化刷新页面
							$("#div_"+response.data.id+" h5").text(response.data.noteContent);
							$("#div_"+response.data.id+" small").text(" "+response.data.editTime+" " +
									"由${sessionScope.user.name}修改");

						}
						if(response.result == "FAILED"){
							layer.msg(response.message);
						}
					}
				});

			});

            $("#createRemarkBtn").click(function () {
                var noteContent = $("#remark").val();
                var tranId = '${tran.id}';
                if (noteContent == '') {
                    layer.msg("备注不能为空O_O");
                    return false;
                }
				$.ajax({
					url: "transaction/detail/add.json",
					data: {
						noteContent: noteContent,
						tranId: tranId
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
							htmlStr += "<h5>"+ response.data.noteContent+"</h5>";
							htmlStr += "<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> " +
									"<b>${tran.name}</b><small style=\"color: gray;\">" + response.data.createTime
									+ "由${sessionScope.user.name}创建</small>";
							htmlStr += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">"
							htmlStr+="<a class=\"myHref\" name=\"edit_remark\" remarkId=\""+response.data.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
							htmlStr+="<a class=\"myHref\" name=\"delete_remark\" remarkId=\""+response.data.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
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
        });


    </script>

</head>
<body>
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
        <h3>${tran.name} <small>${tran.money}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 阶段状态 -->
<div style="position: relative; left: 40px; top: -50px;">
    阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <!--遍历stageList,依次显示每一个阶段对应的图标-->
    <c:forEach items="${stageList}" var="stage">
        <c:if test="${stage.value == tran.stage}">
            <span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom"
                  data-content="${stage.value}" style="color: #90F790;"></span>
            -----------
        </c:if>
        <!--如果stage处在当前交易所处阶段前边，则图标显示为ok-circle，颜色显示为绿色-->
        <c:if test="${tran.orderNo>stage.orderNo}">
            <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"
                  data-content="${stage.value}" style="color: #90F790;"></span>
            -----------
        </c:if>
        <!--如果stage处在当前交易所处阶段的后边。则图标显示为record，颜色为黑色-->
        <c:if test="${tran.orderNo<stage.orderNo}">
            <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"
                  data-content="${stage.value}"></span>
            -----------
        </c:if>


    </c:forEach>


    <span class="closingDate">${tran.createTime}</span>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: 0px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.money}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.name}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.stage}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">类型</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.possibility}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">联系人名称</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsId}</b></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;
            &nbsp;</b><small
                style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.editBy}&nbsp;
            &nbsp;</b><small
                style="font-size: 10px; color: gray;">${tran.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${tran.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${tran.contactSummary}
                &nbsp;
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div
                style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;
            ${tran.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 100px; left: 40px;" id="remarkDivList">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->
    <c:forEach items="${remark}" var="remark">


        <div class="remarkDiv" style="height: 60px;" id="div_${remark.id}">
            <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;" >
            <div style="position: relative; top: -40px; left: 40px;" >
                <h5>${remark.noteContent}</h5>
                <font color="gray">交易</font> <font color="gray">-</font> <b>${remark.tranId}</b> <small
                    style="color: gray;">
                    ${remark.editFlag == 0?remark.createTime:remark.editTime}由${remark.editFlag==0?remark.createBy:remark.editBy}${remark.editFlag==0?'创建':'修改'}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" href="javascript:void(0);" name="edit_remark" remarkId="${remark.id}"><span
							class="glyphicon glyphicon-edit"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" href="javascript:void(0);" name="delete_remark" remarkId="${remark.id}"><span
							class="glyphicon glyphicon-remove"
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
                <button type="button" class="btn btn-primary" id="createRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 阶段历史 -->
<div>
    <div style="position: relative; top: 100px; left: 40px;">
        <div class="page-header">
            <h4>阶段历史</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>阶段</td>
                    <td>金额</td>
                    <td>预计成交日期</td>
                    <td>创建时间</td>
                    <td>创建人</td>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${history}" var="history">
                    <tr>
                        <td>${history.stage}</td>
                        <td>${history.money}</td>
                        <td>${history.expectedDate}</td>
                        <td>${history.createTime}</td>
                        <td>${history.createBy}</td>
                    </tr>
                </c:forEach>

                </tbody>
            </table>
        </div>

    </div>
</div>

<div style="height: 200px;"></div>

</body>
</html>