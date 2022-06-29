<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>login</title>

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
        }
        
        .top {
            height: 50px;
            background-color: #3c3c3c;
        }
        
        .top .logo {
            padding-top: 5px;
            left: 5px;
            width: 20%;
            height: 50px;
            position: absolute;
            color: aliceblue;
            font-size: 30px;
            font-family: 'times new roman'
        }
        
        .top .logo span.logoMsg {
            font-size: 13px;
        }
        
        .left {
            position: absolute;
            width: 65vw;
            height: 100%;
            top: 0px;
            z-index: -1;
        }
        
        .left img {
            width: 100%;
            height: 100%;
            position: relative;
        }
        
        .right {
            position: absolute;
            top: 135px;
            right: 80px;
            width: 450px;
            height: 460px;
            border: 1px solid #D5D5D5
        }
        
        .right .box {
            position: absolute;
            right: 60px;
            top: 0px;
        }
        
        .inputBox,
        .checkBox {
            width: 350px;
            position: relative;
            margin-top: 20px;
        }
        
        .inputBox input {
            border-radius: 5px;
            width: 95%;
            height: 40px;
            padding: 6px;
        }
        
        .checkBox {
            top: 10px;
            left: 10px;
            position: relative;
        }
        
        .checkBox label {
            height: 24px;
        }
        
        #loginBtn {
            width: 95%;
            position: relative;
            top: 5px;
        }
    </style>
    <script src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/password.js"></script>
    <script>
        //入口函数
        $(function() {

            //给验证码链接添加单击事件
            $("#code a[name='getCheckCode']").click(function () {
                $("#codeImg").attr("src", "${pageContext.request.contextPath}/settings/qx/user/getCheckCode.do?timeTemp=" + new Date().getTime());
            });

            //给登录按钮添加单击事件
            $("#loginBtn").click(function () {
                const username = $.trim($("#username").val());
                let password = $.trim($("#password").val());
                let checkCode = $.trim($("#checkCode").val());
                const isRemPwd = $("#isRemPwd").attr("checked");
                if (username == ""){
                    $("#msg").css("color", "red");
                    $("#msg").text("用户名不能为空!");
                    return;
                }else if (password == ""){
                    $("#msg").css("color", "red");
                    $("#msg").text("密码不能为空");
                    return;
                }else if (checkCode == ""){
                    $("#msg").css("color", "red");
                    $("#msg").text("验证码错误!");
                    $("#codeImg").attr("src", "${pageContext.request.contextPath}/settings/qx/user/getCheckCode.do?timeTemp=" + new Date().getTime());
                    return;
                }
                password = md5(password);
                checkCode = checkCode.toLocaleLowerCase();
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/qx/user/login.do",
                    data:{
                        username:username,
                        password:password,
                        checkCode:checkCode,
                        isRemPwd:isRemPwd
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                            $("#codeImg").attr("src", "${pageContext.request.contextPath}/settings/qx/user/getCheckCode.do?timeTemp=" + new Date().getTime());
                        }else if (data.code == "1"){
                            $("#msg").css("color", "green");
                            $("#msg").text("正在登陆，请稍后...");
                            window.location.href = "${pageContext.request.contextPath}/workbench/index.do";
                        }
                    }
                });
            });

            //添加全局按下确认键事件
            $(window).keydown(function (e) {
                if (e.keyCode == 13){
                    $("#loginBtn").click();
                }
            });
        });
    </script>
</head>

<body>
    <!-- 加载头部 -->
    <div class="top">
        <div class="logo">
            CRM-EX &nbsp;
            <span class="logoMsg">
                ©2022 &nbsp;itCat
            </span>
        </div>
    </div>
    <!-- 加载左边图片 -->
    <div class="left">
        <img src="${pageContext.request.contextPath}/image/IMG_7114.JPG" alt="catLogin">
    </div>
    <!-- 加载右边登录表单 -->
    <div class="right">
        <div class="box">
            <div class="page-header">
                <h1>登录</h1>
            </div>
            <form action="" class="form-horizontal" role="form" method="post">
                <div class="form-group form-group-lg">
                    <div class="inputBox">
                        <input type="text" class="form-control" id="username" placeholder="用户名" maxlength="18" value="${cookie.get("username").value}" >
                    </div>
                    <div class="inputBox">
                        <input type="password" class="form-control" id="password" placeholder="密码" minlength="4" value="${cookie.get("password").value}" maxlength="18">
                    </div>
                    <div class="inputBox">
                        <input id="checkCode" class="form-control" type="text" style="border-radius: 5px;width: 40%;height: 40px;padding: 10px;padding-left: 16px;display:inline-block;" placeholder="验证码">
                        <span id="code" style="height: 50px;width:40%;background-color: #eee8d0;padding: 1px;">
                            <a name="getCheckCode"><img id="codeImg" style="width: 60px;height: 30px;" src="${pageContext.request.contextPath}/settings/qx/user/getCheckCode.do?timeTemp=1"></a>
                            <a name="getCheckCode" style="font-size: 10px;">看不清？换一张</a>
                        </span>
                    </div>
                    <div class="checkBox">
                        <label for="isRemPwd">
                                <input type="checkbox" id="isRemPwd"
                                <c:if test="${not empty(cookie.get('username').value) and not empty(cookie.get('password').value)}">
                                    checked
                                </c:if>
                                > &nbsp;记住密码
                            </label>&nbsp;&nbsp;&nbsp;
                        <span id="msg" style="font-size: 14px;"></span>
                    </div>
                    <div class="inputBox">
                        <input id="loginBtn" type="button" class="btn btn-primary btn-lg btn-block login" value="登录">
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>

</html>