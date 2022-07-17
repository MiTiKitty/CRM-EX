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
            src="${pageContext.request.contextPath}/jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_pagination-master/localization/en.min.js"></script>

    <script type="text/javascript">
        let thePageSize = 10;
        let isCreateName = false;
        let isEditName = true;

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

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            //给查询按钮添加单击事件
            $("#searchBtn").click(function () {
                findCustomerByCondition(1, thePageSize);
            });

            //给创建按钮添加单击事件
            $("#createBtn").click(function () {
                $("form").get(0).reset();
                $("#createCustomerModal").modal("show");
            });

            //给创建名称输入框添加失去焦点事件
            $("#create-name").blur(function () {
                const name = $.trim($(this).val());
                if (name == ''){
                    $("#createNameMsg").css("color", "red");
                    $("#createNameMsg").text("名称不能为空!");
                    isCreateName = false;
                }else {
                    $("#createNameMsg").css("color", "green");
                    $("#createNameMsg").text("✓");
                    isCreateName = true;
                }
            });

            //给保存按钮添加单击事件
            $("#saveCreateBtn").click(function () {
                if (!isCreateName){
                    alert("表单填写有误！");
                    return;
                }
                const owner = $("#create-owner").val();
                const name = $.trim($("#create-name").val());
                const website = $.trim($("#create-website").val());
                const phone = $.trim($("#create-phone").val());
                const grade = $("#create-grade").val();
                const industry = $("#create-industry").val();
                const description = $.trim($("#create-description").val());
                const address = $.trim($("#create-address").val());
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/customer/createCustomer.do",
                    data:{
                        owner:owner,
                        name:name,
                        website:website,
                        phone:phone,
                        grade:grade,
                        industry:industry,
                        description:description,
                        address:address
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            findCustomerByCondition(1, thePageSize);
                            $("#createCustomerModal").modal("hide");
                        }
                    }
                });
            });

            //给取消保存按钮添加单击事件
            $("#closeCreateBtn").click(function () {
                $("#createCustomerModal").modal("hide");
            });

            //给全选按钮添加单击事件
            $("#allSelectBox").click(function () {
                const isCheck = $(this).prop("checked");
                $("#customerList input[type='checkbox']").prop("checked", isCheck);
            });

            //给单个选择按钮添加单击事件
            $("#customerList").on("click", "input[type='checkbox']", function () {
                const checkedSize = $("#customerList input[type='checkbox']:checked").size();
                const allSize = $("#customerList input[type='checkbox']").size();
                if (checkedSize == allSize) {
                    $("#allSelectBox").prop("checked", true);
                } else {
                    $("#allSelectBox").prop("checked", false);
                }
            });

            //给修改按钮添加单击事件
            $("#editBtn").click(function () {
                const obj = $("#customerList input[type='checkbox']:checked");
                if (obj.length == 0 || obj.length > 1){
                    alert("只能选择一条客户信息进行修改操作!");
                    return;
                }
                const id = obj[0].value;
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/customer/queryCustomerById.do",
                    data:{
                        id:id
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        $("#customerId").val(data.id);
                        $("#edit-owner").val(data.owner);
                        $("#edit-name").val(data.name);
                        $("#edit-grade").val(data.grade);
                        $("#edit-phone").val(data.phone);
                        $("#edit-website").val(data.website);
                        $("#edit-industry").val(data.industry);
                        $("#edit-description").val(data.description);
                        $("#edit-address").val(data.address);
                        $("#editCustomerModal").modal("show");
                    }
                });
            });

            //给修改名称输入框添加失去焦点事件
            $("#edit-name").blur(function () {
                const name = $.trim($(this).val());
                if (name == ''){
                    $("#editNameMsg").css("color", "red");
                    $("#editNameMsg").text("名称不能为空!");
                    isEditName = false;
                }else {
                    $("#editNameMsg").css("color", "green");
                    $("#editNameMsg").text("✓");
                    isEditName = true;
                }
            });

            //给更新按钮添加单击事件
            $("#confirmEditBtn").click(function () {
                if (!isEditName){
                    alert("表单填写有误！");
                    return;
                }
                const id = $("#customerId").val();
                const owner = $("#edit-owner").val();
                const name = $.trim($("#edit-name").val());
                const website = $.trim($("#edit-website").val());
                const phone = $.trim($("#edit-phone").val());
                const grade = $("#edit-grade").val();
                const industry = $("#edit-industry").val();
                const description = $.trim($("#edit-description").val());
                const address = $.trim($("#edit-address").val());
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/customer/editCustomer.do",
                    data:{
                        id:id,
                        owner:owner,
                        name:name,
                        website:website,
                        phone:phone,
                        grade:grade,
                        industry:industry,
                        description:description,
                        address:address
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            findCustomerByCondition(1, thePageSize);
                            $("#editCustomerModal").modal("hide");
                        }
                    }
                });
            });

            //给取消更显按钮添加单击事件
            $("#closeEditBtn").click(function () {
                $("#editCustomerModal").modal("hide");
            });

            //给删除按钮添加单击事件
            $("#removeBtn").click(function () {
                const customers = $("#customerList input[type='checkbox']:checked");
                if (customers.length == 0){
                    alert("至少需要选择一条客户信息进行删除操作!");
                    return;
                }
                const id = new Array();
                $.each(customers, function (index, obj) {
                    id.push(obj.value);
                });
                if (window.confirm("确定要删除吗")){
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
                                findCustomerByCondition(1, thePageSize);
                            }
                        }
                    });
                }
            });

            findCustomerByCondition();
        });

        /**
         * 条件分页查询
         * @param pageNo
         * @param pageSize
         */
        function findCustomerByCondition(pageNo = 1, pageSize = 10) {
            const name = $.trim($("#name").val());
            const owner = $("#owner").val();
            const phone = $.trim($("#phone").val());
            const website = $.trim($("#website").val());
            $.ajax({
                url:"${pageContext.request.contextPath}/workbench/customer/queryCustomerByCondition.do",
                data:{
                    name:name,
                    owner:owner,
                    phone:phone,
                    website:website,
                    pageNo:pageNo,
                    pageSize:pageSize
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    let htmlStr = "";
                    $.each(data.customerList, function (index, obj) {
                        htmlStr += "<tr id='tr-"+obj.id+"'>\n" +
                            "                    <td><input value=\""+obj.id+"\" type=\"checkbox\"/></td>\n" +
                            "                    <td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='${pageContext.request.contextPath}/workbench/customer/detail.do?id="+obj.id+"';\">"+obj.name+"</a>\n" +
                            "                    </td>\n" +
                            "                    <td>"+obj.owner+"</td>\n" +
                            "                    <td>"+obj.phone+"</td>\n" +
                            "                    <td>"+obj.website+"</td>\n" +
                            "                </tr>";
                    });
                    //展示查询到的市场活动列表
                    $("#customerList").html(htmlStr);
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
                            findCustomerByCondition(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }
    </script>
</head>

<body>

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
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
                        <label for="create-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                            <span id="createNameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone" maxlength="11">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-grade" class="col-sm-2 control-label">等级</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-grade">
                                <c:forEach items="${requestScope.gradeList}" var="grade">
                                    <option value="${grade.value}">${grade.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-industry" class="col-sm-2 control-label">行业</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-industry">
                                <c:forEach items="${requestScope.industryList}" var="industry">
                                    <option value="${industry.value}">${industry.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>
                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; margin-left: -13px; position: relative;"></div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

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
                                    <option value="${owner.id}">${owner.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" value="动力节点">
                            <span id="editNameMsg" style="font-size: 14px;"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website" value="">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" maxlength="11" value="">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-grade" class="col-sm-2 control-label">等级</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-grade">
                                <c:forEach items="${requestScope.gradeList}" var="grade">
                                    <option value="${grade.value}">${grade.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-industry" class="col-sm-2 control-label">行业</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-industry">
                                <c:forEach items="${requestScope.industryList}" var="industry">
                                    <option value="${industry.value}">${industry.value}</option>
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
                <button id="confirmEditBtn" type="button" class="btn btn-primary">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; margin-left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
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
                        <input class="form-control" type="text" id="name">
                    </div>
                </div>

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
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" type="text" id="website">
                    </div>
                </div>

                <button id="searchBtn" type="button" class="btn btn-default">查询</button>

            </form>
        </div>

        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
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
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="allSelectBox" type="checkbox"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="customerList">
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;" id="pageDiv">
        </div>

    </div>

</div>
</body>

</html>