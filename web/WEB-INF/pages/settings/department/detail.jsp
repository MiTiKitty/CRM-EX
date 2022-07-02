<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/jquery/zTree_v3-master/css/zTreeStyle/zTreeStyle.css" type="text/css" rel="stylesheet" />

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
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/zTree_v3-master/js/jquery.ztree.all.min.js"></script>

    <script type="text/javascript">
        let isName = true;
        let isPhone = true;

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
                    $("#oldPwdCheck").prop("checked", false);
                } else if (oldPasswordMd5 != "${sessionScope.sessionUser.password}") {
                    $("#oldPasswordMsg").css("color", "red");
                    $("#oldPasswordMsg").html("密码错误");
                    $("#oldPwdCheck").prop("checked", false);
                } else {
                    $("#oldPasswordMsg").css("color", "green");
                    $("#oldPasswordMsg").html("✓");
                    $("#oldPwdCheck").prop("checked", true);
                }
            });

            //给新密码添加失去焦点事件
            $("#newPwd").blur(function () {
                let newPassword = $.trim($(this).val());
                if (!passwordFormat.test(newPassword)) {
                    $("#newPasswordMsg").css("color", "red");
                    $("#newPasswordMsg").html("密码格式错误");
                    $("#newPwdCheck").prop("checked", false);
                } else {
                    $("#newPasswordMsg").css("color", "green");
                    $("#newPasswordMsg").html("✓");
                    $("#newPwdCheck").prop("checked", true);
                }
            });

            //给确认密码添加失去焦点事件
            $("#confirmPwd").blur(function () {
                let newPassword = $.trim($(this).val());
                let confirmPassword = $.trim($(this).val());
                if (confirmPassword != newPassword) {
                    $("#confirmPasswordMsg").css("color", "red");
                    $("#confirmPasswordMsg").html("前后密码不一致");
                    $("#confirmPwdCheck").prop("checked", false);
                } else {
                    $("#confirmPasswordMsg").css("color", "green");
                    $("#confirmPasswordMsg").html("✓");
                    $("#confirmPwdCheck").prop("checked", true);
                }
            });

            //给确定修改密码添加单击事件
            $("#submitEditPwdBtn").click(function () {
                const isOld = $("#oldPwdCheck").prop("checked");
                const isNew = $("#newPwdCheck").prop("checked");
                const isConfirm = $("#confirmPwdCheck").prop("checked");
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

            //给编辑部门按钮添加单击事件
            $("#openEditBtn").click(function () {
                $("#editDeptModal").modal("show");
            });

            //给部门名称添加失去焦点事件
            $("#edit-deptName").blur(function () {
                const name = $.trim($(this).val());
                if (name == ""){
                    $("#nameMsg").css("color", "red");
                    $("#nameMsg").text("部门名称不能为空!");
                    isName = false;
                }else {
                    $("#nameMsg").css("color", "green");
                    $("#nameMsg").text("✓");
                    isName = true;
                }
            });

            //给电话添加失去焦点事件
            $("#edit-phone").blur(function () {
                const phone = $.trim($(this).val());
                if (!/^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$/.test(phone)){
                    $("#phoneMsg").css("color", "red");
                    $("#phoneMsg").text("请填写正确的电话格式");
                    isPhone = false;
                }else {
                    $("#phoneMsg").css("color", "green");
                    $("#phoneMsg").text("✓");
                    isPhone = true;
                }
            });

            //给更新按钮添加单击事件
            $("#editBtn").click(function () {
                if (!isName || !isPhone){
                    return;
                }
                const number = $("#edit-deptNumber").val();
                const name = $.trim($("#edit-deptName").val());
                const managerId = $("#edit-deptManager").val();
                const description = $.trim($("#edit-description").val());
                const phone = $.trim($("#edit-phone").val());
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/department/editDeptById.do",
                    data:{
                        id:"${requestScope.department.id}",
                        number:number,
                        name:name,
                        managerId:managerId,
                        description:description,
                        phone:phone
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            $("#numberB").text(data.data.number);
                            $("#nameB").text(data.data.name);
                            $("#managerB").text(data.data.manager.name);
                            $("#phoneB").text(data.data.phone);
                            $("#descriptionB").text(data.data.description);
                            $("#editDeptModal").modal("hide");
                        }
                    }
                });
            });

            //给关闭按钮添加单击事件
            $("#closeBtn").click(function () {
                $("#editDeptModal").modal("hide");
            });
        });
    </script>
    
    <title>Document</title>
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
                    <li><a id="workbenchA" href="${pageContext.request.contextPath}/workbench/index.do"><span
                            class="glyphicon glyphicon-home"></span> 工作台</a>
                    </li>
                    <li><a id="settingsA" href="${pageContext.request.contextPath}/settings/index.do"><span
                            class="glyphicon glyphicon-wrench"></span> 系统设置</a>
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

    <!--修改部门-->
    <div class="modal fade" id="editDeptModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 80%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
                    <h4 class="modal-title" id="myModalLabel">修改部门</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-deptNumber" class="col-sm-2 control-label">编号<span style="font-size: 15px; color: red;display: inline-block;width: 6px;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-deptNumber" style="width: 200%;" value="${requestScope.department.number}" readonly>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-deptName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;display: inline-block;width: 6px;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-deptName" style="width: 200%;" value="${requestScope.department.name}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-deptManager" class="col-sm-2 control-label">经理<span style="font-size: 15px; color: red;display: inline-block;width: 6px;"></span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-deptManager">
                                    <c:forEach items="${requestScope.userList}" var="user">
                                        <option value="${user.id}"
                                        <c:if test="${user.id} == ${requestScope.department.manager.id}">
                                            selected
                                        </c:if>
                                        >${user.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-phone" class="col-sm-2 control-label">电话<span style="font-size: 15px; color: red;display: inline-block;width: 6px;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-phone" style="width: 100%;" value="${requestScope.department.phone}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-description" class="col-sm-2 control-label">描述<span style="font-size: 15px; color: red;display: inline-block;width: 6px;"></span></label>
                            <div class="col-sm-10" style="width: 65%;">
                                <textarea class="form-control" rows="3" id="edit-description">${requestScope.department.description}</textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button id="closeBtn" type="button" class="btn btn-default">关闭</button>
                    <button id="editBtn" type="button" class="btn btn-primary">更新</button>
                </div>
            </div>
        </div>
    </div>

    <div>
        <div style="position: relative; margin-left: 30px; top: -10px;">
            <div class="page-header">
                <h3>部门明细 <small>${requestScope.department.name}</small></h3>
            </div>
            <div style="position: relative; height: 50px;top: -72px; margin-left: 90%;">
                <button type="button" class="btn btn-default" onclick="window.location.href='${pageContext.request.contextPath}/settings/department/index.do'"><span class="glyphicon glyphicon-arrow-left"></span> 返回</button>
            </div>
        </div>
    </div>

    <div style="position: relative; margin-left: 60px; top: -50px;">
        <ul id="myTab" class="nav nav-pills">
            <li class="active"><a href="#dept-info" data-toggle="tab">部门信息</a></li>
        </ul>
        <div id="myTabContent" class="tab-content">
            <div class="tab-pane fade in active" id="dept-info">
                <div style="position: relative; top: 20px; margin-left: -30px;">
                    <div style="position: relative; margin-left: 40px; height: 30px; top: 20px;">
                        <div style="width: 300px; color: gray;">编号</div>
                        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;"><b id="numberB">${requestScope.department.number}</b></div>
                        <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                    </div>
                    <div style="position: relative; margin-left: 40px; height: 30px; top: 40px;">
                        <div style="width: 300px; color: gray;">名称</div>
                        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;"><b id="nameB">${requestScope.department.name}</b></div>
                        <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                    </div>
                    <div style="position: relative; margin-left: 40px; height: 30px; top: 40px;margin-top: 20px;">
                        <div style="width: 300px; color: gray;">经理</div>
                        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;"><b id="managerB">${requestScope.department.manager.name}</b></div>
                        <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                    </div>
                    <div style="position: relative; margin-left: 40px; height: 30px; top: 40px;margin-top: 20px;">
                        <div style="width: 300px; color: gray;">电话</div>
                        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;"><b id="phoneB">${requestScope.department.phone}</b></div>
                        <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                    </div>
                    <div style="position: relative; margin-left: 40px; height: 30px; top: 60px;">
                        <div style="width: 300px; color: gray;">描述</div>
                        <div style="width: 200px;position: relative; margin-left: 200px; top: -20px;"><b id="descriptionB">${requestScope.department.description}</b></div>
                        <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                        <button id="openEditBtn" style="position: relative; margin-left: 89%;" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
                    </div>

                </div>
            </div>
        </div>
    </div>
</body>

</html>