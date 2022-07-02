<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
        }

        li {
            list-style: none;
        }

        a {
            text-decoration: none;
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

        .top .userBox {
            padding-top: 10px;
            right: 5px;
            position: absolute;
            width: 150px;
            height: 50px;
            color: azure;
            font-size: 20px;
            font-family: 'times new roman'
        }
    </style>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/password.js"></script>
    <script>
        //入口函数
        $(function () {
            //给我的资料按钮添加单击事件
            $("#myInformationA").click(function () {
                $("#myInformation").modal("show");
            });

            //给我的资料里的关闭按钮添加单击事件
            $("#closeMyInformationBtn").click(function () {
                $("#myInformation").modal("hide");
            });

            //给修改密码按钮添加单击事件
            $("#editPasswordA").click(function () {
                $("from").get(0).reset();
                $("#editPwdModal").modal("show");
            });

            //给关闭修改密码模态窗口按钮添加单击事件
            $("#closeEditPwdBtn").click(function () {
                $("#editPwdModal").modal("hide");
            });

            //给旧密码添加失去焦点事件
            $("#oldPwd").blur(function () {
                let oldPassword = $.trim($(this).val());
                const oldPasswordMd5 = md5(oldPassword);
                if (!passwordFormat.test(oldPassword)) {
                    $("#oldPasswordMsg").css("color", "red");
                    $("#oldPasswordMsg").html("密码格式错误");
                    $("#oldPwdCheck").attr("checked", false);
                } else if (oldPasswordMd5 != "${sessionScope.sessionUser.password}") {
                    $("#oldPasswordMsg").css("color", "red");
                    $("#oldPasswordMsg").html("密码错误");
                    $("#oldPwdCheck").attr("checked", false);
                } else {
                    $("#oldPasswordMsg").css("color", "green");
                    $("#oldPasswordMsg").html("✓");
                    $("#oldPwdCheck").attr("checked", true);
                }
            });

            //给新密码添加失去焦点事件
            $("#newPwd").blur(function () {
                let newPassword = $.trim($(this).val());
                if (!passwordFormat.test(newPassword)) {
                    $("#newPasswordMsg").css("color", "red");
                    $("#newPasswordMsg").html("密码格式错误");
                    $("#newPwdCheck").attr("checked", false);
                } else {
                    $("#newPasswordMsg").css("color", "green");
                    $("#newPasswordMsg").html("✓");
                    $("#newPwdCheck").attr("checked", true);
                }
            });

            //给确认密码添加失去焦点事件
            $("#confirmPwd").blur(function () {
                let newPassword = $.trim($(this).val());
                let confirmPassword = $.trim($(this).val());
                if (confirmPassword != newPassword) {
                    $("#confirmPasswordMsg").css("color", "red");
                    $("#confirmPasswordMsg").html("前后密码不一致");
                    $("#confirmPwdCheck").attr("checked", false);
                } else {
                    $("#confirmPasswordMsg").css("color", "green");
                    $("#confirmPasswordMsg").html("✓");
                    $("#confirmPwdCheck").attr("checked", true);
                }
            });

            //给确定修改密码添加单击事件
            $("#submitEditPwdBtn").click(function () {
                const isOld = $("#oldPwdCheck").attr("checked");
                const isNew = $("#newPwdCheck").attr("checked");
                const isConfirm = $("#confirmPwdCheck").attr("checked");
                if (!isOld || !isNew || !isConfirm) {
                    return;
                }
                let newPassword = $.trim($("#newPwd").val());
                newPassword = md5(newPassword);
                $.ajax({
                    url: "${pageContext.request.contextPath}/settings/qx/user/editUserPasswordById.do",
                    data: {
                        username: "${sessionScope.sessionUser.username}",
                        password: newPassword,
                        id: "${sessionScope.sessionUser.id}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == "1") {
                            window.location.href = "${pageContext.request.contextPath}/settings/toLogin.do"
                        }
                    }
                });
            });

            //给退出系统按钮添加单击事件
            $("#exitA").click(function () {
                $("#exitModal").modal("show");
            });

            //给退出系统的模态窗口中的取消按钮添加单击事件
            $("#closeExitBtn").click(function () {
                $("#exitModal").modal("hide");
            });

            //给退出系统的模态窗口中的确认按钮添加单击事件
            $("#confirmExitBtn").click(function () {
                window.location.href = "${pageContext.request.contextPath}/settings/qx/user/exit.do";
            });
        });
    </script>
</head>

<body>

<!-- 我的资料 -->
<div class="modal fade" id="myInformation" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">我的资料</h4>
            </div>
            <div class="modal-body">
                <div style="position: relative; left: 40px;">
                    姓名：<b>${sessionScope.sessionUser.name}</b><br><br> 登录帐号：
                    <b>${sessionScope.sessionUser.username}</b><br><br> 组织机构：
                    <b>1005，市场部，二级部门</b><br><br> 邮箱：
                    <b>${sessionScope.sessionUser.email}</b><br><br> 失效时间：
                    <b>${sessionScope.sessionUser.expireTime}</b><br><br> 允许访问IP：
                    <b>${sessionScope.sessionUser.allowIps}</b>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改密码的模态窗口 -->
<div class="modal fade" id="editPwdModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 70%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改密码</h4>
            </div>
            <div class="modal-body">
                <form id="" class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="oldPwd" class="col-sm-2 control-label">原密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="checkbox" id="oldPwdCheck" hidden>
                            <input type="password" class="form-control" id="oldPwd" style="width: 200%;">
                            <span id="oldPasswordMsg" class="msg"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="newPwd" class="col-sm-2 control-label">新密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="checkbox" id="newPwdCheck" hidden>
                            <input type="password" class="form-control" id="newPwd" style="width: 200%;">
                            <span id="newPasswordMsg" class="msg"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="checkbox" id="confirmPwdCheck" hidden>
                            <input type="password" class="form-control" id="confirmPwd" style="width: 200%;">
                            <span id="confirmPasswordMsg" class="msg"></span>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button id="closeEditPwdBtn" type="button" class="btn btn-default">取消</button>
                <button id="submitEditPwdBtn" type="button" class="btn btn-primary">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 退出系统的模态窗口 -->
<div class="modal fade" id="exitModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">离开</h4>
            </div>
            <div class="modal-body">
                <p>您确定要退出系统吗？</p>
            </div>
            <div class="modal-footer">
                <button id="closeExitBtn" type="button" class="btn btn-default">取消</button>
                <button id="confirmExitBtn" type="button" class="btn btn-primary">确定</button>
            </div>
        </div>
    </div>
</div>

<!-- 加载头部 -->
<div class="top">
    <div class="logo">
        CRM-EX &nbsp;
        <span class="logoMsg">
                ©2022 &nbsp;itCat
            </span>
    </div>
    <div class="userBox">
        <ul>
            <li class="dropdown user-dropdown">
                <a href="javascript:void(0)" style="text-decoration: none;color: white;" class="dropdown-toggle"
                   data-toggle="dropdown">
                    <span class="glyphicon glyphicon-user"></span> ${sessionScope.sessionUser.name} <span class="caret"></span>
                </a>
                <ul class="dropdown-menu" style="min-width: 150px;">
                    <li><a id="workbenchA" href="${pageContext.request.contextPath}/workbench/index.do"><span class="glyphicon glyphicon-home"></span> 工作台</a>
                    </li>
                    <li><a id="myInformationA" href="javascript:void(0)"><span class="glyphicon glyphicon-file"></span>
                        我的资料</a></li>
                    <li><a id="editPasswordA" href="javascript:void(0)"><span class="glyphicon glyphicon-edit"></span>
                        修改密码</a></li>
                    <li><a id="exitA" href="javascript:void(0);"><span class="glyphicon glyphicon-off"></span> 退出</a>
                    </li>
                </ul>
            </li>
        </ul>
    </div>
</div>

<!-- 加载中间 -->
<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">
    <div style="position: relative; top: 30px; width: 60%; height: 100px; margin: auto;">
        <div class="page-header">
            <h3>系统设置</h3>
        </div>
    </div>
    <div style="position: relative; width: 55%; height: 70%; margin: auto;">
        <div style="position: relative; width: 33%; height: 50%;">
            常规
            <br><br>
            <a href="javascript:void(0);">个人设置</a>
        </div>
        <div style="position: relative; width: 33%; height: 50%;">
            安全控制
            <br><br>
            <a href="" style="text-decoration: none; color: red;">组织机构</a>
            <br>
            <a href="${pageContext.request.contextPath}/settings/department/index.do">部门管理</a>
            <br>
            <a href="${pageContext.request.contextPath}/settings/qx/index.do">权限管理</a>
        </div>

        <div style="position: relative; width: 33%; height: 50%; left: 33%; top: -100%">
            定制
            <br><br>
            <a href="javascript:void(0);">模块</a>
            <br>
            <a href="javascript:void(0);">模板</a>
            <br>
            <a href="javascript:void(0);">定制内容复制</a>
        </div>
        <div style="position: relative; width: 33%; height: 50%; left: 33%; top: -100%">
            自动化
            <br><br>
            <a href="javascript:void(0);">工作流自动化</a>
            <br>
            <a href="javascript:void(0);">计划</a>
            <br>
            <a href="javascript:void(0);">Web表单</a>
            <br>
            <a href="javascript:void(0);">分配规则</a>
            <br>
            <a href="javascript:void(0);">服务支持升级规则</a>
        </div>

        <div style="position: relative; width: 34%; height: 50%;  left: 66%; top: -200%">
            扩展及API
            <br><br>
            <a href="javascript:void(0);">API</a>
            <br>
            <a href="javascript:void(0);">其它的</a>
        </div>
        <div style="position: relative; width: 34%; height: 50%; left: 66%; top: -200%">
            数据管理
            <br><br>
            <a href="${pageContext.request.contextPath}/settings/dictionary/index.do">数据字典表</a>
            <br>
            <a href="javascript:void(0);">导入</a>
            <br>
            <a href="javascript:void(0);">导出</a>
            <br>
            <a href="javascript:void(0);">存储</a>
            <br>
            <a href="javascript:void(0);">回收站</a>
            <br>
            <a href="javascript:void(0);">审计日志</a>
        </div>
    </div>
</div>
</body>

</html>