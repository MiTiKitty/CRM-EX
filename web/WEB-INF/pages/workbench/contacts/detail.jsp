<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>

<head>
    <meta charset="UTF-8">

    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css"
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

    <script type="text/javascript">
        //默认情况下取消和保存按钮是隐藏的
        let cancelAndSaveBtnDefault = true;
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

            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                $("#remark").val("");
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $("#contactsRemark").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            $("#contactsRemark").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            $("#contactsRemark").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            $("#contactsRemark").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
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

            //给编辑按钮添加单击事件
            $("#editBtn").click(function () {
                $("#editContactsModal").modal("show");
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
                const value = $("#edit-owner").val().split('-');
                const ownerName = value[0];
                const id = "${requestScope.contacts.id}";
                const owner = value[1];
                const source = $("#edit-source").val();
                const fullName = $.trim($("#edit-fullName").val());
                const appellation = $("#edit-appellation").val();
                const customerName = $("#edit-customerName").val();
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
                            $("#owner").text(ownerName);
                            $("#source").text(source);
                            $("#customerName").text(customerName);
                            $("#name").text(fullName + appellation);
                            $("#email").text(email);
                            $("#mphone").text(mphone);
                            $("#job").text(job);
                            $("#birth").text(birth);
                            $("#editBy").text("${sessionScope.sessionUser.name}    ");
                            $("#editTime").text(dateFormat(new Date()));
                            $("#description").text(description);
                            $("#contactSummary").text(contactSummary);
                            $("#nextContactTime").text(nextContactTime);
                            $("#address").text(address);
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
                const id = new Array();
                id.push("${requestScope.contacts.id}");
                if (window.confirm("你确定要删除客户信息吗？")){
                    $.ajax({
                        url:"${pageContext.request.contextPath}/workbench/contacts/removeContacts.do",
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
                                window.history.back();
                            }
                        }
                    });
                }
            });

            //给保存备注按钮添加单击事件
            $("#saveRemarkBtn").click(function () {
                const noteContent = $.trim($("#remark").val());
                if (noteContent == '') {
                    alert("备注信息不能为空！");
                    return;
                }
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/contacts/createContactsRemark.do",
                    data: {
                        noteContent: noteContent,
                        contactsId:"${requestScope.contacts.id}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == "1") {
                            const htmlStr = "<div id=\"div-" + data.data.id + "\" class=\"remarkDiv\" style=\"height: 60px;\">\n" +
                                "            <img title=\"" + data.data.notePerson + "\" src=\"${pageContext.request.contextPath}/image/user-thumbnail.png\"\n" +
                                "                 style=\"width: 30px; height:30px;\">\n" +
                                "            <div style=\"position: relative; top: -40px; margin-left: 40px;\">\n" +
                                "                <h5>" + data.data.noteContent + "</h5>\n" +
                                "                <font color=\"gray\">联系人</font>\n" +
                                "                <font color=\"gray\">-</font> <b>${requestScope.contacts.fullName}${requestScope.contacts.appellation}\n" +
                                "                - ${requestScope.contacts.customerName}</b> <small\n" +
                                "                    style=\"color: gray;\"> " + data.data.noteTime + " 由 " + data.data.notePerson + " 创建</small>\n" +
                                "                <div style=\"position: relative; margin-left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">\n" +
                                "                    <a class=\"myHref\" name=\"edit\" remarkId=\"" + data.data.id + "\" href=\"javascript:void(0);\"><span\n" +
                                "                            class=\"glyphicon glyphicon-edit\"\n" +
                                "                            style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
                                "                    &nbsp;&nbsp;&nbsp;&nbsp;\n" +
                                "                    <a class=\"myHref\" name=\"remove\" remarkId=\"" + data.data.id + "\" href=\"javascript:void(0);\"><span\n" +
                                "                            class=\"glyphicon glyphicon-remove\"\n" +
                                "                            style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
                                "                </div>\n" +
                                "            </div>\n" +
                                "        </div>";
                            $("#remarkDiv").before(htmlStr);
                            $("#cancelBtn").click();
                        }
                    }
                });
            });

            //给备注编辑图标添加单击事件
            $("#contactsRemark").on("click", "a[name='edit']", function () {
                const id = $(this).attr("remarkId");
                const remark = $("#div-" + id + " h5").text();
                $("#remarkId").val(id);
                $("#noteContent").val(remark);
                $("#editRemarkModal").modal("show");
            });

            //给更新备注按钮添加单击事件
            $("#editRemarkBtn").click(function () {
                const id = $("#remarkId").val();
                const noteContent = $.trim($("#noteContent").val());
                if (noteContent == '') {
                    alert("备注信息不能为空！");
                    return;
                }
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/contacts/editContactsRemark.do",
                    data: {
                        id: id,
                        noteContent: noteContent
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == "1") {
                            $("#div-" + id + " h5").text(noteContent);
                            $("#div-" + id + " small").text(data.data.editTime + " 由 " + data.data.editPerson + "修改");
                            $("#editRemarkModal").modal("hide");
                        }
                    }
                });
            });

            //给关闭按钮添加单击事件
            $("#closeBtn").click(function () {
                $("#editRemarkModal").modal("hide");
            });

            //给删除图标谭家单击事件
            $("#contactsRemark").on("click", "a[name='remove']", function () {
                const id = $(this).attr("remarkId");
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/contacts/removeContactsRemark.do",
                    data: {
                        id: id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == '1') {
                            $("#div-" + id).remove();
                        }
                    }
                });
            });

        });

        /**
         * 格式化时间
         * @param d
         * @returns {string}
         */
        function dateFormat(d) {
            return d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate() + ' ' + d.toLocaleTimeString();
        }
    </script>

</head>

<body>

<!-- 解除联系人和市场活动关联的模态窗口 -->
<div class="modal fade" id="unbundActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">解除关联</h4>
            </div>
            <div class="modal-body">
                <p>您确定要解除该关联关系吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" data-dismiss="modal">解除</button>
            </div>
        </div>
    </div>
</div>

<!-- 联系人和市场活动关联的模态窗口 -->
<div class="modal fade" id="bundActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; margin-left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable2" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td><input type="checkbox"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal">关联</button>
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
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${requestScope.userList}" var="owner">
                                    <option <c:if test="${requestScope.contacts.owner.equals(owner.name)}">
                                        selected
                                    </c:if> value="${owner.name}-${owner.id}">${owner.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-source" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <c:forEach items="${requestScope.sourceList}" var="v">
                                    <option <c:if test="${requestScope.contacts.source.equals(v.value)}">
                                        selected
                                    </c:if> value="${v.value}">${v.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-fullName" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullName"
                                   value="${requestScope.contacts.fullName}">
                            <span id="editFullNameMsg" style="font-size: 14px;"></span>
                        </div>
                        <label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <c:forEach items="${requestScope.appellationList}" var="v">
                                    <option <c:if test="${requestScope.contacts.appellation.equals(v.value)}">
                                        selected
                                    </c:if> value="${v.value}">${v.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="${requestScope.contacts.job}">
                        </div>
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone"
                                   value="${requestScope.contacts.mphone}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email"
                                   value="${requestScope.contacts.email}">
                        </div>
                        <label for="edit-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myDate" id="edit-birth" readonly
                                   value="${requestScope.contacts.birth}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建" value="${requestScope.contacts.customerName}">
                            <input type="text" id="edit-customerId" hidden value="${requestScope.contacts.customerId}">
                            <span id="editCustomerNameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3"
                                      id="edit-description">${requestScope.contacts.description}</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="edit-nextContactTime" readonly
                                       value="${requestScope.contacts.nextContactTime}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3"
                                          id="edit-contactSummary">${requestScope.contacts.contactSummary}</textarea>
                            </div>
                        </div>

                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1"
                                          id="edit-address">${requestScope.contacts.address}</textarea>
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

<!-- 修改备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="noteContent" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" id="closeBtn">关闭</button>
                <button type="button" class="btn btn-primary" id="editRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; margin-left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; margin-left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${requestScope.contacts.fullName}${requestScope.contacts.appellation} <small>
            - ${requestScope.contacts.customerName}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; margin-left: 700px;">
        <button id="editBtn" type="button" class="btn btn-default"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button id="removeBtn" type="button" class="btn btn-danger"><span
                class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; margin-left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;"><b
                id="owner">${requestScope.contacts.owner}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;"><b
                id="source">${requestScope.contacts.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;"><b
                id="customerName">${requestScope.contacts.customerName}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">姓名</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;"><b
                id="name">${requestScope.contacts.fullName}${requestScope.contacts.appellation}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;"><b
                id="email">${requestScope.contacts.email}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;"><b
                id="mphone">${requestScope.contacts.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;"><b
                id="job">${requestScope.contacts.job}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">生日</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;"><b
                id="birth">&nbsp;${requestScope.contacts.birth}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.contacts.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${requestScope.contacts.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;"><b
                id="editBy">${requestScope.contacts.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;" id="editTime">${requestScope.contacts.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; margin-left: 200px; top: -20px;">
            <b id="description">
                ${requestScope.contacts.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; margin-left: 200px; top: -20px;">
            <b id="contactSummary">
                &nbsp;${requestScope.contacts.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;"><b
                id="nextContactTime">&nbsp;${requestScope.contacts.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; margin-left: 200px; top: -20px;">
            <b id="address">
                ${requestScope.contacts.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>
<!-- 备注 -->
<div id="contactsRemark" style="position: relative; top: 20px; margin-left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <c:forEach items="${requestScope.contactsRemarkList}" var="remark">
        <div id="div-${remark.id}" class="remarkDiv" style="height: 60px;">
            <img title="${remark.notePerson}" src="${pageContext.request.contextPath}/image/user-thumbnail.png"
                 style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; margin-left: 40px;">
                <h5>${remark.noteContent}</h5>
                <font color="gray">联系人</font>
                <font color="gray">-</font> <b>${requestScope.contacts.fullName}${requestScope.contacts.appellation}
                - ${requestScope.contacts.customerName}</b> <small
                    style="color: gray;"> ${remark.showTime}&nbsp;
                由 ${remark.showPerson}${remark.editFlag == '1' ? " 修改" : " 创建"}</small>
                <div style="position: relative; margin-left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" name="edit" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-edit"
                            style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" name="remove" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-remove"
                            style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; margin-left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;margin-left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 交易 -->
<div>
    <div style="position: relative; top: 20px; margin-left: 40px;">
        <div class="page-header">
            <h4>交易</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable3" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>金额</td>
                    <td>阶段</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>类型</td>
                    <td></td>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><a href="../transaction/detail.jsp" style="text-decoration: none;">动力节点-交易01</a></td>
                    <td>5,000</td>
                    <td>谈判/复审</td>
                    <td>90</td>
                    <td>2017-02-07</td>
                    <td>新业务</td>
                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal"
                           style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
                </tr>
                </tbody>
            </table>
        </div>

        <div>
            <a href="../transaction/create.jsp" style="text-decoration: none;"><span
                    class="glyphicon glyphicon-plus"></span>新建交易</a>
        </div>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; margin-left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><a href="../activity/detail.jsp" style="text-decoration: none;">发传单</a></td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                    <td>zhangsan</td>
                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundActivityModal"
                           style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                </tr>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" data-toggle="modal" data-target="#bundActivityModal"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>

</html>