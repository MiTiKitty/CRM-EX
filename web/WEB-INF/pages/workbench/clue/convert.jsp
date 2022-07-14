<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>

<head>
    <meta charset="UTF-8">

    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


    <link href="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css"
          type="text/css" rel="stylesheet"/>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">
        let isMoney = false;
        let isName = true;
        let isDate = false;
        let isActivity = false;

        $(function () {
            $("#isCreateTransaction").click(function () {
                if (this.checked) {
                    $("#create-transaction2").show(200);
                } else {
                    $("#create-transaction2").hide(200);
                }
            });

            //给金额输入框添加失去焦点事件
            $("#amountOfMoney").blur(function () {
                const value = $.trim($(this).val());
                if (!/^[0-9]{1,11}$/.test(value)){
                    $("#moneyMsg").css("color", "red");
                    $("#moneyMsg").text("金额无效!");
                    isMoney = false;
                }else {
                    $("#moneyMsg").css("color", "green");
                    $("#moneyMsg").text("✓");
                    isMoney = true;
                }
            });

            //给名称输入框添加失去焦点事件
            $("#tradeName").blur(function () {
                const value = $.trim($(this).val());
                if (value == ""){
                    $("#nameMsg").css("color", "red");
                    $("#nameMsg").text("名称不能为空!");
                    isName = false;
                }else {
                    $("#nameMsg").css("color", "green");
                    $("#nameMsg").text("✓");
                    isName = true;
                }
            });

            //给预计成交日期输入框添加失去焦点事件
            $("#expectedClosingDate").blur(function () {
                const value = $.trim($(this).val());
                if (value == ""){
                    $("#dateMsg").css("color", "red");
                    $("#dateMsg").text("成交日期不能为空!");
                    isDate = false;
                }else {
                    $("#dateMsg").css("color", "green");
                    $("#dateMsg").text("✓");
                    isDate = true;
                }
            });

            //给查询市场活动图标添加单击事件
            $("#search, #activity").click(function () {
                $("#searchActivityModal").modal("show");
            });

            //给市场活动名称输入框添加键盘弹起事件
            $("#name").keyup(function () {
                const name = $.trim($(this).val());
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/clue/queryActivityForConvertByName.do",
                    data:{
                        clueId:"${requestScope.clue.id}",
                        name:name
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        let htmlStr = "";
                        $.each(data, function (index, obj) {
                            htmlStr += "<tr>\n" +
                                "                        <td><input value='"+obj.id+"' type=\"radio\" name=\"activity\"/></td>\n" +
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

            //给市场活动单选按钮添加单击事件
            $("#activityList").on("click", "input[type='radio']", function () {
                const activityId = $(this).val();
                $("#activityId").val(activityId);
                isActivity = true;
                $("#searchActivityModal").modal("hide");
            });

            //给转换按钮添加单击事件
            $("#convertBtn").click(function () {
                const isCreateTransaction = $("#isCreateTransaction").prop("shecked");
                if (isCreateTransaction){
                    if (!isMoney || !isName || !isDate || !isActivity){
                        alert("表单填写有误！");
                        return;
                    }
                }
                const amountOfMoney = $.trim($("#amountOfMoney").val());
                const name = $.trim($("#tradeName").val());
                const expectedClosingDate = $("#expectedClosingDate").val();
                const stage = $("#stage").val();
                const type = $("#type").val();
                const source = $("#source").val();
                const activityId = $("#activityId").val();
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/clue/createConvert.do",
                    data:{
                        clueId:"${requestScope.clue.id}",
                        amountOfMoney:amountOfMoney,
                        name:name,
                        expectedClosingDate:expectedClosingDate,
                        stage:stage,
                        type:type,
                        source:source,
                        activityId:activityId,
                        isConvert:isCreateTransaction
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        } else if (data.code == "1"){
                            window.location.href = "${pageContext.request.contextPath}/workbench/clue/index.do";
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

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; margin-left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="name" type="text" class="form-control" style="width: 300px;"
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
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="activityList">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="title" class="page-header" style="position: relative; margin-left: 20px;">
    <h4>转换线索 <small>${requestScope.clue.fullName}${requestScope.clue.appellation} - ${requestScope.clue.company}</small>
    </h4>
</div>
<div id="create-customer" style="position: relative; margin-left: 40px; height: 35px;">
    新建客户：${requestScope.clue.company}
</div>
<div id="create-contact" style="position: relative; margin-left: 40px; height: 35px;">
    新建联系人：${requestScope.clue.fullName}${requestScope.clue.appellation}
</div>
<div id="create-transaction1" style="position: relative; margin-left: 40px; height: 35px; top: 25px;">
    <input type="checkbox" id="isCreateTransaction"/> 为客户创建交易
</div>
<div id="create-transaction2"
     style="position: relative; margin-left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;">

    <form>
        <div class="form-group" style="width: 400px; position: relative; margin-left: 20px;">
            <label for="amountOfMoney">金额</label>
            <input type="text" class="form-control" id="amountOfMoney" maxlength="11">
            <span id="moneyMsg" style="font-size: 14px;"></span>
        </div>
        <div class="form-group" style="width: 400px;position: relative; margin-left: 20px;">
            <label for="tradeName">交易名称</label>
            <input type="text" class="form-control" id="tradeName" value="${requestScope.clue.company}-" maxlength="255">
            <span id="nameMsg" style="font-size: 14px;"></span>
        </div>
        <div class="form-group" style="width: 400px;position: relative; margin-left: 20px;">
            <label for="expectedClosingDate">预计成交日期</label>
            <input type="text" class="form-control myDate" id="expectedClosingDate" readonly>
            <span id="dateMsg" style="font-size: 14px;"></span>
        </div>
        <div class="form-group" style="width: 400px;position: relative; margin-left: 20px;">
            <label for="stage">阶段</label>
            <select id="stage" class="form-control">
                <c:forEach items="${requestScope.stageList}" var="s">
                    <option value="${s.value}">${s.value}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group" style="width: 400px;position: relative; margin-left: 20px;">
            <label for="stage">阶段</label>
            <select id="type" class="form-control">
                <c:forEach items="${requestScope.typeList}" var="s">
                    <option value="${s.value}">${s.value}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group" style="width: 400px;position: relative; margin-left: 20px;">
            <label for="stage">阶段</label>
            <select id="source" class="form-control">
                <c:forEach items="${requestScope.sourceList}" var="s">
                    <option value="${s.value}">${s.value}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group" style="width: 400px;position: relative; margin-left: 20px;">
            <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="search" style="text-decoration: none;"><span
                    class="glyphicon glyphicon-search"></span></a></label>
            <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
            <input type="text" id="activityId" hidden>
        </div>
    </form>

</div>

<div id="owner" style="position: relative; margin-left: 40px; height: 35px; top: 50px;">
    记录的所有者：<br>
    <b>${sessionScope.sessionUser.name}</b>
</div>
<div id="operation" style="position: relative; margin-left: 40px; height: 35px; top: 100px;">
    <input id="convertBtn" class="btn btn-primary" type="button" value="转换"> &nbsp;&nbsp;&nbsp;&nbsp;
    <input id="closeBtn" class="btn btn-default" type="button" value="取消">
</div>
</body>

</html>