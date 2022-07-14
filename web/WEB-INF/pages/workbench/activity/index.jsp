<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_pagination-master/localization/en.min.js"></script>

    <script type="text/javascript">
        let thePageSize = 10;
        let isCreateName = false;
        let isCreateBudgetCost = true;
        let isEditName = true;
        let isEditBudgetCost = true;

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
                clearBtn: true
            });

            //先查询
            findActivityByCondition();

            //给查询按钮添加单击事件
            $("#searchBtn").click(function () {
                findActivityByCondition(1, thePageSize);
            });

            //给创建市场活动按钮添加单击事件
            $("#createBtn").click(function () {
                $("form").get(0).reset();
                $("#createActivityModal").modal("show");
            });

            //给创建市场活动名称输入框添加失去焦点事件
            $("#create-ActivityName").blur(function () {
                const name = $.trim($(this).val());
                if (name == '') {
                    $("#createNameMsg").css("color", "red");
                    $("#createNameMsg").text("市场活动名称不能为空");
                    isCreateName = false;
                } else {
                    $("#createNameMsg").css("color", "green");
                    $("#createNameMsg").text("✓");
                    isCreateName = true;
                }
            });

            //给创建预算成本输入框添加失去焦点事件
            $("#create-cost").blur(function () {
                const cost = $.trim($(this).val());
                if (!/^[0-9]{1,11}$/.test(cost)) {
                    $("#costMsg").css("color", "red");
                    $("#costMsg").text("金额描述错误");
                    isCreateBudgetCost = false;
                } else {
                    $("#costMsg").css("color", "green");
                    $("#costMsg").text("✓");
                    isCreateBudgetCost = true;
                }
            });

            //给保存创建市场活动按钮添加单击事件
            $("#saveCreateBtn").click(function () {
                if (!isCreateName || !isCreateBudgetCost) {
                    alert("表单填写有误!");
                    return;
                }
                const owner = $("#create-owner").val();
                const name = $.trim($("#create-ActivityName").val());
                const source = $("#create-source").val();
                const state = $("#create-state").val();
                const startDate = $("#create-startDate").val();
                const endDate = $("#create-endDate").val();
                const budgetCost = $.trim($("#create-cost").val());
                const description = $.trim($("#create-description").val());
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/activity/createActivity.do",
                    data: {
                        owner: owner,
                        name: name,
                        source: source,
                        state: state,
                        startDate: startDate,
                        endDate: endDate,
                        budgetCost: budgetCost,
                        description: description
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == "1") {
                            findActivityByCondition(1, thePageSize);
                            $("#createActivityModal").modal("hide");
                        }
                    }
                });
            });

            //给关闭创建市场活动按钮添加单击事件
            $("#closeCreateBtn").click(function () {
                $("#createActivityModal").modal("hide");
            });

            //给全选按钮添加单击事件
            $("#allSelectBox").click(function () {
                const isCheck = $(this).prop("checked");
                $("#activityList input[type='checkbox']").prop("checked", isCheck);
            });

            //给单个选择按钮添加单击事件
            $("#activityList").on("click", "input[type='checkbox']", function () {
                const checkedSize = $("#activityList input[type='checkbox']:checked").size();
                const allSize = $("#activityList input[type='checkbox']").size();
                if (checkedSize == allSize) {
                    $("#allSelectBox").prop("checked", true);
                } else {
                    $("#allSelectBox").prop("checked", false);
                }
            });

            //给修改市场活动按钮添加单击事件
            $("#editBtn").click(function () {
                const activity = $("#activityList input[type='checkbox']:checked");
                if (activity.length > 1 || activity.length == 0) {
                    alert("只能选择一个市场活动进行修改操作！");
                    return;
                }
                const id = activity[0].value;
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/activity/queryActivityById.do",
                    data: {
                        id: id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        $("#activityId").val(data.id);
                        $("#edit-owner").val(data.owner);
                        $("#edit-ActivityName").val(data.name);
                        $("#edit-source").val(data.source);
                        $("#edit-state").val(data.state);
                        $("#edit-startDate").val(data.startDate);
                        $("#edit-endDate").val(data.endDate);
                        $("#edit-cost").val(data.budgetCost);
                        $("#edit-description").val(data.description);
                        //模态窗口显示
                        $("#editActivityModal").modal("show");
                    }
                });
            });

            //给修改市场活动名称输入框添加失去焦点事件
            $("#edit-ActivityName").blur(function () {
                const name = $.trim($(this).val());
                if (name == '') {
                    $("#editNameMsg").css("color", "red");
                    $("#editNameMsg").text("市场活动名称不能为空");
                    isEditName = false;
                } else {
                    $("#editNameMsg").css("color", "green");
                    $("#editNameMsg").text("✓");
                    isEditName = true;
                }
            });

            //给修改预算成本输入框添加失去焦点事件
            $("#edit-cost").blur(function () {
                const cost = $.trim($(this).val());
                if (!/^[0-9]{1,11}$/.test(cost)) {
                    $("#costMsg").css("color", "red");
                    $("#costMsg").text("金额描述错误");
                    isEditBudgetCost = false;
                } else {
                    $("#costMsg").css("color", "green");
                    $("#costMsg").text("✓");
                    isEditBudgetCost = true;
                }
            });

            //给更新按钮添加单击事件
            $("#confirmEditBtn").click(function () {
                if (!isEditName || !isEditBudgetCost) {
                    alert("表单填写有误！");
                    return;
                }
                const id = $("#activityId").val();
                const owner = $("#edit-owner").val();
                const name = $.trim($("#edit-ActivityName").val());
                const source = $("#edit-source").val();
                const state = $("#edit-state").val();
                const startDate = $("#edit-startDate").val();
                const endDate = $("#edit-endDate").val();
                const budgetCost = $.trim($("#edit-cost").val());
                const description = $.trim($("#edit-description").val());
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/activity/editActivity.do",
                    data: {
                        id: id,
                        owner: owner,
                        name: name,
                        source: source,
                        state: state,
                        startDate: startDate,
                        endDate: endDate,
                        budgetCost: budgetCost,
                        description: description
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == "1") {
                            findActivityByCondition(1, thePageSize);
                            $("#editActivityModal").modal("hide");
                        }
                    }
                });
            });

            //给删除按钮添加单击事件
            $("#removeBtn").click(function () {
                const obj = $("#activityList input[type='checkbox']:checked");
                if (obj.length == 0) {
                    alert("至少需要选择一个进行删除操作！")
                    return;
                }
                if (window.confirm("确认要删除吗？")) {
                    const id = new Array();
                    $.each(obj, function (index, o) {
                        id.push(this.value);
                    });
                    $.ajax({
                        url: "${pageContext.request.contextPath}/workbench/activity/removeActivityByIds.do",
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
                                findActivityByCondition(1, thePageSize);
                            }
                        }
                    });
                }
            });

            //给导入市场活动按钮添加单击事件
            $("#importBtn").click(function () {
                $("#importActivityModal").modal("show");
            });

            //给下载示例文件按钮添加单击事件
            $("#activityExampleFile").click(function () {
                window.location.href = "${pageContext.request.contextPath}/workbench/activity/exportActivityExample.do";
            });

            //给确认上传按钮添加单击事件
            $("#confirmImportActivityBtn").click(function () {
                const fileName = $("#activityFile").val();
                const suffix = fileName.substr(fileName.lastIndexOf(".") + 1).toLocaleLowerCase();
                if (suffix != "xls") {
                    alert("只支持.xls文件上传");
                    return;
                }
                const activityFile = $("#activityFile")[0].files[0];
                if (activityFile.size > 5 * 1024 * 1024) {
                    alert("上传文件不能大于5MB");
                    return;
                }
                //FormData是ajax提供的接口,可以模拟键值对向后台提交参数
                //最大优势，不但能提交文本数据，还能提交二进制数据
                let formData = new FormData();
                formData.append("activityFile", activityFile);
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/activity/importActivityFile.do",
                    data: formData,
                    processData: false,//设置Ajax向后台提交参数之前，是否将参数全部转换为字符串格式，默认是true
                    contentType: false,//设置Ajax向后台提交参数之前，是否把所有参数统一按照urlencoded编码，默认是true
                    type: "post",
                    datatype: "json",
                    success: function (data) {
                        if (data.code == "1") {
                            alert(data.message);
                            findActivityByCondition(1, thePageSize);
                            $("#importActivityModal").modal("hide");
                        } else if (data.code == "0") {
                            alert(data.message);
                        }
                    }
                });
            });

            //给关闭导入市场活动按钮添加单击事件
            $("#closeImportActivityBtn").click(function () {
                $("#importActivityModal").modal("hide");
            });

            //给下载全部市场活动数据（批量导出）按钮添加单击事件
            $("#exportActivityAllBtn").click(function () {
                window.location.href = "${pageContext.request.contextPath}/workbench/activity/exportAllActivity.do";
            });

            //给下载部分市场活动数据（选择导出）按钮添加单击事件
            $("#exportActivityConditionBtn").click(function () {
                const list = $("#activityList input[type='checkbox']:checked");
                if (list.length == 0) {
                    alert("至少需要选择一个记录进行导出操作！")
                    return;
                }
                let param = "";
                for (let i = 0; i < list.length; i++) {
                    param += "id=" + $(list[i]).val() + "&";
                }
                window.location.href = "${pageContext.request.contextPath}/workbench/activity/exportActivitySelect.do?" + param;
            });
        });

        //条件分页查询市场活动
        function findActivityByCondition(pageNo = 1, pageSize = 10) {
            const name = $.trim($("#name").val());
            const owner = $.trim($("#owner").val());
            const startDate = $("#startDate").val();
            const endDate = $("#endDate").val();
            $.ajax({
                url: "${pageContext.request.contextPath}/workbench/activity/queryActivityByCondition.do",
                data: {
                    name: name,
                    owner: owner,
                    startDate: startDate,
                    endDate: endDate,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    let htmlStr = "";
                    $.each(data.activityList, function (index, obj) {
                        htmlStr += "<tr class=\"active\">\n" +
                            "                    <td><input type=\"checkbox\" value=\"" + obj.id + "\"/></td>\n" +
                            "                    <td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='${pageContext.request.contextPath}/workbench/activity/detail.do?id=" + obj.id + "';\">" + obj.name + "</a></td>\n" +
                            "                    <td>" + obj.owner + "</td>\n" +
                            "                    <td>" + obj.startDate + "</td>\n" +
                            "                    <td>" + obj.endDate + "</td>\n" +
                            "                </tr>";
                    });
                    //展示查询到的市场活动列表
                    $("#activityList").html(htmlStr);
                    //设置全选按钮为为选中
                    $("#allSelectBox").prop("checked", false);
                    let totalPages = data.totalRows % pageSize == 0 ? data.totalRows / pageSize : parseInt(data.totalRows / pageSize) + 1;
                    totalPages = data.totalRows == 0 ? 1 : totalPages;
                    //显示翻页信息
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
                            findActivityByCondition(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }
    </script>
</head>

<body>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <c:forEach items="${requestScope.owners}" var="owner">
                                    <option value="${owner.id}">${owner.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-ActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-ActivityName">
                            <span id="createNameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">来源类型<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <c:forEach items="${requestScope.sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-state" class="col-sm-2 control-label">活动状态<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-state">
                                <c:forEach items="${requestScope.stateList}" var="state">
                                    <option value="${state.id}">${state.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-startDate" readonly>
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-endDate" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">预算成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost" value="0">
                            <span id="costMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button id="closeCreateBtn" type="button">关闭</button>
                <button id="saveCreateBtn" type="button">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <input id="activityId" type="text" hidden>
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${requestScope.owners}" var="owner">
                                    <option value="${owner.id}">${owner.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-ActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-ActivityName" value="发传单">
                            <span id="editNameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">来源类型<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <c:forEach items="${requestScope.sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-state" class="col-sm-2 control-label">活动状态<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-state">
                                <c:forEach items="${requestScope.stateList}" var="state">
                                    <option value="${state.id}">${state.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="edit-startDate" value="" readonly>
                        </div>
                        <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="edit-endDate" value="" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">预算成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="">
                            <span id="edit-costMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button id="closeEditBtn" type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="confirmEditBtn" type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; margin-left: 50px;">
                    请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                </div>
                <div style="position: relative;top: 40px; margin-left: 50px;">
                    <input type="button" id="activityExampleFile" value="点击下载市场活动例子文件">
                </div>
                <div style="position: relative;top: 40px; margin-left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <div style="position: relative; width: 400px; height: 320px; margin-left: 45% ; top: -40px;">
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button id="closeImportActivityBtn" type="button" class="btn btn-default">关闭
                </button>
                <button id="confirmImportActivityBtn" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative; margin-left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; margin-left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; padding-left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; margin-left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input id="name" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input id="owner" class="form-control" type="text">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control myDate" type="text" id="startDate" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control myDate" type="text" id="endDate" readonly>
                    </div>
                </div>

                <button id="searchBtn" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="createBtn" type="button" class="btn btn-primary">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="editBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="removeBtn" type="button" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="importBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-import"></span> 上传列表数据（导入）
                </button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载所有数据（批量导出）
                </button>
                <button id="exportActivityConditionBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载部分数据（选择导出）
                </button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="allSelectBox" type="checkbox"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityList">
                </tbody>
            </table>
        </div>

        <div id="pageDiv">
        </div>

    </div>

</div>
</body>

</html>