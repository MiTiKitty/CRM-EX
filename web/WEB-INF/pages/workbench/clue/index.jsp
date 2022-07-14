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
        let isCreateCompany = false;
        let isCreateFullName = false;
        let isEditCompany = true;
        let isEditFullName = true;

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

            findClueByCondition();

            //给创建线索按钮添加单击事件
            $("#createBtn").click(function () {
                $("form").get(0).reset();
                $("#createClueModal").modal("show");
            });

            //给创建公司输入框添加失去焦点事件
            $("#create-company").blur(function () {
                const company = $.trim($(this).val());
                if (company == '') {
                    $("#createCompanyMsg").css("color", "red");
                    $("#createCompanyMsg").text("公司不能为空");
                    isCreateCompany = false;
                } else {
                    $("#createCompanyMsg").css("color", "green");
                    $("#createCompanyMsg").text("✓");
                    isCreateCompany = true;
                }
            });

            //给创建姓名输入框添加失去焦点事件
            $("#create-fullName").blur(function () {
                const fullName = $.trim($(this).val());
                if (fullName == '') {
                    $("#createFullNameMsg").css("color", "red");
                    $("#createFullNameMsg").text("姓名不能为空");
                    isCreateFullName = false;
                } else {
                    $("#createFullNameMsg").css("color", "green");
                    $("#createFullNameMsg").text("✓");
                    isCreateFullName = true;
                }
            });

            //给保存按钮添加单击事件
            $("#saveCreateBtn").click(function () {
                if (!isCreateCompany || !isCreateFullName) {
                    alert("表单填写有误！");
                    return;
                }
                const owner = v("create-owner");
                const company = tv("create-company");
                const appellation = v("create-appellation");
                const fullName = tv("create-fullName");
                const job = tv("create-job");
                const email = tv("create-email");
                const phone = tv("create-phone");
                const website = tv("create-website");
                const grade = v("create-grade");
                const industry = v("create-industry");
                const mphone = tv("create-mphone");
                const state = v("create-state");
                const source = v("create-source");
                const description = tv("create-description");
                const contactSummary = tv("create-contactSummary");
                const nextContactTime = tv("create-nextContactTime");
                const address = tv("create-address");
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/clue/createClue.do",
                    data: {
                        owner: owner,
                        company: company,
                        appellation: appellation,
                        fullName: fullName,
                        job: job,
                        email: email,
                        phone: phone,
                        website: website,
                        grade: grade,
                        industry: industry,
                        mphone: mphone,
                        state: state,
                        source: source,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == '0') {
                            alert(data.message);
                        } else if (data.code == '1') {
                            findClueByCondition(1, thePageSize);
                            $("#createClueModal").modal("hide");
                        }
                    }
                });
            });

            //给取消创建按钮添加单击事件
            $("#closeCreateBtn").click(function () {
                $("#createClueModal").modal("hide");
            });

            //给修改按钮添加单击事件
            $("#editBtn").click(function () {
                const obj = $("#clueList input[type='checkbox']:checked");
                if (obj.length != 1) {
                    alert("只能选择一个进行修改操作！")
                    return;
                }
                const id = obj[0].value;
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/clue/queryClueById.do",
                    data: {
                        id: id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        $("#clueId").val(id);
                        $("#edit-owner").val(data.owner);
                        $("#edit-company").val(data.company);
                        $("#edit-appellation").val(data.appellation);
                        $("#edit-fullName").val(data.fullName);
                        $("#edit-job").val(data.job);
                        $("#edit-email").val(data.email);
                        $("#edit-phone").val(data.phone);
                        $("#edit-website").val(data.website);
                        $("#edit-grade").val(data.grade);
                        $("#edit-industry").val(data.industry);
                        $("#edit-mphone").val(data.mphone);
                        $("#edit-state").val(data.state);
                        $("#edit-source").val(data.source);
                        $("#edit-description").val(data.description);
                        $("#edit-contactSummary").val(data.contactSummary);
                        $("#edit-nextContactTime").val(data.nextContactTime);
                        $("#edit-address").val(data.address);
                        $("#editClueModal").modal("show");
                    }
                });
            });

            //给修改公司输入框添加失去焦点事件
            $("#edit-company").blur(function () {
                const company = $.trim($(this).val());
                if (company == '') {
                    $("#editCompanyMsg").css("color", "red");
                    $("#editCompanyMsg").text("公司不能为空");
                    isEditCompany = false;
                } else {
                    $("#editCompanyMsg").css("color", "green");
                    $("#editCompanyMsg").text("✓");
                    isEditCompany = true;
                }
            });

            //给修改姓名输入框添加失去焦点事件
            $("#edit-fullName").blur(function () {
                const fullName = $.trim($(this).val());
                if (fullName == '') {
                    $("#editFullNameMsg").css("color", "red");
                    $("#editFullNameMsg").text("姓名不能为空");
                    isEditFullName = false;
                } else {
                    $("#editFullNameMsg").css("color", "green");
                    $("#editFullNameMsg").text("✓");
                    isEditFullName = true;
                }
            });

            //给更新按钮添加单击事件
            $("#saveEditBtn").click(function () {
                if (!isEditCompany || !isEditFullName) {
                    alert("表单填写有误！");
                    return;
                }
                const id = v("clueId");
                const owner = v("edit-owner");
                const company = tv("edit-company");
                const appellation = v("edit-appellation");
                const fullName = tv("edit-fullName");
                const job = tv("edit-job");
                const email = tv("edit-email");
                const phone = tv("edit-phone");
                const website = tv("edit-website");
                const grade = v("edit-grade");
                const industry = v("edit-industry");
                const mphone = tv("edit-mphone");
                const state = v("edit-state");
                const source = v("edit-source");
                const description = tv("edit-description");
                const contactSummary = tv("edit-contactSummary");
                const nextContactTime = tv("edit-nextContactTime");
                const address = tv("edit-address");
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/clue/editClue.do",
                    data: {
                        id:id,
                        owner: owner,
                        company: company,
                        appellation: appellation,
                        fullName: fullName,
                        job: job,
                        email: email,
                        phone: phone,
                        website: website,
                        grade: grade,
                        industry: industry,
                        mphone: mphone,
                        state: state,
                        source: source,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == '0') {
                            alert(data.message);
                        } else if (data.code == '1') {
                            findClueByCondition(1, thePageSize);
                            $("#editClueModal").modal("hide");
                        }
                    }
                });
            });

            //给取消更新按钮添加单击事件
            $("#closeEditBtn").click(function () {
                $("#editClueModal").modal("hide");
            });

            //给全选按钮添加单击事件
            $("#allSelectBox").click(function () {
                const isCheck = $(this).prop("checked");
                $("#clueList input[type='checkbox']").prop("checked", isCheck);
            });

            //给单个选择按钮添加单击事件
            $("#clueList").on("click", "input[type='checkbox']", function () {
                const checkedSize = $("#clueList input[type='checkbox']:checked").size();
                const allSize = $("#clueList input[type='checkbox']").size();
                if (checkedSize == allSize) {
                    $("#allSelectBox").prop("checked", true);
                } else {
                    $("#allSelectBox").prop("checked", false);
                }
            });

            //给删除按钮添加单击事件
            $("#removeBtn").click(function () {
                const obj = $("#clueList input[type='checkbox']:checked");
                if (obj.length == 0) {
                    alert("至少需要选择一个进行修改操作！")
                    return;
                }
                const ids = new Array();
                $.each(obj, function (index, o) {
                    ids.push(o.value);
                });
                if (window.confirm("确定要删除吗?")) {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/workbench/clue/removeClue.do",
                        data: {
                            id: ids
                        },
                        type: "post",
                        dataType: "json",
                        traditional: true,
                        success: function (data) {
                            if (data.code == "0") {
                                alert(data.message);
                            } else if (data.code == "1") {
                                findClueByCondition(1, thePageSize);
                            }
                        }
                    });
                }
            });

        });

        //条件查询线索信息
        function findClueByCondition(pageNo = 1, pageSize = 10) {
            const fullName = tv("fullName");
            const company = tv("company");
            const phone = tv("phone");
            const source = v("source");
            const owner = v("owner");
            const mphone = tv("mphone");
            const state = v("state");
            $.ajax({
                url: "${pageContext.request.contextPath}/workbench/clue/queryClueByCondition.do",
                data: {
                    fullName: fullName,
                    company: company,
                    phone: phone,
                    source: source,
                    owner: owner,
                    mphone: mphone,
                    state: state,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    let htmlStr = "";
                    $.each(data.clueList, function (index, obj) {
                        htmlStr += "<tr>\n" +
                            "                    <td><input value=\"" + obj.id + "\" type=\"checkbox\"/></td>\n" +
                            "                    <td><a style=\"text-decoration: none; cursor: pointer;\"\n" +
                            "                           onclick=\"window.location.href='${pageContext.request.contextPath}/workbench/clue/detail.do?id=" + obj.id + "';\">" + obj.fullName + obj.appellation + "</a>\n" +
                            "                    </td>\n" +
                            "                    <td>" + obj.company + "</td>\n" +
                            "                    <td>" + obj.phone + "</td>\n" +
                            "                    <td>" + obj.mphone + "</td>\n" +
                            "                    <td>" + obj.source + "</td>\n" +
                            "                    <td>" + obj.owner + "</td>\n" +
                            "                    <td>" + obj.state + "</td>\n" +
                            "                </tr>";
                    });
                    //展示查询到的市场活动列表
                    $("#clueList").html(htmlStr);
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
                            findClueByCondition(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }

        /**
         * 得到该id所拥有的值
         * @param name
         * @returns {string|*|jQuery}
         */
        function v(name) {
            return $("#" + name).val();
        }

        /**
         * 去空格且得到该id所拥有的值
         * @param name
         * @returns {string | null}
         */
        function tv(name) {
            return $.trim($("#" + name).val());
        }

    </script>
</head>

<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <c:forEach items="${requestScope.userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                            <span id="createCompanyMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-appellation" class="col-sm-2 control-label">称呼<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <c:forEach items="${requestScope.appellationList}" var="call">
                                    <option value="${call.value}">${call.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-fullName" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullName">
                            <span id="createFullNameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone" maxlength="11">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-grade" class="col-sm-2 control-label">等级<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-grade">
                                <c:forEach items="${requestScope.gradeList}" var="grade">
                                    <option value="${grade.value}">${grade.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-industry" class="col-sm-2 control-label">行业<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-industry">
                                <c:forEach items="${requestScope.industryList}" var="industry">
                                    <option value="${industry.value}">${industry.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone" maxlength="11">
                        </div>
                        <label for="create-state" class="col-sm-2 control-label">线索状态<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-state">
                                <c:forEach items="${requestScope.stateList}" var="state">
                                    <option value="${state.value}">${state.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <c:forEach items="${requestScope.sourceList}" var="source">
                                    <option value="${source.value}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">线索描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="create-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button id="closeCreateBtn" type="button" class="btn btn-default">关闭</button>
                <button id="saveCreateBtn" type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                        <input id="clueId" type="text" hidden>
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${requestScope.userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="">
                            <span id="editCompanyMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-appellation" class="col-sm-2 control-label">称呼<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <c:forEach items="${requestScope.appellationList}" var="call">
                                    <option value="${call.value}">${call.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-fullName" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullName" value="">
                            <span id="editFullNameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="" maxlength="11">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-grade" class="col-sm-2 control-label">等级<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-grade">
                                <c:forEach items="${requestScope.gradeList}" var="grade">
                                    <option value="${grade.value}">${grade.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-industry" class="col-sm-2 control-label">行业<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-industry">
                                <c:forEach items="${requestScope.industryList}" var="industry">
                                    <option value="${industry.value}">${industry.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="" maxlength="11">
                        </div>
                        <label for="edit-state" class="col-sm-2 control-label">线索状态<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-state">
                                <c:forEach items="${requestScope.stateList}" var="state">
                                    <option value="${state.value}">${state.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <c:forEach items="${requestScope.sourceList}" var="source">
                                    <option value="${source.value}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="edit-nextContactTime" readonly
                                       value="">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button id="closeEditBtn" type="button" class="btn btn-default">关闭</button>
                <button id="saveEditBtn" type="button" class="btn btn-primary">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; margin-left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
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
                        <input class="form-control" type="text" id="fullName">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" type="text" id="company">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="source">
                            <option value=""></option>
                            <c:forEach items="${requestScope.sourceList}" var="source">
                                <option value="${source.value}">${source.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <select class="form-control" id="owner">
                            <option value=""></option>
                            <c:forEach items="${requestScope.userList}" var="user">
                                <option value="${user.id}">${user.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" type="text" id="mphone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="state">
                            <option value=""></option>
                            <c:forEach items="${requestScope.stateList}" var="state">
                                <option value="${state.value}">${state.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button id="searchBtn" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="createBtn" type="button" class="btn btn-primary"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="editBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="removeBtn" type="button" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>
        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="allSelectBox" type="checkbox"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="clueList">
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 60px;" id="pageDiv">
        </div>

    </div>

</div>
</body>

</html>