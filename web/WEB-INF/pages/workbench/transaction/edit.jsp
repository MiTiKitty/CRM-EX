<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>

<head>
    <meta charset="UTF-8">

    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css"
          type="text/css" rel="stylesheet"/>

    <style>
        .f div {
            width: 100%;
        }
    </style>

    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">
        let isMoney = true;
        let isName = true;
        let isDate = true;
        let isCustomer = true;
        let isContacts = true;
        let isActivity = true;

        $(function () {
            //设置日历窗口
            $(".myDate").datetimepicker({
                language: 'zh-CN',
                weekStart: 1,
                todayBtn: 1,
                autoclose: 1,
                todayHighlight: 1,
                startView: 2,
                minView: 2,
                forceParse: 0,
                format: "yyyy-mm-dd",
                pickerPosition: 'top-left',
                clearBtn: true
            });

            //给金额输入框添加失去焦点事件
            $("#edit-amountOfMoney").blur(function () {
                const value = $.trim($(this).val());
                if (!/^[0-9]{1,11}$/.test(value)) {
                    $("#moneyMsg").css("color", "red");
                    $("#moneyMsg").text("金额无效!");
                    isMoney = false;
                } else {
                    $("#moneyMsg").css("color", "green");
                    $("#moneyMsg").text("✓");
                    isMoney = true;
                }
            });

            //给名称输入框添加失去焦点事件
            $("#edit-name").blur(function () {
                const value = $.trim($(this).val());
                if (value == "") {
                    $("#nameMsg").css("color", "red");
                    $("#nameMsg").text("名称不能为空!");
                    isName = false;
                } else {
                    $("#nameMsg").css("color", "green");
                    $("#nameMsg").text("✓");
                    isName = true;
                }
            });

            //给预计成交日期输入框添加失去焦点事件
            $("#edit-expectedClosingDate").blur(function () {
                const value = $.trim($(this).val());
                if (value == "") {
                    $("#dateMsg").css("color", "red");
                    $("#dateMsg").text("成交日期不能为空!");
                    isDate = false;
                } else {
                    $("#dateMsg").css("color", "green");
                    $("#dateMsg").text("✓");
                    isDate = true;
                }
            });

            //给客户名称输入框添加自动补全功能
            $("#edit-customerName").typeahead({
                //配置minLength
                minLength: 1,//最少输入字符串
                items: 5,//最多显示的下拉列表内容
                //1、先配置数据源(可以先不配置数据源，先配置其他东西)
                source: function (query, process) {//第一个为正在查询的值，第二个参数为函数(该函数)
                    //使用Ajax加载数据源
                    return $.ajax({
                        url: "${pageContext.request.contextPath}/workbench/customer/queryCustomerByName.do",
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
                                isCustomer = false;
                                $("#customerMsg").css("color", "red");
                                $("#customerMsg").text("无效的客户！");

                                isContacts = false;
                                $("#edit-contactsName").val("");
                                $("#edit-contactsId").val("");
                                $("#contactsMsg").css("color", "red");
                                $("#contactsMsg").text("无效的联系人！");

                                isActivity = false;
                                $("#edit-activityName").val("");
                                $("#edit-activityId").val("");
                                $("#activityMsg").css("color", "red");
                                $("#activityMsg").text("无效的市场活动！");
                            }
                        }
                    });
                },
                //function中需要传一个item，该item就是返回回来的一个一个json对象
                displayText: function (item) {
                    return item.name;
                },
                updater: function (item) {
                    $("#edit-customerId").val(item.id);
                    isCustomer = true;
                    $("#customerMsg").css("color", "green");
                    $("#customerMsg").text("✓");
                    return item;
                }
            });

            //给联系人名称输入框和搜索图标添加单击事件
            $("#edit-contactsName, #searchContacts").click(function () {
                if (!isCustomer){
                    alert("客户不存在！");
                    return;
                }
                $("#findContacts").modal("show");
            });

            //给联系人名称输入框添加键盘弹起事件
            $("#contactsName").keyup(function () {
                const fullName = $.trim($(this).val());
                const customerId = $("#edit-customerId").val();
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/transaction/queryContactsByFullName.do",
                    data:{
                        fullName:fullName,
                        customerId:customerId
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        let htmlStr = "";
                        $.each(data, function (index, obj) {
                            htmlStr += "<tr>\n" +
                                "                        <td><input fullName='"+obj.fullName+"' value=\""+obj.id+"\" type=\"radio\" name=\"contacts\"/></td>\n" +
                                "                        <td>"+obj.fullName+"</td>\n" +
                                "                        <td>"+obj.email+"</td>\n" +
                                "                        <td>"+obj.mphone+"</td>\n" +
                                "                    </tr>";
                        });
                        $("#contactsList").html(htmlStr);
                    }
                });
            });

            //给联系人单选框添加单击事件
            $("#contactsList").on("click", "input[type='radio']", function () {
                const contactsName = $(this).attr("fullName");
                const contactsId = $(this).val();

                isContacts = true;
                $("#edit-contactsName").val(contactsName);
                $("#edit-contactsId").val(contactsId);
                $("#contactsMsg").css("color", "green");
                $("#contactsMsg").text("✓");
                $("#findContacts").modal("hide");
            });

            //给市场活动名称输入框和搜索图标添加单击事件
            $("#edit-activityName, #searchActivity").click(function () {
                if (!isContacts){
                    alert("联系人不存在！");
                    return;
                }
                $("#findActivity").modal("show");
            });

            //给市场活动名称输入框添加键盘弹起事件
            $("#activityName").keyup(function () {
                const name = $.trim($(this).val());
                const contactsId = $("#edit-contactsId").val();
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/contacts/queryActivityByName.do",
                    data:{
                        name:name,
                        contactsId:contactsId
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        let htmlStr = "";
                        $.each(data, function (index, obj) {
                            htmlStr += "<tr>\n" +
                                "                        <td><input activityName=\""+obj.name+"\" value=\""+obj.id+"\" type=\"radio\" name=\"activity\"/></td>\n" +
                                "                        <td>"+obj.name+"</td>\n" +
                                "                        <td>"+obj.startDate+"</td>\n" +
                                "                        <td>"+obj.endDate+"</td>\n" +
                                "                        <td>"+obj.owner+"</td>\n" +
                                "                    </tr>";
                        });
                        $("#activityList").html(htmlStr);
                    }
                });
            });

            //给市场活动单选框添加单击事件
            $("#activityList").on("click", "input[type='radio']", function () {
                const activityName = $(this).attr("activityName");
                const activityId = $(this).val();
                isActivity = true;
                $("#edit-activityName").val(activityName);
                $("#edit-activityId").val(activityId);
                $("#activityMsg").css("color", "green");
                $("#activityMsg").text("✓");
                $("#findActivity").modal("hide");
            });

            //给更新按钮添加单击事件
            $("#saveBtn").click(function () {
                if (!isMoney || !isName || !isDate || !isCustomer || !isContacts || !isActivity){
                    alert("表单填写有误！");
                    return;
                }
                const owner = $("#edit-owner").val();
                const amountOfMoney = $.trim($("#edit-amountOfMoney").val());
                const name = $.trim($("#edit-name").val());
                const expectedClosingDate = $("#edit-expectedClosingDate").val();
                const customerId = $("#edit-customerId").val();
                const stage = $("#edit-stage").val();
                const type = $("#edit-type").val();
                const source = $("#edit-source").val();
                const activityId = $("#edit-activityId").val();
                const contactsId = $("#edit-contactsId").val();
                const description = $.trim($("#edit-description").val());
                const contactSummary = $.trim($("#edit-contactSummary").val());
                const nextContactTime = $("#edit-nextContactTime").val();
                const id = "${requestScope.transaction.id}";
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/transaction/editTransaction.do",
                    data:{
                        owner:owner,
                        amountOfMoney:amountOfMoney,
                        name:name,
                        expectedClosingDate:expectedClosingDate,
                        customerId:customerId,
                        stage:stage,
                        type:type,
                        source:source,
                        contactsId:contactsId,
                        activityId:activityId,
                        description:description,
                        contactSummary:contactSummary,
                        nextContactTime:nextContactTime,
                        id:id
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            window.location.href = "${pageContext.request.contextPath}/workbench/transaction/index.do";
                        }
                    }
                });
            });

            //给取消按钮添加单击事件
            $("#closeBtn").click(function () {
                window.history.back();
            });
        });
    </script>

</head>

<body>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; margin-left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="contactsName" type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="contactsTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="contactsList">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- 查找市场活动 -->
<div class="modal fade" id="findActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; margin-left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="activityName" type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="activityList">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div style="position:  relative; margin-left: 30px;">
    <h3>修改交易</h3>
    <div style="position: relative; top: -40px; margin-left: 70%;">
        <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
        <button id="closeBtn" type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal f" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-owner">
                <c:forEach items="${requestScope.userList}" var="owner">
                    <option <c:if test="${requestScope.transaction.owner.equals(owner.id)}">
                        selected
                    </c:if> value="${owner.id}">${owner.name}</option>
                </c:forEach>
            </select>
        </div>
        <label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-amountOfMoney" maxlength="11" value="${requestScope.transaction.amountOfMoney}">
            <span id="moneyMsg" style="font-size: 14px;"></span>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-name" class="col-sm-2 control-label">名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-name" value="${requestScope.transaction.name}">
            <span id="nameMsg" style="font-size: 14px;"></span>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-customerName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="${requestScope.transaction.customer.name}">
            <input type="text" id="edit-customerId" hidden value="${requestScope.transaction.customerId}">
            <span id="customerMsg" style="font-size: 14px;"></span>
        </div>
        <label for="edit-stage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-stage">
                <c:forEach items="${requestScope.stageList}" var="v">
                    <option <c:if test="${requestScope.transaction.stage.equals(v.value)}">
                        selected
                    </c:if> value="${v.value}">${v.value}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-type" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-type">
                <c:forEach items="${requestScope.typeList}" var="v">
                    <option <c:if test="${requestScope.transaction.type.equals(v.value)}">
                        selected
                    </c:if> value="${v.value}">${v.value}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-source" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-source">
                <c:forEach items="${requestScope.sourceList}" var="v">
                    <option <c:if test="${requestScope.transaction.source.equals(v.value)}">
                        selected
                    </c:if> value="${v.value}">${v.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control myDate" id="edit-expectedClosingDate" readonly value="${requestScope.transaction.expectedClosingDate}">
            <span id="dateMsg" style="font-size: 14px;"></span>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a
                href="javascript:void(0);"><span id="searchContacts"
                                                 class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-contactsName" readonly value="${requestScope.transaction.contacts.fullName}">
            <input type="text" id="edit-contactsId" hidden value="${requestScope.transaction.contactsId}">
            <span id="contactsMsg" style="font-size: 14px;"></span>
        </div>
        <label for="edit-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a
                href="javascript:void(0);"><span id="searchActivity"
                                                 class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-activityName" readonly value="${requestScope.transaction.activity.name}">
            <input type="text" id="edit-activityId" hidden value="${requestScope.transaction.activityId}">
            <span id="activityMsg" style="font-size: 14px;"></span>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-description" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="edit-description">${requestScope.transaction.description}</textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="edit-contactSummary">${requestScope.transaction.contactSummary}</textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control myDate" id="edit-nextContactTime" readonly value="${requestScope.transaction.nextContactTime}">
        </div>
    </div>

</form>
</body>

</html>