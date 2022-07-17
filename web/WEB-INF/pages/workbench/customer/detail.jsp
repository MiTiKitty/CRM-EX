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

    <script type="text/javascript">
        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;
        let isEditName = true;

        $(function () {
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

            $("#customerRemark").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            $("#customerRemark").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            $("#customerRemark").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            $("#customerRemark").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            //给编辑按钮添加单击事件
            $("#editBtn").click(function () {
                $("#editCustomerModal").modal("show");
            });

            //给修改名称输入框添加失去焦点事件
            $("#edit-name").blur(function () {
                const name = $.trim($(this).val());
                if (name == '') {
                    $("#editNameMsg").css("color", "red");
                    $("#editNameMsg").text("名称不能为空!");
                    isEditName = false;
                } else {
                    $("#editNameMsg").css("color", "green");
                    $("#editNameMsg").text("✓");
                    isEditName = true;
                }
            });

            //给更新按钮添加单击事件
            $("#confirmEditBtn").click(function () {
                if (!isEditName) {
                    alert("表单填写有误！");
                    return;
                }
                const value = $("#edit-owner").val().split('-');
                const ownerName = value[0];
                const id = "${requestScope.customer.id}";
                const owner = value[1];
                const name = $.trim($("#edit-name").val());
                const website = $.trim($("#edit-website").val());
                const phone = $.trim($("#edit-phone").val());
                const grade = $("#edit-grade").val();
                const industry = $("#edit-industry").val();
                const description = $.trim($("#edit-description").val());
                const address = $.trim($("#edit-address").val());
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/customer/editCustomer.do",
                    data: {
                        id: id,
                        owner: owner,
                        name: name,
                        website: website,
                        phone: phone,
                        grade: grade,
                        industry: industry,
                        description: description,
                        address: address
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == "1") {
                            $("#owner").text(ownerName);
                            $("#name").text(name);
                            $("#phone").text(phone);
                            $("#website").text(website);
                            $("#description").text(description);
                            $("#address").text(address);
                            $("#editBy").text("${sessionScope.sessionUser.name}  ");
                            $("#editTime").text(dateFormat(new Date()));
                            $("#editCustomerModal").modal("hide");
                        }
                    }
                });
            });

            //给取消更新按钮添加单击事件
            $("#closeEditBtn").click(function () {
                $("#editCustomerModal").modal("hide");
            });

            //给删除按钮添加单击事件
            $("#removeBtn").click(function () {
                const id = new Array();
                id.push("${requestScope.customer.id}");
                if (window.confirm("你确定要删除客户信息吗？")){
                    $.ajax({
                        url:"${pageContext.request.contextPath}/workbench/customer/removeCustomer.do",
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
                    alert("备注信息不能为空");
                    return;
                }
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/customer/createCustomerRemark.do",
                    data: {
                        noteContent: noteContent,
                        customerId: "${requestScope.customer.id}"
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
                                "                <font color=\"gray\">客户</font>\n" +
                                "                <font color=\"gray\">-</font> <b>${requestScope.customer.name}</b> <small\n" +
                                "                    style=\"color: gray;\"> " + data.data.noteTime + " 由 " + data.data.notePerson + " 创建\</small>\n" +
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
            $("#customerRemark").on("click", "a[name='edit']", function () {
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
                if (noteContent == ''){
                    alert("备注信息不能为空！");
                    return;
                }
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/customer/editCustomerRemark.do",
                    data:{
                        id:id,
                        noteContent:noteContent
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            $("#div-" + id + " h5").text(noteContent);
                            $("#div-" + id + " small").text(data.data.editTime + " 由" + data.data.editPerson + "修改");
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
            $("#customerRemark").on("click", "a[name='remove']", function () {
                const id = $(this).attr("remarkId");
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/customer/removeCustomerRemarkById.do",
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

            //
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

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input id="customerId" hidden>
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${requestScope.userList}" var="owner">
                                    <option <c:if test="${requestScope.customer.owner.equals(owner.name)}">
                                        selected
                                    </c:if> value="${owner.name}-${owner.id}">${owner.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <input type="text" id="ownerName" hidden>
                        <label for="edit-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name"
                                   value="${requestScope.customer.name}">
                            <span id="editNameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="${requestScope.customer.website}">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" maxlength="11"
                                   value="${requestScope.customer.phone}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-grade" class="col-sm-2 control-label">等级</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-grade">
                                <c:forEach items="${requestScope.gradeList}" var="grade">
                                    <option <c:if test="${requestScope.customer.grade.equals(grade.value)}">
                                        selected
                                    </c:if> value="${grade.value}">${grade.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-industry" class="col-sm-2 control-label">行业</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-industry">
                                <c:forEach items="${requestScope.industryList}" var="industry">
                                    <option <c:if test="${requestScope.customer.industry.equals(industry.value)}">
                                        selected
                                    </c:if> value="${industry.value}">${industry.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3"
                                      id="edit-description">${requestScope.customer.description}</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative;"></div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1"
                                          id="edit-address">${requestScope.customer.address}</textarea>
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

<!-- 删除联系人的模态窗口 -->
<div class="modal fade" id="removeContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除联系人</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该联系人吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" data-dismiss="modal">删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 删除交易的模态窗口 -->
<div class="modal fade" id="removeTransactionModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除交易</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该交易吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" data-dismiss="modal">删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-contactsOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueSource">
                                <option></option>
                                <option>广告</option>
                                <option>推销电话</option>
                                <option>员工介绍</option>
                                <option>外部介绍</option>
                                <option>在线商场</option>
                                <option>合作伙伴</option>
                                <option>公开媒介</option>
                                <option>销售邮件</option>
                                <option>合作伙伴研讨会</option>
                                <option>内部研讨会</option>
                                <option>交易会</option>
                                <option>web下载</option>
                                <option>web调研</option>
                                <option>聊天</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <option></option>
                                <option>先生</option>
                                <option>夫人</option>
                                <option>女士</option>
                                <option>博士</option>
                                <option>教授</option>
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
                            <input type="text" class="form-control" id="create-birth">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address1">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
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
        <h3>${requestScope.customer.name} <small><a href="${requestScope.customer.website}" target="_blank">${requestScope.customer.website}</a></small>
        </h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; margin-left: 700px;">
        <button id="editBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button id="removeBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除
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
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b id="owner">${requestScope.customer.owner}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;">
            <b id="name">${requestScope.customer.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b id="website">${requestScope.customer.website}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;">
            <b id="phone">${requestScope.customer.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.customer.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${requestScope.customer.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;"><b
                id="editBy">${requestScope.customer.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;" id="editTime">${requestScope.customer.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; margin-left: 200px; top: -20px;">
            <b id="description">
                ${requestScope.customer.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; margin-left: 200px; top: -20px;">
            <b id="address">
                ${requestScope.customer.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="customerRemark" style="position: relative; top: 10px; margin-left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <c:forEach items="${requestScope.remarkList}" var="remark">
        <div id="div-${remark.id}" class="remarkDiv" style="height: 60px;">
            <img title="${remark.notePerson}" src="${pageContext.request.contextPath}/image/user-thumbnail.png"
                 style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; margin-left: 40px;">
                <h5>${remark.noteContent}</h5>
                <font color="gray">客户</font>
                <font color="gray">-</font> <b>${requestScope.customer.name}</b> <small
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
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>金额</td>
                    <td>阶段</td>
                    <td>预计成交日期</td>
                    <td>类型</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="transactionList">
                <tr>
                    <td><a href="" style="text-decoration: none;">动力节点-交易01</a></td>
                    <td>5,000</td>
                    <td>谈判/复审</td>
                    <td>2017-02-07</td>
                    <td>新业务</td>
                    <td><a name="removeTransaction" href="javascript:void(0);" style="text-decoration: none;"><span
                            class="glyphicon glyphicon-remove"></span>删除</a></td>
                </tr>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
        </div>
    </div>
</div>

<!-- 联系人 -->
<div>
    <div style="position: relative; top: 20px; margin-left: 40px;">
        <div class="page-header">
            <h4>联系人</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>邮箱</td>
                    <td>手机</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="contactsList">
                <tr>
                    <td><a href="../contacts/detail.jsp" style="text-decoration: none;">李四</a></td>
                    <td>lisi@bjpowernode.com</td>
                    <td>13543645364</td>
                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal"
                           style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
                </tr>
                </tbody>
            </table>
        </div>

        <div>
            <a id="createContactsBtn" href="javascript:void(0);" style="text-decoration: none;"><span
                    class="glyphicon glyphicon-plus"></span>新建联系人</a>
        </div>
    </div>
</div>

<div style="height: 200px;"></div>
</body>

</html>