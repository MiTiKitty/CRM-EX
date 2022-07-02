<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

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

    <script type="text/javascript">
        let isNum = false;
        let isName = false;
        let isPhone = false;
        //页面加载完毕
        $(function() {
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

            //给创建部门按钮添加单击事件
            $("#createBtn").click(function () {
                $("#createDeptModal").modal("show");
            });

            //给部门编号添加失去焦点事件
            $("#create-deptNumber").blur(function () {
                const number = $.trim($(this).val());
                if (number.length > 4){
                    $("#numberMsg").css("color", "red");
                    $("#numberMsg").text("✕");
                    isNum = false;
                    return;
                }
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/department/queryDeptByNumber.do",
                    data:{
                        number:number
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            $("#numberMsg").css("color", "green");
                            $("#numberMsg").text("✓");
                            isNum = true;
                        }else if (data.code == "1"){
                            $("#numberMsg").css("color", "red");
                            $("#numberMsg").text("当前编号已存在");
                            isNum = false;
                        }
                    }
                });
            });

            //给部门名称添加失去焦点事件
            $("#create-deptName").blur(function () {
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
            $("#create-phone").blur(function () {
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

            //给保存按钮添加单击事件
            $("#saveBtn").click(function () {
                if (!isNum || !isName || !isPhone){
                    return;
                }
                const number = $.trim($("#create-deptNumber").val());
                const name = $.trim($("#create-deptName").val());
                const managerId = $("#create-deptManager").val();
                const description = $.trim($("#create-description").val());
                const phone = $.trim($("#create-phone").val());
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/department/createDept.do",
                    data:{
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
                            let htmlStr = "<tr class=\"active\">\n" +
                                "                            <td><input type=\"checkbox\" value=\""+data.data.id+"\"/></td>\n" +
                                "                            <td><a href='${pageContext.request.contextPath}/settings/department/detail.do?id="+data.data.id+"' style=\"text-decoration: none; cursor: pointer;\">"+data.data.number+"</a></td>\n" +
                                "                            <td><a href='${pageContext.request.contextPath}/settings/department/detail.do?id="+data.data.id+"' style=\"text-decoration: none; cursor: pointer;\">"+data.data.name+"</a></td>\n" +
                                "                            <td><a style=\"text-decoration: none; cursor: pointer;\">"+data.data.manager.name+"</a></td>\n" +
                                "                            <td>"+data.data.phone+"</td>\n" +
                                "                        </tr>";
                            $("#deptList").append(htmlStr);
                            $("#createDeptModal").modal("hide");
                        }
                    }
                });
            });

            //给关闭按钮添加单击事件
            $("#closeBtn").click(function () {
                $("#createDeptModal").modal("hide");
            });

            //给全选按钮添加单击事件
            $("#allSelectBox").click(function () {
                const isCheck = $(this).prop("checked");
                $("#deptList input[type='checkbox']").prop("checked", isCheck);
            });

            //给单个选择按钮添加单击事件
            $("#deptList").on("click", "input[type='checkbox']", function () {
                const checkedSize = $("#deptList input[type='checkbox']:checked").size();
                const allSize = $("#deptList input[type='checkbox']").size();
                if (checkedSize == allSize){
                    $("#allSelectBox").prop("checked", true);
                }else {
                    $("#allSelectBox").prop("checked", false);
                }
            });

            //给删除按钮添加单击事件
            $("#removeBtn").click(function () {
                const checker = $("#deptList input[type='checkbox']:checked");
                if (checker.length == 0){
                    alert("至少选择一个进行删除!");
                    return;
                }
                let id = new Array();
                for (let i = 0; i < checker.length; i++) {
                    id.push(checker[i].value);
                }
                if (window.confirm("确定要删除吗?")){
                    $.ajax({
                        url:"${pageContext.request.contextPath}/settings/department/removeDeptByIds.do",
                        data:{
                            id:id
                        },
                        type:"post",
                        dataType:"json",
                        traditional:true,
                        success:function (data) {
                            if (data.code == "0"){
                                alert(data.message);
                            }else if (data.code == "1"){
                                for (let i = 0; i < checker.length; i++) {
                                    $("#tr-" + checker[i].value).remove();
                                }
                            }
                        }
                    });
                }
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

    <!-- 创建部门的模态窗口 -->
    <div class="modal fade" id="createDeptModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 80%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
                    <h4 class="modal-title" id="myModalLabel">新增部门</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="create-deptNumber" class="col-sm-2 control-label">编号<span style="font-size: 15px; color: red;display: inline-block;width: 6px;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-deptNumber" maxlength="4" style="width: 200%;">
                                <span id="numberMsg" style="font-size: 14px;"></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="create-deptName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;display: inline-block;width: 6px;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-deptName" style="width: 200%;">
                                <span id="nameMsg" style="font-size: 14px;"></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="create-deptManager" class="col-sm-2 control-label">经理<span style="font-size: 15px; color: red;display: inline-block;width: 6px;"></span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="create-deptManager">
                                    <c:forEach items="${requestScope.userList}" var="user">
                                        <option value="${user.id}">${user.name}</option>
                                    </c:forEach>
                                  </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="create-phone" class="col-sm-2 control-label">电话<span style="font-size: 15px; color: red;display: inline-block;width: 6px;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-phone" maxlength="11" style="width: 100%;">
                                <span id="phoneMsg" style="font-size: 14px;"></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="create-description" class="col-sm-2 control-label">描述<span style="font-size: 15px; color: red;display: inline-block;width: 6px;"></span></label>
                            <div class="col-sm-10" style="width: 65%;">
                                <textarea class="form-control" rows="3" id="create-description"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button id="closeBtn" type="button" class="btn btn-default">关闭</button>
                    <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
                </div>
            </div>
        </div>
    </div>

    <div>
        <div style="position: relative; margin-left: 10px; top: -10px;">
            <div class="page-header">
                <h3>部门列表</h3>
            </div>
        </div>
    </div>
    <div style="position: relative; top: -20px; margin-left: 0px; width: 100%;">
        <div style="width: 100%; position: absolute;top: 5px; padding-left: 35px;">

            <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
                <div class="btn-group" style="position: relative; top: 18%;">
                    <button id="createBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                    <button id="removeBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
                </div>
            </div>
            <div style="position: relative;top: 10px;">
                <table class="table table-hover">
                    <thead>
                        <tr style="color: #B3B3B3;">
                            <td><input id="allSelectBox" type="checkbox" /></td>
                            <td>编号</td>
                            <td>名称</td>
                            <td>经理</td>
                            <td>电话</td>
                        </tr>
                    </thead>
                    <tbody id="deptList">
                    <c:forEach items="${requestScope.departmentList}" var="dept">
                        <tr class="active" id="tr-${dept.id}">
                            <td><input type="checkbox" value="${dept.id}"/></td>
                            <td><a href="${pageContext.request.contextPath}/settings/department/detail.do?id=${dept.id}" style="text-decoration: none; cursor: pointer;">${dept.number}</a></td>
                            <td><a href="${pageContext.request.contextPath}/settings/department/detail.do?id=${dept.id}" style="text-decoration: none; cursor: pointer;">${dept.name}</a></td>
                            <td><a style="text-decoration: none; cursor: pointer;">${dept.manager.name}</a></td>
                            <td>${dept.phone}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

        </div>

    </div>
</body>

</html>