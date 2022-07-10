<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <meta charset="UTF-8">
    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css"
          type="text/css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"
          type="text/css" rel="stylesheet"/>

    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/password.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_pagination-master/localization/en.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">
        let thePageSize = 10;
        let isCreateUsername = false;
        let isCreateName = false;
        let isCreatePassword = false;
        let isCreateConfirmPwd = false;
        let isCreatePhone = false;
        let isCreateDepartment = false;
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

            //给显示选择列表添加事件
            //效果为，选中要显示的内容和不需要显示的内容
            $("#definedColumns input[type='checkbox']").click(function () {
                const value = $(this).val();
                const isCheck = $(this).prop("checked");
                if (isCheck) {
                    $("#userListT td[name='" + value + "']").show();
                } else {
                    $("#userListT td[name='" + value + "']").hide();
                }
            });

            //实现点击选择查看与否相关数据列表的功能
            $("#definedColumns a").click(function () {
                $(this).children("input[type='checkbox']").click();
            });

            //先分页查出所有用户数据列表
            findUserListByCondition();

            //给查询按钮添加单击事件
            $("#queryBtn").click(function () {
                findUserListByCondition(1, thePageSize);
            });

            //给创建按钮添加单击事件
            $("#createBtn").click(function () {
                $("form").get(0).reset();
                $("#createUserModal").modal("show");
            });

            //给部门输入框添加自动补全功能
            $("#create-department").typeahead({
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
                                isCreateDepartment = false;
                            }
                        }
                    });
                },
                //function中需要传一个item，该item就是返回回来的一个一个json对象
                displayText: function (item) {
                    return item.name + " (" + item.number + ")";
                },
                updater: function (item) {
                    $("#create-departmentId").val(item.id);
                    isCreateDepartment = true;
                    return item;
                }
            });

            //给登录账号输入框添加失去焦点事件
            $("#create-username").blur(function () {
                const username = $.trim($(this).val());
                if (username == '') {
                    $("#usernameMsg").css("color", "red");
                    $("#usernameMsg").text("登录用户名不能为空!");
                    isCreateUsername = false;
                    return;
                }
                $.ajax({
                    url: "${pageContext.request.contextPath}/settings/qx/user/existUserByUsername.do",
                    data: {
                        username: username
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data == 0 || data == "0") {
                            $("#usernameMsg").css("color", "green");
                            $("#usernameMsg").text("✓");
                            isCreateUsername = true;
                        } else {
                            $("#usernameMsg").css("color", "red");
                            $("#usernameMsg").text("登录用户名已存在!");
                            isCreateUsername = false;
                        }
                    }
                });
            });

            //给用户姓名输入框添加失去焦点事件
            $("#create-name").blur(function () {
                const name = $.trim($(this).val());
                if (name == "") {
                    $("#nameMsg").css("color", "red");
                    $("#nameMsg").text("用户姓名不能为空!");
                    isCreateName = false;
                } else {
                    $("#nameMsg").css("color", "green");
                    $("#nameMsg").text("✓");
                    isCreateName = true;
                }
            });

            //给登录密码输入框添加失去焦点事件
            $("#create-password").blur(function () {
                const password = $.trim($(this).val());
                if (!passwordFormat.test(password)) {
                    $("#passwordMsg").css("color", "red");
                    $("#passwordMsg").text("密码格式错误!");
                    isCreatePassword = false;
                } else {
                    $("#passwordMsg").css("color", "green");
                    $("#passwordMsg").text("✓");
                    isCreatePassword = true;
                }
            });

            //给确认密码输入框添加失去焦点事件
            $("#create-confirmPwd").blur(function () {
                const confirmPwd = $.trim($(this).val());
                const password = $("#create-password").val();
                if (confirmPwd != password) {
                    $("#confirmPwdMsg").css("color", "red");
                    $("#confirmPwdMsg").text("前后密码不一致!");
                    isCreateConfirmPwd = false;
                } else {
                    $("#confirmPwdMsg").css("color", "green");
                    $("#confirmPwdMsg").text("✓");
                    isCreateConfirmPwd = true;
                }
            });

            //给联系电话添加失去焦点事件
            $("#create-phone").blur(function () {
                const phone = $.trim($(this).val());
                if (!/^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$/.test(phone)) {
                    $("#phoneMsg").css("color", "red");
                    $("#phoneMsg").text("请填写正确的电话格式");
                    isCreatePhone = false;
                } else {
                    $("#phoneMsg").css("color", "green");
                    $("#phoneMsg").text("✓");
                    isCreatePhone = true;
                }
            });

            //给部门输入框添加失去焦点事件
            $("#create-department").blur(function () {
                if (!isCreateDepartment) {
                    $("#departmentMsg").css("color", "red");
                    $("#departmentMsg").text("部门无效！");
                } else {
                    $("#departmentMsg").css("color", "green");
                    $("#departmentMsg").text("✓");
                }
            });

            //给保存按钮添加单击事件
            $("#saveBtn").click(function () {
                if (!isCreateUsername || !isCreateName || !isCreatePassword || !isCreateConfirmPwd ||
                    !isCreatePhone || !isCreateDepartment) {
                    alert("表单信息有误！");
                    return;
                }
                const username = $.trim($("#create-username").val());
                const name = $.trim($("#create-name").val());
                const password = $.trim($("#create-password").val());
                const email = $.trim($("#create-email").val());
                const phone = $.trim($("#create-phone").val());
                const lockStatus = $("#create-lockStatus").val();
                const departmentId = $("#create-departmentId").val();
                const expireTime = $("#create-expireTime").val();
                const allowIps = $.trim($("#create-allowIps").val());
                $.ajax({
                    url: "${pageContext.request.contextPath}/settings/qx/user/createUser.do",
                    data: {
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
                            findUserListByCondition(1, thePageSize);
                            $("#createUserModal").modal("hide");
                        }
                    }
                });
            });

            //给取消按钮添加单击事件
            $("#closeBtn").click(function () {
                $("#createUserModal").modal("hide");
            });

            //给全选按钮添加单击事件
            $("#allSelectBox").click(function () {
                const isCheck = $(this).prop("checked");
                $("#userList input[type='checkbox']").prop("checked", isCheck);
            });

            //给单个选择按钮添加单击事件
            $("#userList").on("click", "input[type='checkbox']", function () {
                const checkedSize = $("#userList input[type='checkbox']:checked").size();
                const allSize = $("#userList input[type='checkbox']").size();
                if (checkedSize == allSize) {
                    $("#allSelectBox").prop("checked", true);
                } else {
                    $("#allSelectBox").prop("checked", false);
                }
            });

            //给用户账号锁定状态链接添加单击事件
            $("#userList").on("click", "td[name='lockStatus'] a", function () {
                let lockStatus = $(this).attr("name");
                let id = $(this).attr("userId");
                if (lockStatus == "0") {
                    lockStatus = '1';
                } else if (lockStatus == "1") {
                    lockStatus = '0';
                }
                const a = this;
                if (window.confirm("确定要改变该账号的锁定状态吗？")) {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/settings/qx/user/editUserLockStatusById.do",
                        data: {
                            id: id,
                            lockStatus: lockStatus
                        },
                        type: "post",
                        dataType: "json",
                        success: function (data) {
                            if (data.code == "0") {
                                alert(data.message);
                            } else if (data.code == "1") {
                                $(a).html(lockStatus == "1" ? "启用" : "锁定");
                            }
                        }
                    });
                }
            });

            //给删除按钮添加单击事件
            $("#removeBtn").click(function () {
                const selectUsers = $("#userList input[type='checkbox']:checked");
                if (selectUsers.length == 0) {
                    alert("至少需要选中一个！");
                    return;
                }
                const id = new Array();
                $.each(selectUsers, function (index, obj) {
                    id.push(obj.value);
                });
                if (window.confirm("你确定要删除这些用户账号吗？")) {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/settings/qx/user/removeUsersById.do",
                        data: {
                            id: id
                        },
                        type: "post",
                        dataType: "json",
                        traditional: true,
                        success: function (data) {
                            if (data.code == "0") {
                                alert(data.message);
                            } else if (data.code == "1") {
                                findUserListByCondition(1, thePageSize);
                            }
                        }
                    });
                }
            });
        });

        /**
         * 分页条件查询
         * @param userName
         * @param departmentName
         * @param lockStatus
         * @param startTime
         * @param endTime
         * @param pageNo
         * @param pageSize
         */
        function findUserListByConditions(userName, departmentName, lockStatus,
                                          startTime, endTime, pageNo = 1, pageSize = 10) {
            $.ajax({
                url: "${pageContext.request.contextPath}/settings/qx/user/queryUsersByCondition.do",
                data: {
                    userName: userName,
                    departmentName: departmentName,
                    lockStatus: lockStatus,
                    startTime: startTime,
                    endTime: endTime,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    let htmlStr = "";
                    $.each(data.userList, function (index, obj) {
                        let lockStatus = "";
                        if (obj.lockStatus == "1") {
                            lockStatus = "启用";
                        } else {
                            lockStatus = "锁定";
                        }
                        htmlStr += "<tr class=\"active\"><td><input type=\"checkbox\" value='" + obj.id + "'/></td>\n" +
                            "                    <td>" + (index + 1) + "</td>\n" +
                            "                    <td name=\"username\">" + obj.username + "</td>\n" +
                            "                    <td><a href=\"${pageContext.request.contextPath}/settings/qx/user/detail.do?id=" + obj.id + "\">" + obj.name + "</a></td>\n" +
                            "                    <td name=\"departmentName\">" + obj.department.name + "</td>\n" +
                            "                    <td name=\"email\">" + obj.email + "</td>\n" +
                            "                    <td name=\"expireTime\">" + obj.expireTime + "</td>\n" +
                            "                    <td name=\"allowIps\">" + obj.allowIps + "</td>\n" +
                            "                    <td name=\"lockStatus\"><a name='" + obj.lockStatus + "' userId='" + obj.id + "' style='text-decoration: none;'>" + lockStatus + "</a></td>\n" +
                            "                    <td name=\"createBy\">" + obj.createBy + "</td>\n" +
                            "                    <td name=\"createTime\">" + obj.createTime + "</td>\n" +
                            "                    <td name=\"editBy\">" + obj.editBy + "</td>\n" +
                            "                    <td name=\"editTime\">" + obj.editTime + "</td></tr>\n";
                    });
                    $("#userList").html(htmlStr);
                    let totalPages = data.totalRows % pageSize == 0 ? data.totalRows / pageSize : parseInt(data.totalRows / pageSize) + 1;
                    totalPages = data.totalRows == 0 ? 1 : totalPages;
                    $("#pageDiv").bs_pagination({
                        currentPage: pageNo,// 当前页号,相当于pageNo
                        rowsPerPage: pageSize,// 每页显示条数
                        totalRows: data.totalRows,// 总条数
                        visiblePageLinks: 5,// 最多可以显示的卡片数
                        showGoToPage: true,// 是否显示“跳转到”部分,默认是true
                        showRowsPerPage: true,// 是否显示每页显示条数，默认是true
                        showRowsInfo: true,// 是否显示记录的信息，默认是true
                        totalPages: totalPages,// 总页数,必填参数+
                        // 每次切换页号都会执行下面该函数
                        // 每次返回切换页号之后的pageNo和pageSize
                        onChangePage: function (event, pageObj) {
                            thePageSize = pageObj.rowsPerPage;
                            findUserListByCondition(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }

        /**
         * 分页查询
         * @param pageNo
         * @param pageSize
         */
        function findUserListByCondition(pageNo = 1, pageSize = 10) {
            const userName = '%' + $.trim($("#userName").val()) + '%';
            const departmentName = '%' + $.trim($("#departmentName").val()) + '%';
            const lockStatus = $("#lockStatus").val();
            const startTime = $("#startTime").val();
            const endTime = $("#endTime").val();
            if (startTime != '' && endTime != '') {
                if (startTime.localeCompare(endTime) >= 0) {
                    alert("时间前后格式有误！");
                    return;
                }
            }
            findUserListByConditions(userName, departmentName, lockStatus, startTime, endTime, pageNo, pageSize);
        }

    </script>
</head>

<body>

<!-- 创建用户的模态窗口 -->
<div class="modal fade" id="createUserModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">新增用户</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-username" class="col-sm-2 control-label">登录帐号<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-username" maxlength="32">
                            <span id="usernameMsg" style="font-size: 14px;"></span>
                        </div>
                        <label for="create-name" class="col-sm-2 control-label">用户姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name" maxlength="20">
                            <span id="nameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-password" class="col-sm-2 control-label">登录密码<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="create-password" maxlength="32">
                            <span id="passwordMsg" style="font-size: 14px;"></span>
                        </div>
                        <label for="create-confirmPwd" class="col-sm-2 control-label">确认密码<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="create-confirmPwd" maxlength="32">
                            <span id="confirmPwdMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="email" class="form-control" id="create-email">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">联系电话<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone" maxlength="11">
                            <span id="phoneMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-lockStatus" class="col-sm-2 control-label">锁定状态<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-lockStatus">
                                <option value="1">启用</option>
                                <option value="0">锁定</option>
                            </select>
                        </div>
                        <label for="create-department" class="col-sm-2 control-label">部门<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-department"
                                   placeholder="输入部门名称，自动补全" autocomplete="off">
                            <input hidden type="text" id="create-departmentId">
                            <span id="departmentMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-expireTime" class="col-sm-2 control-label">失效时间</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="create-expireTime" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-allowIps" style="width: 280%"
                                   maxlength="255" placeholder="多个用逗号隔开">
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
    <div style="position: relative; margin-left: 30px; top: -10px;">
        <div class="page-header">
            <h3>用户列表</h3>
        </div>
    </div>
</div>

<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; margin-left: 30px; top: -10px;">
    <form class="form-inline" role="form" style="position: relative;top: 8%; margin-left: 5px;">

        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">用户姓名</div>
                <input id="userName" class="form-control" type="text">
            </div>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">部门名称</div>
                <input id="departmentName" class="form-control" type="text">
            </div>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">锁定状态</div>
                <select id="lockStatus" class="form-control">
                    <option value=""></option>
                    <option value="1">启用</option>
                    <option value="0">锁定</option>
                </select>
            </div>
        </div>
        <br><br>
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">失效时间</div>
                <input class="form-control mydate" type="text" id="startTime" readonly/>
            </div>
        </div>

        ~

        <div class="form-group">
            <div class="input-group">
                <input class="form-control mydate" type="text" id="endTime" readonly/>
            </div>
        </div>

        <button id="queryBtn" type="button" class="btn btn-default">查询</button>

    </form>
</div>


<div class="btn-toolbar" role="toolbar"
     style="background-color: #F7F7F7; height: 50px; position: relative; margin-left: 30px; width: 110%; top: 20px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button id="createBtn" type="button" class="btn btn-primary"><span
                class="glyphicon glyphicon-plus"></span> 创建
        </button>
        <button id="removeBtn" type="button" class="btn btn-danger"><span
                class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
    <div class="btn-group" style="position: relative; top: 18%; margin-left: 5px;">
        <button type="button" class="btn btn-default">设置显示字段</button>
        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
            <span class="caret"></span>
            <span class="sr-only">Toggle Dropdown</span>
        </button>
        <ul id="definedColumns" class="dropdown-menu" role="menu">
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="username" checked/> 登录帐号</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="departmentName" checked/> 部门名称</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="email" checked/> 邮箱</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="expireTime" checked/> 失效时间</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="allowIps" checked/> 允许访问IP</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="lockStatus" checked/> 锁定状态</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="createBy" checked/> 创建者</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="createTime" checked/> 创建时间</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="editBy" checked/> 修改者</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="editTime" checked/> 修改时间</a>
            </li>
        </ul>
    </div>
</div>

<div style="position: relative; margin-left: 30px; top: 40px; width: 110%">
    <table class="table table-hover" id="userListT">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input id="allSelectBox" type="checkbox"/></td>
            <td>序号</td>
            <td name="username">登录帐号</td>
            <td>用户姓名</td>
            <td name="departmentName">部门名称</td>
            <td name="email">邮箱</td>
            <td name="expireTime">失效时间</td>
            <td name="allowIps">允许访问IP</td>
            <td name="lockStatus">锁定状态</td>
            <td name="createBy">创建者</td>
            <td name="createTime">创建时间</td>
            <td name="editBy">修改者</td>
            <td name="editTime">修改时间</td>
        </tr>
        </thead>
        <tbody id="userList">
        </tbody>
    </table>
</div>

<div style="height: 50px; position: relative;top: 30px; margin-left: 30px;" id="pageDiv">
</div>

</body>

</html>