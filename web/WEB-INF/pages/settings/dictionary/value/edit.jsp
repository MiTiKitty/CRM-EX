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
        let isValue = false;
        let isOrderNo = true;

        $(function () {
            //给字典值添加失去焦点事件
            $("#edit-dicValue").blur(function () {
                const typeCode = "${requestScope.dictionaryValue.typeCode}";
                const value = $.trim($(this).val());
                if (value == ""){
                    $("#valueMsg").css("color", "red");
                    $("#valueMsg").text("字典值不能为空");
                    isValue = false;
                    return;
                }
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/dictionary/value/checkDicValueByTypeCodeAndValue.do",
                    data:{
                        typeCode:typeCode,
                        value:value
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            $("#valueMsg").css("color", "green");
                            $("#valueMsg").text("✓");
                            isValue = true;
                        }else if (data.code == "1"){
                            if (data.data.id != "${requestScope.dictionaryValue.id}"){
                                $("#valueMsg").css("color", "red");
                                $("#valueMsg").text("该类型下的字典值已存在");
                                isValue = false;
                            }else {
                                $("#valueMsg").css("color", "green");
                                $("#valueMsg").text("✓");
                                isValue = true;
                            }
                        }
                    }
                });
            });

            //给排序号添加失去焦点事件
            $("#edit-orderNo").blur(function () {
                const orderNo = $.trim($(this).val());
                if (!/^\d{1, 11}$/.test(orderNo)){
                    $("#orderNoMsg").css("color", "red");
                    $("#orderNoMsg").text("排序号只能为数字");
                    isOrderNo = false;
                }else {
                    $("#orderNoMsg").css("color", "green");
                    $("#orderNoMsg").text("✓");
                    isOrderNo = true;
                }
            });

            //给更新按钮添加单击事件
            $("#editBtn").click(function () {
                if (!isValue || !isOrderNo){
                    return;
                }
                const typeCode = "${requestScope.dictionaryValue.typeCode}";
                const value = $.trim($("#edit-dicValue").val());
                const text = $.trim($("#edit-text").val());
                const orderNo = $.trim($("#edit-orderNo").val());
                $.ajax({
                    url:"${pageContext.request.contextPath}/settings/dictionary/value/editDictionaryValue.do",
                    data:{
                        id:"${requestScope.dictionaryValue.id}",
                        typeCode:typeCode,
                        value:value,
                        text:text,
                        orderNo:orderNo
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            window.location.href = "${pageContext.request.contextPath}/settings/dictionary/value/index.do";
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
        <h3>修改字典值</h3>
        <div style="position: relative; top: -40px; margin-left: 70%;">
            <button id="editBtn" type="button" class="btn btn-primary">更新</button>
            <button id="closeBtn" type="button" class="btn btn-default">取消</button>
        </div>
        <hr style="position: relative; top: -40px;">
    </div>
    <form class="form-horizontal" role="form">

        <div class="form-group f">
            <label for="edit-dicTypeCode" class="col-sm-2 control-label">字典类型编码</label>
            <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="edit-dicTypeCode" style="width: 200%;" value="${requestScope.dictionaryType.name}" readonly>
            </div>
        </div>

        <div class="form-group f">
            <label for="edit-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
            <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="edit-dicValue" style="width: 200%;" value="${requestScope.dictionaryValue.value}">
                <span id="valueMsg" style="font-size: 14px;"></span>
            </div>
        </div>

        <div class="form-group f">
            <label for="edit-text" class="col-sm-2 control-label">文本</label>
            <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="edit-text" style="width: 200%;" value="${requestScope.dictionaryValue.text}">
            </div>
        </div>

        <div class="form-group f">
            <label for="edit-orderNo" class="col-sm-2 control-label">排序号</label>
            <div class="col-sm-10" style="width: 300px;">
                <input type="text" class="form-control" id="edit-orderNo" style="width: 200%;" value="${requestScope.dictionaryValue.orderNo}">
            </div>
        </div>
    </form>

    <div style="height: 200px;"></div>
</body>

</html>