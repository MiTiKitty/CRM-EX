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
        let isCode = false;
        let isName = false;
        $(function () {
            //给编码添加失去焦点事件
            $("#create-code").blur(function () {
                const code = $.trim($(this).val());
                if (code == ""){
                    $("#code-msg").text("编码不能为空");
                    $("#code-msg").css("color", "red");
                    isCode = false;
                    return;
                }
                //查询该编码是否已存在
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/dictionary/type/checkDictionaryTypeByCode.do",
                    data:{
                        code:code
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            $("#code-msg").text("✓");
                            $("#code-msg").css("color", "green");
                            isCode = true;
                        }else if (data.code == "1"){
                            $("#code-msg").text("编码已存在");
                            $("#code-msg").css("color", "red");
                            isCode = false;
                        }
                    }
                });
            });

            //给名称添加失去焦点事件
            $("#create-name").blur(function () {
                const name = $.trim($(this).val());
                if (name == ""){
                    $("#name-msg").text("名称不能为空");
                    $("#name-msg").css("color", "red");
                    isName = false;
                    return;
                }
                $("#name-msg").text("✓");
                $("#name-msg").css("color", "green");
                isName = true;
            });

            //给保存按钮添加单击事件
            $("#saveBtn").click(function () {
                if (!isCode || !isName){
                    alert("创建失败！");
                    return;
                }
                const code = $.trim($("#create-code").val());
                const name = $.trim($("#create-name").val());
                const description = $.trim($("#create-description").val());
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/dictionary/type/createNewDictionaryType.do",
                    data:{
                        code:code,
                        name:name,
                        description:description
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == '0'){
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
        <h3>新增字典类型</h3>
        <div style="position: relative; top: -40px; margin-left: 70%;">
            <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
            <button id="closeBtn" type="button" class="btn btn-default">取消</button>
        </div>
        <hr style="position: relative; top: -40px;">
    </div>
    <form class="form-horizontal" role="form">

        <div class="form-group f">
            <label for="create-code" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="create-code" style="width: 200%;">
                <span id="code-msg" style="font-size: 12px;"></span>
            </div>
        </div>

        <div class="form-group f">
            <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="create-name" style="width: 200%;">
                <span id="name-msg" style="font-size: 12px;"></span>
            </div>
        </div>

        <div class="form-group f">
            <label for="create-description" class="col-sm-2 control-label">描述</label>
            <div class="col-sm-10" style="width: 300px;">
                <textarea class="form-control" rows="3" id="create-description" style="width: 200%;"></textarea>
            </div>
        </div>
    </form>

    <div style="height: 200px;"></div>
</body>

</html>