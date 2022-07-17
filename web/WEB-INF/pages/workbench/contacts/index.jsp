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
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_pagination-master/localization/en.min.js"></script>


    <script type="text/javascript">
        let thePageSize = 10;
        let isCreateFullName = false;
        let isCreateCustomer = false;
        let isEditFullName = true;
        let isEditCustomer = true;

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

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            //给创建客户输入框添加自动补全功能
            $("#create-customerName").typeahead({
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
                                isCreateCustomer = false;
                                $("#createCustomerNameMsg").css("color", "red");
                                $("#createCustomerNameMsg").text("无效的客户！");
                            }
                        }
                    });
                },
                //function中需要传一个item，该item就是返回回来的一个一个json对象
                displayText: function (item) {
                    return item.name;
                },
                updater: function (item) {
                    $("#create-customerId").val(item.id);
                    isCreateCustomer = true;
                    $("#createCustomerNameMsg").css("color", "green");
                    $("#createCustomerNameMsg").text("✓");
                    return item;
                }
            });

            //给修改客户输入框添加自动补全功能
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
                                isEditCustomer = false;
                                $("#editCustomerNameMsg").css("color", "red");
                                $("#editCustomerNameMsg").text("无效的客户！");
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
                    isEditCustomer = true;
                    $("#editCustomerNameMsg").css("color", "green");
                    $("#editCustomerNameMsg").text("✓");
                    return item;
                }
            });

            //给创建按钮添加单击事件
            $("#createBtn").click(function () {
                $("form").get(0).reset();
                $("#createContactsModal").modal("show");
            });

            //给创建姓名添加失去焦点事件
            $("#create-fullName").blur(function () {
                const fullName = $.trim($(this).val());
                if (fullName == '') {
                    $("#createFullNameMsg").css("color", "red");
                    $("#createFullNameMsg").text("姓名不能为空！");
                    isCreateFullName = false;
                } else {
                    $("#createFullNameMsg").css("color", "green");
                    $("#createFullNameMsg").text("✓");
                    isCreateFullName = true;
                }
            });

            //给保存创建按钮添加单击事件
            $("#saveCreateBtn").click(function () {
                if (!isCreateFullName || !isCreateCustomer) {
                    alert("表单填写有误！");
                    return;
                }
                const owner = $("#create-owner").val();
                const source = $("#create-source").val();
                const fullName = $.trim($("#create-fullName").val());
                const appellation = $("#create-appellation").val();
                const customerId = $("#create-customerId").val();
                const email = $.trim($("#create-email").val());
                const job = $.trim($("#create-job").val());
                const mphone = $.trim($("#create-mphone").val());
                const description = $.trim($("#create-description").val());
                const address = $.trim($("#create-address").val());
                const birth = $("#create-birth").val();
                const contactSummary = $.trim($("#edit-contactSummary").val());
                const nextContactTime = $.trim($("#edit-nextContactTime").val());
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/contacts/createContacts.do",
                    data: {
                        owner: owner,
                        source: source,
                        fullName: fullName,
                        appellation: appellation,
                        customerId: customerId,
                        email: email,
                        job: job,
                        mphone: mphone,
                        description: description,
                        address: address,
                        birth: birth,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == "1") {
                            findContactsByCondition(1, thePageSize);
                            $("#createContactsModal").modal("hide");
                        }
                    }
                });
            });

            //给取消创建按钮添加单击事件
            $("#closeCreateBtn").click(function () {
                $("#createContactsModal").modal("hide");
            });

            //给全选按钮添加单击事件
            $("#allSelectBox").click(function () {
                const isCheck = $(this).prop("checked");
                $("#contactsList input[type='checkbox']").prop("checked", isCheck);
            });

            //给单个选择按钮添加单击事件
            $("#contactsList").on("click", "input[type='checkbox']", function () {
                const checkedSize = $("#contactsList input[type='checkbox']:checked").size();
                const allSize = $("#contactsList input[type='checkbox']").size();
                if (checkedSize == allSize) {
                    $("#allSelectBox").prop("checked", true);
                } else {
                    $("#allSelectBox").prop("checked", false);
                }
            });

            //给修改按钮添加单击事件
            $("#editBtn").click(function () {
                const contacts = $("#contactsList input[type='checkbox']:checked");
                if (contacts.length == 0 || contacts.length > 1) {
                    alert("只能选择一条联系人记录进行修改操作！");
                    return;
                }
                const id = contacts[0].value;
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/contacts/queryContactsById.do",
                    data: {
                        id: id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        $("#contactsId").val(data.id);
                        $("#edit-owner").val(data.owner);
                        $("#edit-source").val(data.source);
                        $("#edit-fullName").val(data.fullName);
                        $("#edit-appellation").val(data.appellation);
                        $("#edit-email").val(data.email);
                        $("#edit-job").val(data.job);
                        $("#edit-mphone").val(data.mphone);
                        $("#edit-description").val(data.description);
                        $("#edit-address").val(data.address);
                        $("#edit-birth").val(data.birth);
                        $("#edit-customerName").val(data.customerName);
                        $("#edit-customerId").val(data.customerId);
                        $("#edit-contactSummary").val(data.contactSummary);
                        $("#edit-nextContactTime").val(data.nextContactTime);
                        $("#editContactsModal").modal("show");
                    }
                });
            });

            //给修改姓名添加失去焦点事件
            $("#edit-fullName").blur(function () {
                const fullName = $.trim($(this).val());
                if (fullName == '') {
                    $("#editFullNameMsg").css("color", "red");
                    $("#editFullNameMsg").text("姓名不能为空！");
                    isEditFullName = false;
                } else {
                    $("#editFullNameMsg").css("color", "green");
                    $("#editFullNameMsg").text("✓");
                    isEditFullName = true;
                }
            });

            //给更新按钮添加单击事件
            $("#confirmEditBtn").click(function () {
                if (!isEditFullName || !isEditCustomer) {
                    alert("表单填写有误！");
                    return;
                }
                const id = $("#contactsId").val();
                const owner = $("#edit-owner").val();
                const source = $("#edit-source").val();
                const fullName = $.trim($("#edit-fullName").val());
                const appellation = $("#edit-appellation").val();
                const customerId = $("#edit-customerId").val();
                const email = $.trim($("#edit-email").val());
                const job = $.trim($("#edit-job").val());
                const mphone = $.trim($("#edit-mphone").val());
                const description = $.trim($("#edit-description").val());
                const address = $.trim($("#edit-address").val());
                const birth = $("#edit-birth").val();
                const contactSummary = $.trim($("#edit-contactSummary").val());
                const nextContactTime = $.trim($("#edit-nextContactTime").val());
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/contacts/editContacts.do",
                    data: {
                        id: id,
                        owner: owner,
                        source: source,
                        fullName: fullName,
                        appellation: appellation,
                        customerId: customerId,
                        email: email,
                        job: job,
                        mphone: mphone,
                        description: description,
                        address: address,
                        birth: birth,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == "1") {
                            findContactsByCondition(1, thePageSize);
                            $("#editContactsModal").modal("hide");
                        }
                    }
                });
            });

            //给关闭修改按钮添加单击事件
            $("#closeEditBtn").click(function () {
                $("#editContactsModal").modal("hide");
            });

            //给删除按钮添加单击事件
            $("#removeBtn").click(function () {
                const contacts = $("#contactsList input[type='checkbox']:checked");
                if (contacts.length == 0) {
                    alert("至少需要选择一条联系人记录进行删除操作！");
                    return;
                }
                const id = new Array();
                $.each(contacts, function (index, obj) {
                    id.push(obj.value);
                });
                if (window.confirm("确定要进行删除操作吗？")) {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/workbench/contacts/removeContacts.do",
                        data: {
                            id: id
                        },
                        type: "post",
                        dataType: "json",
                        traditional: true,
                        success: function (data) {
                            if (data.code == '0') {
                                alert(data.message);
                            } else if (data.code == "1") {
                                findContactsByCondition(1, thePageSize);
                            }
                        }
                    });
                }
            });

            findContactsByCondition();

            //给查询按钮添加单击事件
            $("#search").click(function () {
                findContactsByCondition(1, thePageSize);
            });
        });

        /**
         * 条件分页查询联系人信息
         * @param pageNo
         * @param pageSize
         */
        function findContactsByCondition(pageNo = 1, pageSize = 10) {
            const owner = $("#owner").val();
            const fullName = $.trim($("#fullName").val());
            const name = $.trim($("#customerName").val());
            const source = $("#source").val();
            const birth = $("#birth").val();
            $.ajax({
                url: "${pageContext.request.contextPath}/workbench/contacts/queryContactsByCondition.do",
                data: {
                    owner: owner,
                    fullName: fullName,
                    name: name,
                    source: source,
                    birth: birth,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    let htmlStr = "";
                    $.each(data.contactsList, function (index, obj) {
                        htmlStr += "<tr>\n" +
                            "                    <td><input value=\"" + obj.id + "\" type=\"checkbox\"/></td>\n" +
                            "                    <td><a style=\"text-decoration: none; cursor: pointer;\"\n" +
                            "                           onclick=\"window.location.href='${pageContext.request.contextPath}/workbench/contacts/detail.do?id=" + obj.id + "';\">" + obj.fullName + "</a>\n" +
                            "                    </td>\n" +
                            "                    <td>" + obj.customerName + "</td>\n" +
                            "                    <td>" + obj.owner + "</td>\n" +
                            "                    <td>" + obj.source + "</td>\n" +
                            "                    <td>" + obj.birth + "</td>\n" +
                            "                </tr>";
                    });
                    //展示查询到的市场活动列表
                    $("#contactsList").html(htmlStr);
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
                            findContactsByCondition(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }
    </script>
</head>

<body>


<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <c:forEach items="${requestScope.userList}" var="owner">
                                    <option value="${owner.id}">${owner.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-source" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <c:forEach items="${requestScope.sourceList}" var="v">
                                    <option value="${v.value}">${v.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-fullName" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullName">
                            <span id="createFullNameMsg" style="font-size: 14px;"></span>
                        </div>
                        <label for="create-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <c:forEach items="${requestScope.appellationList}" var="v">
                                    <option value="${v.value}">${v.value}</option>
                                </c:forEach>
                            </select>
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                        <label for="create-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="create-birth" readonly>
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建">
                            <input type="text" id="create-customerId" hidden>
                            <span id="createCustomerNameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="create-nextContactTime" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>

                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address">北京大兴区大族企业湾</textarea>
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

<!-- 修改联系人的模态窗口 -->
<div class="modal fade" id="editContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="text" id="contactsId" hidden>
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${requestScope.userList}" var="owner">
                                    <option value="${owner.id}">${owner.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-source" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <c:forEach items="${requestScope.sourceList}" var="v">
                                    <option value="${v.value}">${v.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-fullName" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullName" value="李四">
                            <span id="editFullNameMsg" style="font-size: 14px;"></span>
                        </div>
                        <label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <c:forEach items="${requestScope.appellationList}" var="v">
                                    <option value="${v.value}">${v.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                        <label for="edit-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="edit-birth" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建" value="">
                            <input type="text" id="edit-customerId" hidden>
                            <span id="editCustomerNameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="edit-nextContactTime" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>

                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
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
    <div style="position: relative; margin-left: 10px; top: -10px;">
        <div class="page-header">
            <h3>联系人列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; margin-left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; padding-left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; margin-left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <select class="form-control" id="owner">
                            <option value=""></option>
                            <c:forEach items="${requestScope.userList}" var="owner">
                                <option value="${owner.id}">${owner.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">姓名</div>
                        <input id="fullName" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input id="customerName" class="form-control" type="text">
                        <input id="customerId" type="text" hidden>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="source">
                            <option value=""></option>
                            <c:forEach items="${requestScope.sourceList}" var="v">
                                <option value="${v.value}">${v.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">生日</div>
                        <input id="birth" class="form-control myDate" type="text" readonly>
                    </div>
                </div>

                <button id="search" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
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
        <div style="position: relative;top: 20px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="allSelectBox" type="checkbox"/></td>
                    <td>姓名</td>
                    <td>客户名称</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>生日</td>
                </tr>
                </thead>
                <tbody id="contactsList">
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 10px;" id="pageDiv">
        </div>

    </div>

</div>
</body>

</html>