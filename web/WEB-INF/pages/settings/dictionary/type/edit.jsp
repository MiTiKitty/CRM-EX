<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <meta charset="UTF-8">

    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <style>
        .f {
            width: 100%;
        }
    </style>

    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        $(function () {
            //给更新按钮添加单击事件
            $("#editBtn").click(function () {
                const newCode = $.trim($("#edit-code").val());
                const name = $.trim($("#edit-name").val());
                const description = $.trim($("#edit-description").val());
                if (newCode == ""){
                    alert("编码不能为空!");
                    return;
                }
                if (name == ""){
                    alert("名称不能为空!");
                    return;
                }
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/dictionary/type/editDictionaryType.do",
                    data:{
                        oldCode:"${requestScope.type.code}",
                        newCode:newCode,
                        name:name,
                        description:description
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            window.location.href = "${pageContext.request.contextPath}/settings/dictionary/type/index.do";
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

    <div style="position:  relative; margin-left: 30px;">
        <h3>修改字典类型</h3>
        <div style="position: relative; top: -40px; margin-left: 70%;">
            <button id="editBtn" type="button" class="btn btn-primary">更新</button>
            <button id="closeBtn" type="button" class="btn btn-default">取消</button>
        </div>
        <hr style="position: relative; top: -40px;">
    </div>
    <form class="form-horizontal" role="form">

        <div class="form-group f">
            <label for="edit-code" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="edit-code" style="width: 200%;" value="${requestScope.type.code}">
            </div>
        </div>

        <div class="form-group f">
            <label for="edit-name" class="col-sm-2 control-label">名称</label>
            <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="edit-name" style="width: 200%;" value="${requestScope.type.name}">
            </div>
        </div>

        <div class="form-group f">
            <label for="edit-description" class="col-sm-2 control-label">描述</label>
            <div class="col-sm-10" style="width: 300px;">
                <textarea class="form-control" rows="3" id="edit-description" style="width: 200%;">${requestScope.type.description}</textarea>
            </div>
        </div>
    </form>

    <div style="height: 200px;"></div>
</body>

</html>