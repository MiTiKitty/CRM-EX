<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <meta charset="UTF-8">
    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/jquery/zTree_v3-master/css/zTreeStyle/zTreeStyle.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/zTree_v3-master/js/jquery.ztree.all.min.js"></script>

    <script type="text/javascript">
        let permission = null;
        let isInit = true;
        let thisPermission = null;

        $(function () {
            //设置zTree的基本操作序列
            const setting = {
                edit: {
                    enable: true,
                    showRenameBtn: false,
                    showRemoveBtn: true
                },
                data: {
                    simpleData: {
                        enable: true
                    }
                },
                callback: {
                    onClick: findPermissionDetail,
                    beforeDrag: function() {
                        return false;
                    },
                    beforeDrop: function() {
                        return false;
                    },
                    beforeRemove: removePermission
                }
            };

            let zNodes = new Array();

            //获取所有许可信息
            function findAllPermission() {
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/qx/permission/queryAllPermission.do",
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        $.each(data.data, function (index, obj) {
                            zNodes.push({
                                id: obj.id,
                                pId: obj.pid,
                                name: obj.name
                            });
                        });
                        if (isInit){
                            //初始化树
                            $.fn.zTree.init($("#tree"), setting, zNodes);
                            //获得树
                            const treeObj = $.fn.zTree.getZTreeObj("tree");
                            const treeNodes = treeObj.getNodes();
                            if (treeNodes != null || treeNodes.length > 0){
                                // 获取树第一个节点
                                const treeNode = treeNodes[0];
                                // 点击节点
                                $("#" + treeNode.tId + "_a").click();
                            }
                            isInit = false;
                        }
                    }
                });
            }

            findAllPermission();

            //点击许可获得许可详细信息
            function findPermissionDetail(event, treeId, treeNode, checked){
                thisPermission = treeNode;
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/qx/permission/queryPerDetailById.do",
                    data:{
                        id:treeNode.id
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        permission = data.data;
                        if (data.data == null){
                            $("#nameH").text("");
                            $("#nameB").text("");
                            $("#moduleUrlB").text("");
                            $("#operUrlB").text("");
                            $("#orderNoB").text("");
                            $("#editBtn").prop("disabled","disabled");
                        }else {
                            $("#nameH").text(data.data.name);
                            $("#nameB").text(data.data.name);
                            $("#moduleUrlB").text(data.data.moduleUrl);
                            $("#operUrlB").text(data.data.operUrl);
                            $("#orderNoB").text(data.data.orderNo);
                            $("editBtn").removeAttr("disabled");
                            $("#edit-permissionName").val(data.data.name);
                            $("#edit-moduleUrl").val(data.data.moduleUrl);
                            $("#edit-operationUrl").val(data.data.operUrl);
                            $("#edit-orderNo").val(data.data.orderNo);
                        }
                    }
                });
            }

            //给新增按钮添加单击事件、
            $("#createBtn").click(function () {
                $("form").get(0).reset();
                $("#createPermissionModal").modal("show");
            });

            //给保存按钮添加单击事件
            $("#saveBtn").click(function () {
                const pid = permission == null ? null : permission.id;
                const name = $.trim($("#create-permissionName").val());
                const moduleUrl = $.trim($("#create-moduleUrl").val());
                const operUrl = $.trim($("#create-operationUrl").val());
                const orderNo = $.trim($("#create-orderNo").val());
                if (name == ""){
                    alert("名称不能为空！");
                    return;
                }
                if (!/^\d{1,11}$/.test(orderNo)){
                    alert("排序号必须为数字！");
                    return;
                }
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/qx/permission/createPermission.do",
                    data:{
                        pid:pid,
                        name:name,
                        moduleUrl:moduleUrl,
                        operUrl:operUrl,
                        orderNo:orderNo
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            const treeObj = $.fn.zTree.getZTreeObj("tree");
                            const newNode = {
                                enable:true,
                                id:data.data.id,
                                pId:data.data.pid,
                                name:data.data.name
                            };
                            treeObj.addNodes(thisPermission, -1, newNode, false);
                            $("editBtn").removeAttr("disabled");
                            $("#createPermissionModal").modal("hide");
                        }
                    }
                });
            });

            //给关闭创建模态窗口按钮添加单击事件
            $("#closeSaveBtn").click(function () {
                $("#createPermissionModal").modal("hide");
            });

            //给编辑按钮添加单击事件
            $("#editBtn").click(function () {
                $("#editPermissionModal").modal("show");
            });

            //给更新按钮添加单击事件
            $("#confirmEditBtn").click(function () {
                const name = $.trim($("#edit-permissionName").val());
                const moduleUrl = $.trim($("#edit-moduleUrl").val());
                const operUrl = $.trim($("#edit-operationUrl").val());
                const orderNo = $.trim($("#edit-orderNo").val());
                if (name == ""){
                    alert("名称不能为空！");
                    return;
                }
                if (!/^\d{1,11}$/.test(orderNo)){
                    alert("排序号必须为数字！");
                    return;
                }
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/qx/permission/editPerById.do",
                    data:{
                        id:thisPermission.id,
                        name:name,
                        moduleUrl:moduleUrl,
                        operUrl:operUrl,
                        orderNo:orderNo
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            $("#nameH").text(data.data.name);
                            $("#nameB").text(data.data.name);
                            $("#moduleUrlB").text(data.data.moduleUrl);
                            $("#operUrlB").text(data.data.operUrl);
                            $("#orderNoB").text(data.data.orderNo);
                            $("editBtn").removeAttr("disabled");
                            $("#edit-permissionName").val(data.data.name);
                            $("#edit-moduleUrl").val(data.data.moduleUrl);
                            $("#edit-operationUrl").val(data.data.operUrl);
                            $("#edit-orderNo").val(data.data.orderNo);
                            thisPermission.name = data.data.name;
                            const treeObj = $.fn.zTree.getZTreeObj("tree");
                            treeObj.updateNode(thisPermission);
                            $("#editPermissionModal").modal("hide");
                        }
                    }
                });
            });

            //给取消更新按钮添加单击事件
            $("#closeEditBtn").click(function () {
                $("#editPermissionModal").modal("hide");
            });

            //删除事件
            function removePermission(treeId, treeNode) {
                if (confirm("确定要删除 " + treeNode.name + " 许可吗？")){
                    $.ajax({
                        url:"${pageContext.request.contextPath}/settings/qx/permission/removePerById.do",
                        data:{
                            id:treeNode.id
                        },
                        type:"post",
                        dataType:"json",
                        success:function (data) {
                            if (data.code == "0"){
                                alert(data.message);
                            }else if (data.code == "1") {
                                const treeObj = $.fn.zTree.getZTreeObj("tree");
                                treeObj.removeNode(treeNode, false);
                                const treeNodes = treeObj.getNodes();
                                if (treeNodes != null || treeNodes.length > 0){
                                    // 获取树第一个节点
                                    const treeNode = treeNodes[0];
                                    // 点击节点
                                    $("#" + treeNode.tId + "_a").click();
                                }else {
                                    $("#nameH").text("");
                                    $("#nameB").text("");
                                    $("#moduleUrlB").text("");
                                    $("#operUrlB").text("");
                                    $("#orderNoB").text("");
                                    $("#editBtn").prop("disabled","disabled");
                                }
                                thisPermission = null;
                            }
                        }
                    });
                }
                return false;
            }
        });
    </script>

</head>

<body>

    <!-- 新增许可模态窗口 -->
    <div class="modal fade" id="createPermissionModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 80%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
                    <h4 class="modal-title">新增许可</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="create-permissionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-permissionName" style="width: 200%;">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="create-moduleUrl" class="col-sm-2 control-label">模块URL</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-moduleUrl" style="width: 200%;">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="create-operationUrl" class="col-sm-2 control-label">操作URL</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-operationUrl" style="width: 200%;" placeholder="多个用逗号隔开">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="create-orderNo" class="col-sm-2 control-label">排序号</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-orderNo" style="width: 200%;" value="1">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button id="closeSaveBtn" type="button" class="btn btn-default">关闭</button>
                    <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改许可 -->
    <div class="modal fade" id="editPermissionModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 80%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
                    <h4 class="modal-title">修改许可</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-permissionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-permissionName" style="width: 200%;">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-moduleUrl" class="col-sm-2 control-label">模块URL</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-moduleUrl" style="width: 200%;">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-operationUrl" class="col-sm-2 control-label">操作URL</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-operationUrl" style="width: 200%;" placeholder="多个用逗号隔开">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-orderNo" class="col-sm-2 control-label">排序号</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-orderNo" style="width: 200%;" value="1">
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

    <div style="width: 20%; height: 100%; background-color: #F7F7F7; position: absolute; overflow:auto;">
        <ul id="tree" class="ztree" style="position: relative; top: 15px; margin-left: 15px;"></ul>
    </div>
    <div style="position: absolute; width: 80%; height: 100%; overflow: auto; margin-left: 20%;">
        <!-- 大标题 -->
        <div style="position: relative; margin-left: 30px; top: -10px;">
            <div class="page-header">
                <h3 id="nameH">市场活动 </h3><small>许可明细</small>
            </div>
            <div style="position: relative; height: 50px; width: 250px;  top: -72px; margin-left: 60%;">
                <button id="createBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 新增</button>
                <button  id="editBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
            </div>
        </div>
        <!-- 详细信息 -->
        <div style="position: relative; top: -70px;">
            <div style="position: relative; margin-left: 40px; height: 30px; top: 20px;">
                <div style="width: 300px; color: gray;">名称</div>
                <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="nameB"></b></div>
                <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
            </div>
            <div style="position: relative; margin-left: 40px; height: 30px; top: 40px;">
                <div style="width: 300px; color: gray;">模块URL</div>
                <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b style="min-height: 20px;display: inline-block;" id="moduleUrlB"></b></div>
                <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
            </div>
            <div style="position: relative; margin-left: 40px; height: 30px; top: 60px;">
                <div style="width: 300px; color: gray;">操作URL</div>
                <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b style="min-height: 20px;display: inline-block;" id="operUrlB"></b></div>
                <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
            </div>
            <div style="position: relative; margin-left: 40px; height: 30px; top: 80px;">
                <div style="width: 300px; color: gray;">排序号</div>
                <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="orderNoB">1</b></div>
                <div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
            </div>
        </div>
    </div>
</body>

</html>