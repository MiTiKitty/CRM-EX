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
            //????????????????????????
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

            //?????????????????????????????????
            //???????????????????????????????????????????????????????????????
            $("#definedColumns input[type='checkbox']").click(function () {
                const value = $(this).val();
                const isCheck = $(this).prop("checked");
                if (isCheck) {
                    $("#userListT td[name='" + value + "']").show();
                } else {
                    $("#userListT td[name='" + value + "']").hide();
                }
            });

            //?????????????????????????????????????????????????????????
            $("#definedColumns a").click(function () {
                $(this).children("input[type='checkbox']").click();
            });

            //???????????????????????????????????????
            findUserListByCondition();

            //?????????????????????????????????
            $("#queryBtn").click(function () {
                findUserListByCondition(1, thePageSize);
            });

            //?????????????????????????????????
            $("#createBtn").click(function () {
                $("form").get(0).reset();
                $("#createUserModal").modal("show");
            });

            //??????????????????????????????????????????
            $("#create-department").typeahead({
                //??????minLength
                minLength: 1,//?????????????????????
                items: 5,//?????????????????????????????????
                //1?????????????????????(???????????????????????????????????????????????????)
                source: function (query, process) {//?????????????????????????????????????????????????????????(?????????)
                    //??????Ajax???????????????
                    return $.ajax({
                        url: "${pageContext.request.contextPath}/settings/department/queryDepartmentsByName.do",
                        //???????????????(name???query)
                        data: {
                            name: '%' + query + '%'
                        },
                        type: "post",
                        dataType: "json",
                        //data?????????Json???????????????
                        success: function (data) {
                            //?????????????????????,?????????typeaheader????????????
                            if (data && data.length) {
                                //process??????????????????????????????????????????(????????????,???????????????????????????????????????)
                                process(data);
                            } else {
                                isCreateDepartment = false;
                            }
                        }
                    });
                },
                //function??????????????????item??????item?????????????????????????????????json??????
                displayText: function (item) {
                    return item.name + " (" + item.number + ")";
                },
                updater: function (item) {
                    $("#create-departmentId").val(item.id);
                    isCreateDepartment = true;
                    return item;
                }
            });

            //????????????????????????????????????????????????
            $("#create-username").blur(function () {
                const username = $.trim($(this).val());
                if (username == '') {
                    $("#usernameMsg").css("color", "red");
                    $("#usernameMsg").text("???????????????????????????!");
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
                            $("#usernameMsg").text("???");
                            isCreateUsername = true;
                        } else {
                            $("#usernameMsg").css("color", "red");
                            $("#usernameMsg").text("????????????????????????!");
                            isCreateUsername = false;
                        }
                    }
                });
            });

            //????????????????????????????????????????????????
            $("#create-name").blur(function () {
                const name = $.trim($(this).val());
                if (name == "") {
                    $("#nameMsg").css("color", "red");
                    $("#nameMsg").text("????????????????????????!");
                    isCreateName = false;
                } else {
                    $("#nameMsg").css("color", "green");
                    $("#nameMsg").text("???");
                    isCreateName = true;
                }
            });

            //????????????????????????????????????????????????
            $("#create-password").blur(function () {
                const password = $.trim($(this).val());
                if (!passwordFormat.test(password)) {
                    $("#passwordMsg").css("color", "red");
                    $("#passwordMsg").text("??????????????????!");
                    isCreatePassword = false;
                } else {
                    $("#passwordMsg").css("color", "green");
                    $("#passwordMsg").text("???");
                    isCreatePassword = true;
                }
            });

            //????????????????????????????????????????????????
            $("#create-confirmPwd").blur(function () {
                const confirmPwd = $.trim($(this).val());
                const password = $("#create-password").val();
                if (confirmPwd != password) {
                    $("#confirmPwdMsg").css("color", "red");
                    $("#confirmPwdMsg").text("?????????????????????!");
                    isCreateConfirmPwd = false;
                } else {
                    $("#confirmPwdMsg").css("color", "green");
                    $("#confirmPwdMsg").text("???");
                    isCreateConfirmPwd = true;
                }
            });

            //???????????????????????????????????????
            $("#create-phone").blur(function () {
                const phone = $.trim($(this).val());
                if (!/^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$/.test(phone)) {
                    $("#phoneMsg").css("color", "red");
                    $("#phoneMsg").text("??????????????????????????????");
                    isCreatePhone = false;
                } else {
                    $("#phoneMsg").css("color", "green");
                    $("#phoneMsg").text("???");
                    isCreatePhone = true;
                }
            });

            //??????????????????????????????????????????
            $("#create-department").blur(function () {
                if (!isCreateDepartment) {
                    $("#departmentMsg").css("color", "red");
                    $("#departmentMsg").text("???????????????");
                } else {
                    $("#departmentMsg").css("color", "green");
                    $("#departmentMsg").text("???");
                }
            });

            //?????????????????????????????????
            $("#saveBtn").click(function () {
                if (!isCreateUsername || !isCreateName || !isCreatePassword || !isCreateConfirmPwd ||
                    !isCreatePhone || !isCreateDepartment) {
                    alert("?????????????????????");
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

            //?????????????????????????????????
            $("#closeBtn").click(function () {
                $("#createUserModal").modal("hide");
            });

            //?????????????????????????????????
            $("#allSelectBox").click(function () {
                const isCheck = $(this).prop("checked");
                $("#userList input[type='checkbox']").prop("checked", isCheck);
            });

            //???????????????????????????????????????
            $("#userList").on("click", "input[type='checkbox']", function () {
                const checkedSize = $("#userList input[type='checkbox']:checked").size();
                const allSize = $("#userList input[type='checkbox']").size();
                if (checkedSize == allSize) {
                    $("#allSelectBox").prop("checked", true);
                } else {
                    $("#allSelectBox").prop("checked", false);
                }
            });

            //???????????????????????????????????????????????????
            $("#userList").on("click", "td[name='lockStatus'] a", function () {
                let lockStatus = $(this).attr("name");
                let id = $(this).attr("userId");
                if (lockStatus == "0") {
                    lockStatus = '1';
                } else if (lockStatus == "1") {
                    lockStatus = '0';
                }
                const a = this;
                if (window.confirm("?????????????????????????????????????????????")) {
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
                                $(a).html(lockStatus == "1" ? "??????" : "??????");
                            }
                        }
                    });
                }
            });

            //?????????????????????????????????
            $("#removeBtn").click(function () {
                const selectUsers = $("#userList input[type='checkbox']:checked");
                if (selectUsers.length == 0) {
                    alert("???????????????????????????");
                    return;
                }
                const id = new Array();
                $.each(selectUsers, function (index, obj) {
                    id.push(obj.value);
                });
                if (window.confirm("??????????????????????????????????????????")) {
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
         * ??????????????????
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
                            lockStatus = "??????";
                        } else {
                            lockStatus = "??????";
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
                        currentPage: pageNo,// ????????????,?????????pageNo
                        rowsPerPage: pageSize,// ??????????????????
                        totalRows: data.totalRows,// ?????????
                        visiblePageLinks: 5,// ??????????????????????????????
                        showGoToPage: true,// ?????????????????????????????????,?????????true
                        showRowsPerPage: true,// ??????????????????????????????????????????true
                        showRowsInfo: true,// ???????????????????????????????????????true
                        totalPages: totalPages,// ?????????,????????????+
                        // ?????????????????????????????????????????????
                        // ?????????????????????????????????pageNo???pageSize
                        onChangePage: function (event, pageObj) {
                            thePageSize = pageObj.rowsPerPage;
                            findUserListByCondition(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }

        /**
         * ????????????
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
                    alert("???????????????????????????");
                    return;
                }
            }
            findUserListByConditions(userName, departmentName, lockStatus, startTime, endTime, pageNo, pageSize);
        }

    </script>
</head>

<body>

<!-- ??????????????????????????? -->
<div class="modal fade" id="createUserModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">??</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">????????????</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-username" class="col-sm-2 control-label">????????????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-username" maxlength="32">
                            <span id="usernameMsg" style="font-size: 14px;"></span>
                        </div>
                        <label for="create-name" class="col-sm-2 control-label">????????????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name" maxlength="20">
                            <span id="nameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-password" class="col-sm-2 control-label">????????????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="create-password" maxlength="32">
                            <span id="passwordMsg" style="font-size: 14px;"></span>
                        </div>
                        <label for="create-confirmPwd" class="col-sm-2 control-label">????????????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="create-confirmPwd" maxlength="32">
                            <span id="confirmPwdMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-email" class="col-sm-2 control-label">??????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="email" class="form-control" id="create-email">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">????????????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone" maxlength="11">
                            <span id="phoneMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-lockStatus" class="col-sm-2 control-label">????????????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-lockStatus">
                                <option value="1">??????</option>
                                <option value="0">??????</option>
                            </select>
                        </div>
                        <label for="create-department" class="col-sm-2 control-label">??????<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-department"
                                   placeholder="?????????????????????????????????" autocomplete="off">
                            <input hidden type="text" id="create-departmentId">
                            <span id="departmentMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-expireTime" class="col-sm-2 control-label">????????????</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="create-expireTime" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-allowIps" class="col-sm-2 control-label">???????????????IP</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-allowIps" style="width: 280%"
                                   maxlength="255" placeholder="?????????????????????">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button id="closeBtn" type="button" class="btn btn-default">??????</button>
                <button id="saveBtn" type="button" class="btn btn-primary">??????</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; margin-left: 30px; top: -10px;">
        <div class="page-header">
            <h3>????????????</h3>
        </div>
    </div>
</div>

<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; margin-left: 30px; top: -10px;">
    <form class="form-inline" role="form" style="position: relative;top: 8%; margin-left: 5px;">

        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">????????????</div>
                <input id="userName" class="form-control" type="text">
            </div>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">????????????</div>
                <input id="departmentName" class="form-control" type="text">
            </div>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">????????????</div>
                <select id="lockStatus" class="form-control">
                    <option value=""></option>
                    <option value="1">??????</option>
                    <option value="0">??????</option>
                </select>
            </div>
        </div>
        <br><br>
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">????????????</div>
                <input class="form-control mydate" type="text" id="startTime" readonly/>
            </div>
        </div>

        ~

        <div class="form-group">
            <div class="input-group">
                <input class="form-control mydate" type="text" id="endTime" readonly/>
            </div>
        </div>

        <button id="queryBtn" type="button" class="btn btn-default">??????</button>

    </form>
</div>


<div class="btn-toolbar" role="toolbar"
     style="background-color: #F7F7F7; height: 50px; position: relative; margin-left: 30px; width: 110%; top: 20px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button id="createBtn" type="button" class="btn btn-primary"><span
                class="glyphicon glyphicon-plus"></span> ??????
        </button>
        <button id="removeBtn" type="button" class="btn btn-danger"><span
                class="glyphicon glyphicon-minus"></span> ??????
        </button>
    </div>
    <div class="btn-group" style="position: relative; top: 18%; margin-left: 5px;">
        <button type="button" class="btn btn-default">??????????????????</button>
        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
            <span class="caret"></span>
            <span class="sr-only">Toggle Dropdown</span>
        </button>
        <ul id="definedColumns" class="dropdown-menu" role="menu">
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="username" checked/> ????????????</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="departmentName" checked/> ????????????</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="email" checked/> ??????</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="expireTime" checked/> ????????????</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="allowIps" checked/> ????????????IP</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="lockStatus" checked/> ????????????</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="createBy" checked/> ?????????</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="createTime" checked/> ????????????</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="editBy" checked/> ?????????</a>
            </li>
            <li>
                <a href="javascript:void(0);"><input type="checkbox" value="editTime" checked/> ????????????</a>
            </li>
        </ul>
    </div>
</div>

<div style="position: relative; margin-left: 30px; top: 40px; width: 110%">
    <table class="table table-hover" id="userListT">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input id="allSelectBox" type="checkbox"/></td>
            <td>??????</td>
            <td name="username">????????????</td>
            <td>????????????</td>
            <td name="departmentName">????????????</td>
            <td name="email">??????</td>
            <td name="expireTime">????????????</td>
            <td name="allowIps">????????????IP</td>
            <td name="lockStatus">????????????</td>
            <td name="createBy">?????????</td>
            <td name="createTime">????????????</td>
            <td name="editBy">?????????</td>
            <td name="editTime">????????????</td>
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