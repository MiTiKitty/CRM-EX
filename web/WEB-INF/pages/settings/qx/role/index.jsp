<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <meta charset="UTF-8">
    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bs_pagination-master/localization/en.min.js"></script>

    <script type="text/javascript">
        let thePageSize = 10;
        let isCode = false;
        let isName = false;

        $(function () {
            //先查找所有角色信息
            findAllRoleByPage();

            //给创建按钮添加单击事件
            $("#createBtn").click(function () {
                $("form").get(0).reset();
                $("#createRoleModal").modal("show");
            });

            //给代码输入框框添加失去焦点事件
            $("#create-roleCode").blur(function () {
                const code = $.trim($(this).val());
                if (code == ""){
                    $("#codeMsg").text("代码不能为空！");
                    $("#codeMsg").css("color", "red");
                    isCode = false;
                    return;
                }
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/qx/role/queryRoleByCode.do",
                    data:{
                        code:code
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            $("#codeMsg").text("✓");
                            $("#codeMsg").css("color", "green");
                            isCode = true;
                        }else if (data.code == "1"){
                            $("#codeMsg").text("代码已存在！");
                            $("#codeMsg").css("color", "red");
                            isCode = false;
                        }
                    }
                });
            });

            //给名称输入框添加失去焦点事件
            $("#create-roleName").blur(function () {
                const name = $.trim($(this).val());
                if (name == ""){
                    $("#nameMsg").text("名称不能为空！");
                    $("#nameMsg").css("color", "red");
                    isName = false;
                    return;
                }
                $("#nameMsg").text("✓");
                $("#nameMsg").css("color", "green");
                isName = true;
            });

            //给保存按钮添加单击事件
            $("#saveBtn").click(function () {
                if (!isCode || !isName){
                    return;
                }
                const code = $.trim($("#create-roleCode").val());
                const name = $.trim($("#create-roleName").val());
                const description = $.trim($("#create-description").val());
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/qx/role/createRole.do",
                    data:{
                        code:code,
                        name:name,
                        description:description
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            findAllRoleByPage(1, thePageSize);
                            isCode = false;
                            isName = false;
                            $("#createRoleModal").modal("hide");
                        }
                    }
                });
            });

            //给取消保存按钮添加单击事件
            $("#closeBtn").click(function () {
                $("#createRoleModal").modal("hide");
            });

            //给全选中按钮添加单击事件
            $("#allSelectBox").click(function () {
                const isCheck = $(this).prop("checked");
                $("#roleList input[type='checkbox']").prop("checked", isCheck);
            });

            //给单个选中按钮添加单击事件
            $("#roleList").on("click", "input[type='checkbox']", function () {
                if ($("#roleList input[type='checkbox']").size() == $("#roleList input[type='checkbox']:checked").size()){
                    $("#allSelectBox").prop("checked", true);
                }else {
                    $("#allSelectBox").prop("checked", false);
                }
            });

            //给删除按钮添加单击事件
            $("#removeBtn").click(function () {
                const box = $("#roleList input[type='checkbox']:checked");
                if (box.length == 0){
                    alert("至少需要选中一个进行删除操作!");
                    return;
                }
                let id = new Array();
                $.each(box, function (index, obj) {
                    id.push(this.value);
                });
                if (window.confirm("确定要删除该角色吗?")){
                    $.ajax({
                        url:"${pageContext.request.contextPath}/settings/qx/role/removeRoleByIds.do",
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
                                findAllRoleByPage(1, thePageSize);
                            }
                        }
                    });
                }
            });
        });

        //分页查找所有角色信息
        function findAllRoleByPage(pageNo = 1, pageSize = 10) {
            $.ajax({
                url:"${pageContext.request.contextPath}/settings/qx/role/queryAllRoleByPage.do",
                data:{
                    pageNo:pageNo,
                    pageSize:pageSize
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    let htmlStr = "";
                    $.each(data.roleList, function (index, obj) {
                        htmlStr += "<tr class=\"active\">\n" +
                            "                    <td><input type=\"checkbox\" value='"+obj.id+"' /></td>\n" +
                            "                    <td>"+(index + 1)+"</td>\n" +
                            "                    <td><a href=\"${pageContext.request.contextPath}/settings/qx/role/detail.do?id="+obj.id+"\" style=\"text-decoration: none;\">"+obj.code+"</a></td>\n" +
                            "                    <td><a href=\"${pageContext.request.contextPath}/settings/qx/role/detail.do?id="+obj.id+"\" style=\"text-decoration: none;\">"+obj.name+"</td>\n" +
                            "                    <td>"+obj.description+"</td>\n" +
                            "                </tr>";
                    });
                    $("#roleList").html(htmlStr);
                    let totalPages = data.totalRows % pageSize == 0 ? data.totalRows / pageSize : parseInt(data.totalRows / pageSize) + 1;
                    totalPages = data.totalRows == 0 ? 1 : totalPages;
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
                            findAllRoleByPage(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }
    </script>

</head>

<body>

    <!-- 创建角色的模态窗口 -->
    <div class="modal fade" id="createRoleModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 80%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
                    <h4 class="modal-title" id="myModalLabel">新增角色</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="create-roleCode" class="col-sm-2 control-label">代码<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-roleCode" style="width: 200%;">
                                <span id="codeMsg" style="font-size: 14px;"></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="create-roleName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-roleName" style="width: 200%;">
                                <span id="nameMsg" style="font-size: 14px;"></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="create-description" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 65%;">
                                <textarea class="form-control" rows="3" id="create-description"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button id="closeBtn" type="button" class="btn btn-default">关闭</button>
                    <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
                </div>
            </div>
        </div>
    </div>


    <div>
        <div style="position: relative; margin-left: 30px; top: -10px;">
            <div class="page-header">
                <h3>角色列表</h3>
            </div>
        </div>
    </div>
    <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative; margin-left: 30px;">
        <div class="btn-group" style="position: relative; top: 18%;">
            <button id="createBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
            <button id="removeBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
        </div>
    </div>
    <div style="position: relative; margin-left: 30px; top: 20px;">
        <table class="table table-hover">
            <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="allSelectBox" type="checkbox" /></td>
                    <td>序号</td>
                    <td>代码</td>
                    <td>名称</td>
                    <td>描述</td>
                </tr>
            </thead>
            <tbody id="roleList">
            </tbody>
        </table>
    </div>

    <div id="pageDiv"></div>

</body>

</html>