<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <script>
        //入口函数
        $(function() {
            $("#loginBtn").click(function() {
                window.location.href = "${pageContext.request.contextPath}/workbench/index.html";
            })
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
                        <input type="text" class="form-control" id="username" placeholder="用户名">
                    </div>
                    <div class="inputBox">
                        <input type="password" class="form-control" id="password" placeholder="密码">
                    </div>
                    <div class="inputBox">
                        <input id="checkCode" class="form-control" type="text" style="border-radius: 5px;width: 40%;height: 40px;padding: 10px;padding-left: 16px;display:inline-block;" placeholder="验证码">
                        <span id="code" style="height: 50px;width:40%;background-color: #eee8d0;padding: 1px;">
                            <a href="">1 2 3 4</a>
                        </span>
                    </div>
                    <div class="checkBox">
                        <label for="remberPassword">
                                <input type="checkbox" id="remberPassword"> &nbsp;记住密码
                            </label>&nbsp;&nbsp;&nbsp;
                        <span id="msg"></span>
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