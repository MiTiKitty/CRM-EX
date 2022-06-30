<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>

<head>
    <meta charset="UTF-8">
    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        $(function () {
            //给创建按钮添加单机事件
            $("#createBtn").click(function () {
                window.location.href = "${pageContext.request.contextPath}/settings/dictionary/type/create.do";
            });

            //给全选按钮添加单击事件
            $("#allSelectBox").click(function () {
                const isCheck = $(this).prop("checked");
                $("#typeList input[type='checkbox']").attr("checked", isCheck);
            });

            //给单个选择按钮添加单击事件
            $("#typeList").on("click", "input[type='checkbox']", function () {
                const checkedSize = $("#typeList input[type='checkbox']:checked").size();
                const allSize = $("#typeList input[type='checkbox']").size();
                if (checkedSize == allSize){
                    $("#allSelectBox").attr("checked", true);
                }else {
                    $("#allSelectBox").attr("checked", false);
                }
            });

            //给编辑按钮添加单击事件
            $("#editBtn").click(function () {
                const checker = $("#typeList input[type='checkbox']:checked");
                if (checker.length > 1 || checker.length == 0){
                    alert("只能选中一个进行编辑!");
                    return;
                }
                const code = checker[0].value;
                window.location.href = "${pageContext.request.contextPath}/settings/dictionary/type/edit.do?code=" + code;
            });

            //给删除按钮添加单击事件
            $("#removeBtn").click(function () {
                const checker = $("#typeList input[type='checkbox']:checked");
                if (checker.length == 0){
                    alert("至少选择一个进行删除!");
                    return;
                }
                let code = new Array();
                for (let i = 0; i < checker.length; i++) {
                    code.push(checker[0].value);
                }
                if (window.confirm("确定要删除吗?")){
                    $.ajax({
                        url:"${pageContext.request.contextPath}/settings/dictionary/type/removeDictionaryType.do",
                        data:{
                            code:code
                        },
                        type:"post",
                        dataType:"json",
                        traditional:true,
                        success:function (data) {
                            if (data.code == "0"){
                                alert(data.message);
                            }else if (data.code == "1"){
                                window.location.href = "${pageContext.request.contextPath}/settings/dictionary/type/index.do";
                            }
                        }
                    });
                }
            });
        });
    </script>

</head>

<body>

    <div>
        <div style="position: relative; margin-left: 30px; top: -10px;">
            <div class="page-header">
                <h3>字典类型列表</h3>
            </div>
        </div>
    </div>
    <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;margin-left: 30px;">
        <div class="btn-group" style="position: relative; top: 18%;">
            <button id="createBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
            <button id="editBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
            <button id="removeBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
        </div>
    </div>
    <div style="position: relative; margin-left: 30px; top: 20px;">
        <table class="table table-hover">
            <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="allSelectBox" type="checkbox" /></td>
                    <td>序号</td>
                    <td>编码</td>
                    <td>名称</td>
                    <td>描述</td>
                </tr>
            </thead>
            <tbody id="typeList">
            <c:forEach items="${requestScope.dictionaryTypeList}" var="type" varStatus="v">
                <tr class="active">
                    <td><input type="checkbox" value="${type.code}"/></td>
                    <td>${v.index + 1}</td>
                    <td>${type.code}</td>
                    <td>${type.name}</td>
                    <td>${type.description}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

</body>

</html>