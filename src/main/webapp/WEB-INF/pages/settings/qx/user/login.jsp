<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <base
            href="http://${pageContext.request.serverName }:${pageContext.request.serverPort }${pageContext.request.contextPath }/"/>
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#loginBtn").click(function () {
				var loginAct = $.trim($("#loginAct").val());
				var password = $("#loginPwd").val();
				var isRemPwd = $("#isRemPwd").prop("checked");

				$.ajax({
					url:"user/login.json",
					data:{
						loginAct: loginAct,
						password: password,
						isRemPwd: isRemPwd
					},
					type: "post",
					dataType: "json",
					success:function (response) {
						console.log(response);
						if(response.result == "SUCCESS"){
						    window.location.href = "workbench/index.html";

                        }
						if(response.result == "FAILED"){
						    console.log(response);
						    $("#message").text(response.message);
                        }

					},
                    error:function (response) {
					    console.log(response);
                    }
				})
            });


        });


    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;动力节点</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.html" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <P id="message" style="color:red">${requestScope.exception.message}</P>


                    <input class="form-control" id="loginAct" type="text" placeholder="用户名" name="username"
                           value="李四"
                    >
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" id="loginPwd" type="password" placeholder="密码" name="password"
                           value="123">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">
                    <label>
                        <input type="checkbox" id="isRemPwd" checked="checked"> 十天内免登录
                    </label>
                    &nbsp;&nbsp;
                    <span id="msg" style="color: red"></span>
                </div>
                <button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>