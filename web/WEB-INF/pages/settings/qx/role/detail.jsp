<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <meta charset="UTF-8">
    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/jquery/zTree_v3-master/css/zTreeStyle/zTreeStyle.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/zTree_v3-master/js/jquery.ztree.all.min.js"></script>

    <SCRIPT type="text/javascript">
        let isCode = true;
        let isName = true;

        $(function () {
            let setting = {
                data: {
                    simpleData: {
                        enable: true
                    }
                }
            };

            let zNodes = new Array();

            //异步请求查找当前角色所拥有的许可树
            $.ajax({
                url:"${pageContext.request.contextPath}/settings/qx/role/queryPermissionByRoleId.do",
                data:{
                    id:"${requestScope.role.id}"
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    $.each(data, function (index, obj) {
                        zNodes.push({
                            id:obj.id,
                            pId:obj.pid,
                            name:obj.name,
                            open:true
                        });
                    });
                    $.fn.zTree.init($("#roleTree"), setting, zNodes);
                }
            });

            let setting2 = {
                data: {
                    simpleData: {
                        enable: true
                    }
                },
                check: {
                    enable: true
                }
            };

            let zNodes2 = new Array();

            //异步请求取得整颗许可树
            $.ajax({
                url:"${pageContext.request.contextPath}/settings/qx/permission/queryAllPermission.do",
                type:"post",
                dataType:"json",
                success:function (data) {
                    $.each(data.data, function (index, obj) {
                        let node = {
                            id: obj.id,
                            pId: obj.pid,
                            name: obj.name,
                            checked:false,
                            open:false
                        };
                        zNodes2.push(node);
                    });
                    //初始化树
                    $.fn.zTree.init($("#permissionTree"), setting2, zNodes2);
                }
            });

            //给编辑按钮添加单击事件
            $("#editBtn").click(function () {
                $("#editRoleModal").modal("show");
            });

            //给代码输入框添加失去焦点事件
            $("#edit-roleCode").blur(function () {
                const code = $.trim($(this).val());
                if (code == ""){
                    $("#codeMsg").text("代码不能为空!");
                    $("#codeMsg").css("color", "red");
                    isCode = false;
                }else{
                    $("#codeMsg").text("✓");
                    $("#codeMsg").css("color", "green");
                    isCode = true;
                }
            });

            //给名称输入框添加失去焦点事件
            $("#edit-roleName").blur(function () {
                const name = $.trim($(this).val());
                if (name == ""){
                    $("#nameMsg").text("名称不能为空!");
                    $("#nameMsg").css("color", "red");
                    isName = false;
                }else{
                    $("#nameMsg").text("✓");
                    $("#nameMsg").css("color", "green");
                    isName = true;
                }
            });

            //给更新按钮添加单击事件
            $("#confirmEditBtn").click(function () {
                if (!isCode || !isName){
                    return;
                }
                const code = $.trim($("#edit-roleCode").val());
                const name = $.trim($("#edit-roleName").val());
                const description = $.trim($("#edit-description").val());
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/qx/role/editRole.do",
                    data:{
                        id:"${requestScope.role.id}",
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
                            $("#codeB").text(code);
                            $("#nameB").text(name);
                            $("#nameBB").text(name);
                            $("#descriptionB").text(description);
                            $("#editRoleModal").modal("hide");
                        }
                    }
                });
            });

            //给取消更新按钮添加单击事件
            $("#closeEditBtn").click(function () {
                $("#editRoleModal").modal("hide");
            });

            //给分配按钮添加单击事件
            $("#open-assignPermissionBtn").click(function () {
                const treeObj = $.fn.zTree.getZTreeObj("permissionTree");
                $.each(zNodes, function (index, obj) {
                    const node = treeObj.getNodeByParam("id", obj.id);
                    //勾选节点
                    treeObj.checkNode(node, true, false, false);
                    //展开节点
                    treeObj.expandNode(node, true, false, false, false);
                });
                $("#assignPermissionForRoleModal").modal("show");
            });

            //给分配按钮添加单击事件
            $("#confirm-assignPermissionBtn").click(function () {
                const treeObj = $.fn.zTree.getZTreeObj("permissionTree");
                const selectNodes = treeObj.getCheckedNodes(true);
                /**
                 * 许可id集合
                 * @type {any[]}
                 */
                let id = new Array();
                $.each(selectNodes, function (index, obj) {
                    id.push(this.id);
                });
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/qx/role/assignPermission.do",
                    data:{
                        roleId:"${requestScope.role.id}",
                        permissionIds:id
                    },
                    type:"post",
                    dataType:"json",
                    traditional:true,
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            const roleTree = $.fn.zTree.getZTreeObj("roleTree");
                            roleTree.destroy();
                            zNodes = new Array();
                            $.each(data.data, function (index, obj) {
                                zNodes.push({
                                    id:obj.id,
                                    pId:obj.pid,
                                    name:obj.name,
                                    open:true
                                });
                            });
                            $.fn.zTree.init($("#roleTree"), setting, zNodes);
                            treeObj.checkAllNodes(false);
                            $("#assignPermissionForRoleModal").modal("hide");
                        }
                    }
                });
            });

            //给取消分配按钮添加单击事件
            $("#close-assignPermissionBtn").click(function () {
                const treeObj = $.fn.zTree.getZTreeObj("permissionTree");
                treeObj.checkAllNodes(false);
                $("#assignPermissionForRoleModal").modal("hide");
            });
        });



    </SCRIPT>

</head>

<body>

    <!-- 分配许可的模态窗口 -->
    <div class="modal fade" id="assignPermissionForRoleModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 30%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
                    <h4 class="modal-title">为<b id="nameBB">${requestScope.role.name}</b>分配许可</h4>
                </div>
                <div class="modal-body">
                    <ul id="permissionTree" class="ztree"></ul>
                </div>
                <div class="modal-footer">
                    <button id="close-assignPermissionBtn" type="button" class="btn btn-default">取消</button>
                    <button id="confirm-assignPermissionBtn" type="button" class="btn btn-primary">分配</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改角色的模态窗口 -->
    <div class="modal fade" id="editRoleModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 80%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
                    <h4 class="modal-title">修改角色</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-roleCode" class="col-sm-2 control-label">代码<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-roleCode" style="width: 200%;" value="${requestScope.role.code}">
                                <span id="codeMsg" style="font-size: 14px;"></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-roleName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-roleName" style="width: 200%;" value="${requestScope.role.name}">
                                <span id="nameMsg" style="font-size: 14px;"></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-description" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 65%;">
                                <textarea class="form-control" rows="3" id="edit-description">${requestScope.role.description}</textarea>
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
        <div style="position: relative; margin-left: 30px; top: -10px;">
            <div class="page-header">
                <h3>角色明细 <small>管理员</small></h3>
            </div>
            <div style="position: relative; height: 50px; width: 250px;  top: -72px; margin-left: 80%;">
                <button type="button" class="btn btn-default" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"></span> 返回</button>
            </div>
        </div>
    </div>

    <div style="position: relative; margin-left: 60px; top: -50px;">
        <ul id="myTab" class="nav nav-pills">
            <li class="active"><a href="#role-info" data-toggle="tab">角色信息</a></li>
            <li><a href="#permission-info" data-toggle="tab">许可信息</a></li>
        </ul>
        <div id="myTabContent" class="tab-content">
            <div class="tab-pane fade in active" id="role-info">
                <div style="position: relative; top: 20px; margin-left: -30px;">
                    <div style="position: relative; margin-left: 40px; height: 30px; top: 20px;">
                        <div style="width: 300px; color: gray;">代码</div>
                        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;"><b id="codeB">${requestScope.role.code}</b></div>
                        <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                    </div>
                    <div style="position: relative; margin-left: 40px; height: 30px; top: 40px;">
                        <div style="width: 300px; color: gray;">名称</div>
                        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;"><b id="nameB">${requestScope.role.name}</b></div>
                        <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                    </div>
                    <div style="position: relative; margin-left: 40px; height: 30px; top: 60px;">
                        <div style="width: 300px; color: gray;">描述</div>
                        <div style="width: 200px;position: relative; margin-left: 200px; top: -20px;"><b id="descriptionB" style="display: inline-block;min-height: 20px;">${requestScope.role.description}</b></div>
                        <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
                        <button id="editBtn" style="position: relative; margin-left: 76%;" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
                    </div>
                </div>
            </div>
            <div class="tab-pane fade" id="permission-info">
                <div style="position: relative; top: 20px; margin-left: 0px;">
                    <ul id="roleTree" class="ztree" style="position: relative; top: 15px; margin-left: 15px;"></ul>
                    <div style="position: relative;top: 30px; margin-left: 76%;">
                        <button id="open-assignPermissionBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 分配许可</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>

</html>