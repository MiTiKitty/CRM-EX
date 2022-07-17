<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <meta charset="UTF-8">
    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>

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
            color: aliceblue;
        }

        a:hover {
            color: aqua;
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

        img.user-img {
            width: 40px;
            height: 40px;
            border-radius: 20px;
        }

        span.msg {
            font-size: 12px;
        }
    </style>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/password.js"></script>
    <script type="text/javascript">
        //设置全局菜单列表显示还是图标显示
        let listMenu = true;

        //设置全局密码格式
        const passwordFormat = /^[a-zA-Z0-9_-]{1,16}$/;

        //页面加载完毕
        $(function () {

            //导航中所有文本颜色为黑色
            $(".liClass > a").css("color", "black");

            //默认选中导航菜单中的第一个菜单项
            $(".liClass:first").addClass("active");

            //第一个菜单项的文字变成白色
            $(".liClass:first > a").css("color", "white");

            //给所有的菜单项注册鼠标单击事件
            $(".liClass").click(function () {
                //移除所有菜单项的激活状态
                $(".liClass").removeClass("active");
                //导航中所有文本颜色为黑色
                $(".liClass > a").css("color", "black");
                //当前项目被选中
                $(this).addClass("active");
                //当前项目颜色变成白色
                $(this).children("a").css("color", "white");
            });

            //进入系统，工作区先打开的页面
            window.open("${pageContext.request.contextPath}/workbench/main/index.do", "workAreaFrame");

            //收缩菜单功能
            $("#menu").click(function () {
                if (listMenu) {
                    $("#navigation").css("width", "5%");
                    $("#workarea").css("width", "95%");
                    $("#workarea").css("left", "5%");
                    $("#no1 span[name='listname']").css("display", "none");
                } else {
                    $("#navigation").css("width", "16%");
                    $("#workarea").css("width", "84%");
                    $("#workarea").css("left", "16%");
                    $("#no1 span[name='listname']").css("display", "inline-block");
                    $("#no1 span[name='listname']").css("margin-left", "5px");
                }
                listMenu = !listMenu;
            });

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
                $("form").get(0).reset();
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
                            window.location.href = "${pageContext.request.contextPath}/settings/qx/user/toLogin.do"
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
                <button id="closeMyInformationBtn" type="button" class="btn btn-default">关闭</button>
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

<!-- 顶部 -->
<div class="top">
    <div class="logo">
        CRM-EX &nbsp;
        <span class="logoMsg">
                ©2022 &nbsp;itCat
            </span>
        <span style="margin-left: 30px;">
                <a id="menu">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                         class="bi bi-list" viewBox="0 0 16 16">
                    <path fill-rule="evenodd"
                          d="M2.5 12a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5z"/>
                  </svg>
                </a>
                
            </span>
    </div>
    <div class="userBox">
        <ul>
            <li class="dropdown user-dropdown">
                <a href="javascript:void(0)" style="text-decoration: none;color: white;" class="dropdown-toggle"
                   data-toggle="dropdown">
                    <img class="user-img" src="${pageContext.request.contextPath}/image/猫5.jpg"> ${sessionScope.sessionUser.name} <span
                        class="caret"></span>
                </a>
                <ul class="dropdown-menu" style="min-width: 150px;">
                    <li><a id="settingsA" href="${pageContext.request.contextPath}/settings/index.do"><span class="glyphicon glyphicon-wrench"></span> 系统设置</a></li>
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

<!-- 中间 -->
<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">

    <!-- 导航 -->
    <div id="navigation" style="left: 0px; position: relative; width: 18%; height: 100%; overflow:auto;">

        <ul id="no1" class="nav nav-pills nav-stacked">
            <li class="liClass" title="工作台"><a href="${pageContext.request.contextPath}/workbench/main/index.do" target="workAreaFrame"><span
                    class="glyphicon glyphicon-home"></span><span name="listname"> 工作台</span></a></li>
            <li class="liClass" title="动态"><a href="javascript:void(0);" target="workAreaFrame"><span
                    class="glyphicon glyphicon-tag"></span><span name="listname"> 动态</span></a></li>
            <li class="liClass" title="审批"><a href="javascript:void(0);" target="workAreaFrame"><span
                    class="glyphicon glyphicon-time"></span><span name="listname"> 审批</span></a></li>
            <li class="liClass" title="客户公海"><a href="javascript:void(0);" target="workAreaFrame"><span
                    class="glyphicon glyphicon-user"></span><span name="listname"> 客户公海</span></a></li>
            <li class="liClass" title="市场活动"><a href="${pageContext.request.contextPath}/workbench/activity/index.do" target="workAreaFrame"><span
                    class="glyphicon glyphicon-play-circle"></span><span name="listname"> 市场活动</span></a></li>
            <li class="liClass" title="线索（潜在客户）"><a href="${pageContext.request.contextPath}/workbench/clue/index.do" target="workAreaFrame"><span
                    class="glyphicon glyphicon-search"></span><span name="listname"> 线索（潜在客户）</span></a></li>
            <li class="liClass" title="客户"><a href="${pageContext.request.contextPath}/workbench/customer/index.do" target="workAreaFrame"><span
                    class="glyphicon glyphicon-user"></span><span name="listname"> 客户</span></a></li>
            <li class="liClass" title="联系人"><a href="${pageContext.request.contextPath}/workbench/contacts/index.do" target="workAreaFrame"><span
                    class="glyphicon glyphicon-earphone"></span><span name="listname"> 联系人</span></a></li>
            <li class="liClass" title="交易（商机）"><a href="/workbench/transaction/index.do" target="workAreaFrame"><span
                    class="glyphicon glyphicon-usd"></span><span name="listname"> 交易（商机）</span></a></li>
            <li class="liClass" title="售后回访"><a href="visit/index.html" target="workAreaFrame"><span
                    class="glyphicon glyphicon-phone-alt"></span><span name="listname"> 售后回访</span></a></li>
            <li class="liClass" title="统计图表">
                <a href="#no2" class="collapsed" data-toggle="collapse"><span
                        class="glyphicon glyphicon-stats"></span><span name="listname"> 统计图表</span></a>
                <ul id="no2" class="nav nav-pills nav-stacked collapse">
                    <li class="liClass" title="市场活动统计图表"><a href="chart/activity/index.html"
                                           target="workAreaFrame">&nbsp;&nbsp;&nbsp;<span
                            class="glyphicon glyphicon-chevron-right"></span><span name="listname"> 市场活动统计图表</span></a>
                    </li>
                    <li class="liClass" title="线索统计图表"><a href="chart/clue/index.html" target="workAreaFrame">&nbsp;&nbsp;&nbsp;<span
                            class="glyphicon glyphicon-chevron-right"></span><span name="listname"> 线索统计图表</span></a>
                    </li>
                    <li class="liClass" title="客户和联系人统计图表"><a href="chart/customerAndContacts/index.html" target="workAreaFrame">&nbsp;&nbsp;&nbsp;<span
                            class="glyphicon glyphicon-chevron-right"></span><span
                            name="listname"> 客户和联系人统计图表</span></a></li>
                    <li class="liClass" title="交易统计图表"><a href="chart/transaction/index.html" target="workAreaFrame">&nbsp;&nbsp;&nbsp;<span
                            class="glyphicon glyphicon-chevron-right"></span><span name="listname"> 交易统计图表</span></a>
                    </li>
                </ul>
            </li>
            <li class="liClass" title="报表"><a href="javascript:void(0);" target="workAreaFrame"><span
                    class="glyphicon glyphicon-file"></span><span name="listname"> 报表</span></a></li>
            <li class="liClass" title="销售订单"><a href="javascript:void(0);" target="workAreaFrame"><span
                    class="glyphicon glyphicon-shopping-cart"></span><span name="listname"> 销售订单</span></a></li>
            <li class="liClass" title="发货单"><a href="javascript:void(0);" target="workAreaFrame"><span
                    class="glyphicon glyphicon-send"></span><span name="listname"> 发货单</span></a></li>
            <li class="liClass" title="跟进"><a href="javascript:void(0);" target="workAreaFrame"><span
                    class="glyphicon glyphicon-earphone"></span><span name="listname"> 跟进</span></a></li>
            <li class="liClass" title="产品"><a href="javascript:void(0);" target="workAreaFrame"><span
                    class="glyphicon glyphicon-leaf"></span><span name="listname"> 产品</span></a></li>
            <li class="liClass" title="报价"><a href="javascript:void(0);" target="workAreaFrame"><span
                    class="glyphicon glyphicon-usd"></span><span name="listname"> 报价</span></a></li>
        </ul>

        <!-- 分割线 -->
        <div id="divider1"
             style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
    </div>

    <!-- 工作区 -->
    <div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
        <iframe style="border-width: 0px; width: 100%; height: 100%;" name="workAreaFrame"></iframe>
    </div>

</div>

<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>

<!-- 底部 -->
<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>

</body>

</html>