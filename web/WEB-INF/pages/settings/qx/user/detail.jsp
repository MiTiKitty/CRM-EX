<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <meta charset="UTF-8">
    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/jquery/zTree_v3-master/css/zTreeStyle/zTreeStyle.css" type="text/css"
          rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css"
          type="text/css" rel="stylesheet"/>

    <style>
        #role-info b {
            display: inline-block;
            min-height: 20px;
        }
    </style>

    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/zTree_v3-master/js/jquery.ztree.all.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/password.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>


    <script type="text/javascript">
        let isEditName = true;
        let isEditPassword = false;
        let isEditConfirmPwd = false;
        let isEditPhone = true;
        let isEditDepartment = true;
        const passwordFormat = /^[a-zA-Z0-9_-]{1,16}$/;

        $(function () {
            //安排日期时间选择
            $(".mydate").datetimepicker({
                language: 'zh-CN',
                weekStart: 1,
                todayBtn: 1,
                autoclose: 1,
                todayHighlight: 1,
                startView: 2,
                maxView: 4,
                forceParse: 0,
                showMeridian: 1,
                clearBtn: true
            });

            const setting = {
                data: {
                    simpleData: {
                        enable: true
                    }
                }
            };

            //给用户信息单链接添加单击事件
            $("#userDetailA").click(function () {
                $.ajax({
                    url: "${pageContext.request.contextPath}/settings/qx/user/queryUserDetailById.do",
                    data: {
                        id: "${requestScope.userId}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        $("#usernameB").text(data.username);
                        $("#nameB").text(data.name);
                        $("#myNameB").text(data.name);
                        $("#emailB").text(data.email);
                        $("#phoneB").text(data.phone);
                        $("#expireTimeB").text(data.expireTime);
                        if (data.lockStatus == '1') {
                            $("#lockStatusB").text('开启');
                        } else {
                            $("#lockStatusB").text('锁定');
                        }
                        $("#allowIpsB").text(data.allowIps);
                        $("#departmentNameB").text(data.department.name);

                        $("#edit-username").val(data.username);
                        $("#edit-name").val(data.name);
                        $("#edit-email").val(data.email);
                        $("#edit-phone").val(data.phone);
                        $("#edit-lockStatus").val(data.lockStatus);
                        $("#edit-department").val(data.department.name + "(" + data.department.number + ")");
                        $("#edit-departmentId").val(data.department.id);
                        $("#edit-expireTime").val(data.expireTime);
                        $("#edit-allowIps").val(data.allowIps);
                        $("#edit-lockStatus").val(data.lockStatus);
                    }
                });
            });

            //给许可信息单链接添加单击事件
            $("#userPermissionA").click(function () {
                $.ajax({
                    url: "${pageContext.request.contextPath}/settings/qx/user/queryUserPermission.do",
                    data: {
                        userId: "${requestScope.userId}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        const tree = $.fn.zTree.getZTreeObj("treeDemo");
                        if (tree != null) {
                            tree.destroy();
                        }
                        let zNodes = new Array();
                        $.each(data, function (index, obj) {
                            zNodes.push({
                                id: obj.id,
                                pId: obj.pid,
                                name: obj.name,
                                open: true
                            });
                        });
                        $.fn.zTree.init($("#treeDemo"), setting, zNodes);
                    }
                });
            });

            //先触发用户单击事件
            $("#userDetailA").click();

            //给编辑按钮添加单击事件
            $("#editBtn").click(function () {
                $("#editUserModal").modal("show");
            });

            //给部门输入框添加自动补全功能
            $("#edit-department").typeahead({
                //配置minLength
                minLength: 1,//最少输入字符串
                items: 5,//最多显示的下拉列表内容
                //1、先配置数据源(可以先不配置数据源，先配置其他东西)
                source: function (query, process) {//第一个为正在查询的值，第二个参数为函数(该函数)
                    //使用Ajax加载数据源
                    return $.ajax({
                        url: "${pageContext.request.contextPath}/settings/department/queryDepartmentsByName.do",
                        //查询的数据(name为query)
                        data: {
                            name: '%' + query + '%'
                        },
                        type: "post",
                        dataType: "json",
                        //data为一个Json对象的数组
                        success: function (data) {
                            //如果数据有长度,就交给typeaheader显示列表
                            if (data && data.length) {
                                //process为获得数据之后用来调用的方法(方法之后,下拉列表的内容就可以呈现了)
                                process(data);
                            } else {
                                isEditDepartment = false;
                            }
                        }
                    });
                },
                //function中需要传一个item，该item就是返回回来的一个一个json对象
                displayText: function (item) {
                    return item.name + " (" + item.number + ")";
                },
                updater: function (item) {
                    $("#edit-departmentId").val(item.id);
                    isEditDepartment = true;
                    return item;
                }
            });

            //给用户姓名输入框添加失去焦点事件
            $("#edit-name").blur(function () {
                const name = $.trim($(this).val());
                if (name == "") {
                    $("#nameMsg").css("color", "red");
                    $("#nameMsg").text("用户姓名不能为空!");
                    isEditName = false;
                } else {
                    $("#nameMsg").css("color", "green");
                    $("#nameMsg").text("✓");
                    isEditName = true;
                }
            });

            //给登录密码输入框添加失去焦点事件
            $("#edit-password").blur(function () {
                const password = $.trim($(this).val());
                if (!passwordFormat.test(password)) {
                    $("#passwordMsg").css("color", "red");
                    $("#passwordMsg").text("密码格式错误!");
                    isEditPassword = false;
                } else {
                    $("#passwordMsg").css("color", "green");
                    $("#passwordMsg").text("✓");
                    isEditPassword = true;
                }
            });

            //给确认密码输入框添加失去焦点事件
            $("#edit-confirmPwd").blur(function () {
                const confirmPwd = $.trim($(this).val());
                const password = $("#edit-password").val();
                if (confirmPwd != password) {
                    $("#confirmPwdMsg").css("color", "red");
                    $("#confirmPwdMsg").text("前后密码不一致!");
                    isEditConfirmPwd = false;
                } else {
                    $("#confirmPwdMsg").css("color", "green");
                    $("#confirmPwdMsg").text("✓");
                    isEditConfirmPwd = true;
                }
            });

            //给联系电话添加失去焦点事件
            $("#edit-phone").blur(function () {
                const phone = $.trim($(this).val());
                if (!/^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$/.test(phone)) {
                    $("#phoneMsg").css("color", "red");
                    $("#phoneMsg").text("请填写正确的电话格式");
                    isEditPhone = false;
                } else {
                    $("#phoneMsg").css("color", "green");
                    $("#phoneMsg").text("✓");
                    isEditPhone = true;
                }
            });

            //给部门输入框添加失去焦点事件
            $("#edit-department").blur(function () {
                if (!isEditDepartment) {
                    $("#departmentMsg").css("color", "red");
                    $("#departmentMsg").text("部门无效！");
                } else {
                    $("#departmentMsg").css("color", "green");
                    $("#departmentMsg").text("✓");
                }
            });

            //给更新按钮添加单击事件
            $("#confirmEditBtn").click(function () {
                if (!isEditName || !isEditPassword || !isEditConfirmPwd ||
                    !isEditPhone || !isEditDepartment) {
                    alert("表单填写有误！");
                    return;
                }
                const username = $.trim($("#edit-username").val());
                const name = $.trim($("#edit-name").val());
                const password = $.trim($("#edit-password").val());
                const email = $.trim($("#edit-email").val());
                const phone = $.trim($("#edit-phone").val());
                const lockStatus = $("#edit-lockStatus").val();
                const departmentId = $("#edit-departmentId").val();
                const expireTime = $("#edit-expireTime").val();
                const allowIps = $.trim($("#edit-allowIps").val());
                $.ajax({
                    url: "${pageContext.request.contextPath}/settings/qx/user/editUser.do",
                    data: {
                        id: "${requestScope.userId}",
                        username: username,
                        name: name,
                        password: md5(password),
                        email: email,
                        phone: phone,
                        lockStatus: lockStatus,
                        departmentId: departmentId,
                        expireTime: expireTime,
                        allowIps: allowIps
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == "1") {
                            $("#usernameB").text(data.data.username);
                            $("#nameB").text(data.data.name);
                            $("#myNameB").text(data.data.name);
                            $("#emailB").text(data.data.email);
                            $("#phoneB").text(data.data.phone);
                            $("#expireTimeB").text(data.data.expireTime);
                            if (data.data.lockStatus == '1') {
                                $("#lockStatusB").text('开启');
                            } else {
                                $("#lockStatusB").text('锁定');
                            }
                            $("#allowIpsB").text(data.data.allowIps);
                            $("#departmentNameB").text(data.data.department.name);
                            $("#editUserModal").modal("hide");
                        }
                    }
                });
            });

            //给取消按钮添加单击事件
            $("#closeEditBtn").click(function () {
                $("#editUserModal").modal("hide");
            });

            //给分配角色按钮添加单击事件
            $("#allotRoleBtn").click(function () {
                $.ajax({
                    url: "${pageContext.request.contextPath}/settings/qx/user/queryUserRole.do",
                    data: {
                        userId: "${requestScope.userId}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        let srcListHtmlStr = "";
                        $.each(data.allotRoleList, function (index, obj) {
                            srcListHtmlStr += "<option value='" + obj.id + "'>" + obj.name + "</option>\n";
                        });
                        $("#srcList").html(srcListHtmlStr);
                        let destListHtmlStr = "";
                        $.each(data.annulRoleList, function (index, obj) {
                            destListHtmlStr += "<option value='" + obj.id + "'>" + obj.name + "</option>\n";
                        });
                        $("#destList").html(destListHtmlStr);
                        $("#assignRoleForUserModal").modal("show");
                    }
                });
            });

            //给用户分配角色按钮添加单击事件
            $("#allotRolesA").click(function () {
                const roleIds = new Array();
                const option = $("#srcList option:selected");
                if (option.length == 0){
                    alert("至少需要选择一个进行角色分配");
                    return;
                }
                $.each(option, function (index, obj) {
                    if (obj.selected){
                        roleIds.push(obj.value);
                    }
                });
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/qx/user/allotRoleForUser.do",
                    data:{
                        userId:"${requestScope.userId}",
                        roleIds:roleIds
                    },
                    type:"post",
                    dataType:"json",
                    traditional:true,
                    success:function (data) {
                        if (data.code == '0'){
                            alert(data.message);
                        }else if (data.code == '1'){
                            $(option).remove();
                            $("#destList").append(option);
                            $("#userPermissionA").click();
                        }
                    }
                });
            });

            //给用户撤销角色分配按钮添加单击事件
            $("#annulRolesA").click(function () {
                const roleIds = new Array();
                const option = $("#destList option:selected");
                if (option.length == 0){
                    alert("至少需要选择一个进行角色分配");
                    return;
                }
                $.each(option, function (index, obj) {
                    if (obj.selected){
                        roleIds.push(obj.value);
                    }
                });
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/qx/user/annulRoleForUser.do",
                    data:{
                        userId:"${requestScope.userId}",
                        roleIds:roleIds
                    },
                    type:"post",
                    dataType:"json",
                    traditional:true,
                    success:function (data) {
                        if (data.code == '0'){
                            alert(data.message);
                        }else if (data.code == '1'){
                            $(option).remove();
                            $("#srcList").append(option);
                            $("#userPermissionA").click();
                        }
                    }
                });
            });

            //给关闭分配角色按钮添加单击事件
            $("#closeAllotRoleBtn").click(function () {
                $("#assignRoleForUserModal").modal("hide");
            });
        });
    </script>

</head>

<body>

<!-- 分配角色的模态窗口 -->
<div class="modal fade" id="assignRoleForUserModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">为<b id="myNameB"></b>分配角色</h4>
            </div>
            <div class="modal-body">
                <table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                        <td width="42%">
                            <div class="list_tit" style="border: solid 1px #D5D5D5; background-color: #F4F4B5;">
                                未分配角色列表
                            </div>
                        </td>
                        <td width="15%">
                            &nbsp;
                        </td>
                        <td width="43%">
                            <div class="list_tit" style="border: solid 1px #D5D5D5; background-color: #F4F4B5;">
                                已分配角色列表
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <select size="15" name="srcList" id="srcList" style="width: 100%" multiple="multiple">
                            </select>
                        </td>
                        <td>
                            <p align="center">
                                <a id="allotRolesA" href="javascript:void(0);" title="分配角色"><span
                                        class="glyphicon glyphicon-chevron-right" style="font-size: 20px;"></span></a>
                            </p>
                            <br><br>
                            <p align="center">
                                <a id="annulRolesA" href="javascript:void(0);" title="撤销角色"><span
                                        class="glyphicon glyphicon-chevron-left" style="font-size: 20px;"></span></a>
                            </p>
                        </td>
                        <td>
                            <select name="destList" size="15" multiple="multiple" id="destList" style="width: 100%">
                            </select>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="modal-footer">
                <button id="closeAllotRoleBtn" type="button" class="btn btn-default">关闭</button>
            </div>
        </div>
    </div>
</div>

<!-- 编辑用户的模态窗口 -->
<div class="modal fade" id="editUserModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改用户</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-username" class="col-sm-2 control-label">登录帐号<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-username" value="" readonly>
                        </div>
                        <label for="edit-name" class="col-sm-2 control-label">用户姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" value="">
                            <span id="nameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-password" class="col-sm-2 control-label">登录密码<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="edit-password" value="">
                            <span id="passwordMsg" style="font-size: 14px;"></span>
                        </div>
                        <label for="edit-confirmPwd" class="col-sm-2 control-label">确认密码<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="edit-confirmPwd" value="">
                            <span id="confirmPwdMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">联系电话<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="">
                            <span id="phoneMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-lockStatus" class="col-sm-2 control-label">锁定状态<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-lockStatus">
                                <option value="1">启用</option>
                                <option value="0">锁定</option>
                            </select>
                        </div>
                        <label for="edit-department" class="col-sm-2 control-label">部门名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-department" placeholder="输入部门名称，自动补全"
                                   value="">
                            <input hidden id="edit-departmentId" type="text">
                            <span id="departmentMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-expireTime" class="col-sm-2 control-label">失效时间</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="edit-expireTime"
                                   value="" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="edit-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-allowIps" style="width: 280%"
                                   placeholder="多个用逗号隔开" value="" maxlength="255">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button id="closeEditBtn" type="button" class="btn btn-default">关闭</button>
                <button id="confirmEditBtn" type="button" class="btn btn-primary">更新</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative;margin-left: 45px; top: -10px;">
        <div class="page-header">
            <h3>用户明细 <small>张三</small></h3>
        </div>
        <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 80%;">
            <button type="button" class="btn btn-default" onclick="window.history.back();"><span
                    class="glyphicon glyphicon-arrow-left"></span> 返回
            </button>
        </div>
    </div>
</div>


<div style="position: relative; margin-left: 60px; top: -50px;">
    <ul id="myTab" class="nav nav-pills">
        <li class="active"><a id="userDetailA" href="#role-info" data-toggle="tab">用户信息</a></li>
        <li><a id="userPermissionA" href="#permission-info" data-toggle="tab">许可信息</a></li>
    </ul>
    <div id="myTabContent" class="tab-content">
        <div class="tab-pane fade in active" id="role-info">

            <div style="position: relative; top: 20px; left: -30px;">

                <div style="position: relative; margin-left: 40px; height: 30px; top: 20px;">
                    <div style="width: 300px; color: gray;">登录帐号</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="usernameB"></b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; margin-left: 40px; height: 30px; top: 40px;">
                    <div style="width: 300px; color: gray;">用户姓名</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="nameB"></b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; margin-left: 40px; height: 30px; top: 60px;">
                    <div style="width: 300px; color: gray;">邮箱</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="emailB"></b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; margin-left: 40px; height: 30px; top: 80px;">
                    <div style="width: 300px; color: gray;">联系电话</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="phoneB"></b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; margin-left: 40px; height: 30px; top: 100px;">
                    <div style="width: 300px; color: gray;">失效时间</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="expireTimeB"></b>
                    </div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; margin-left: 40px; height: 30px; top: 120px;">
                    <div style="width: 300px; color: gray;">允许访问IP</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="allowIpsB"></b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; margin-left: 40px; height: 30px; top: 140px;">
                    <div style="width: 300px; color: gray;">锁定状态</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="lockStatus"></b></div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                </div>
                <div style="position: relative; margin-left: 40px; height: 30px; top: 160px;">
                    <div style="width: 300px; color: gray;">部门名称</div>
                    <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="departmentNameB"></b>
                    </div>
                    <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                    <button id="editBtn" style="position: relative; left: 76%; top: -40px;" type="button"
                            class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑
                    </button>
                </div>
            </div>

        </div>

        <div class="tab-pane fade" id="permission-info">
            <div style="position: relative; top: 20px; left: 0px;">
                <ul id="treeDemo" class="ztree" style="position: relative; top: 15px; margin-left: 15px;"></ul>
                <div style="position: relative;top: 30px; margin-left: 76%;">
                    <button id="allotRoleBtn" type="button" class="btn btn-default">
                        <span class="glyphicon glyphicon-edit"></span> 分配角色
                    </button>
                </div>
            </div>
        </div>

    </div>
</div>

</body>

</html>