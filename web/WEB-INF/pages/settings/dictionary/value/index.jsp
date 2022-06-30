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
            //给创建按钮添加单击事件
            $("#createBtn").click(function () {
                window.location.href = "${pageContext.request.contextPath}/settings/dictionary/value/create.do";
            });

            //给全选按钮添加单击事件
            $("#allSelectBox").click(function () {
                const isCheck = $(this).prop("checked");
                $("#valueList input[type='checkbox']").prop("checked", isCheck);
            });

            //给单个选择按钮添加单击事件
            $("#valueList").on("click", "input[type='checkbox']", function () {
                const checkedSize = $("#valueList input[type='checkbox']:checked").size();
                const allSize = $("#valueList input[type='checkbox']").size();
                if (checkedSize == allSize){
                    $("#allSelectBox").prop("checked", true);
                }else {
                    $("#allSelectBox").prop("checked", false);
                }
            });

            //给修改按钮添加单击事件
            $("#editBtn").click(function () {
                const value = $("#valueList input[type='checkbox']:checked");
                if (value.length == 0 || value.length > 1){
                    alert("只能选择一个进行修改!");
                    return;
                }
                const id = value[0].value;
                window.location.href = "${pageContext.request.contextPath}/settings/dictionary/value/edit.do?id=" + id;
            });

            //给删除按钮添加单击事件
            $("#removeBtn").click(function () {
                const checker = $("#valueList input[type='checkbox']:checked");
                if (checker.length == 0){
                    alert("至少选择一个进行删除!");
                    return;
                }
                let id = new Array();
                for (let i = 0; i < checker.length; i++) {
                    id.push(checker[i].value);
                }
                if (window.confirm("确定要删除吗?")){
                    $.ajax({
                        url:"${pageContext.request.contextPath}/settings/dictionary/value/removeDictionaryValue.do",
                        data:{
                            id:id
                        },
                        type:"post",
                        dataType:"json",
                        traditional: true,
                        success:function (data) {
                            if (data.code == "0"){
                                alert(data.message);
                            }else if (data.code == "1"){
                                window.location.href = "${pageContext.request.contextPath}/settings/dictionary/value/index.do";
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
                <h3>字典值列表</h3>
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
                    <td>字典值</td>
                    <td>文本</td>
                    <td>排序号</td>
                    <td>字典类型编码</td>
                </tr>
            </thead>
            <tbody id="valueList">
                <c:forEach items="${requestScope.dictionaryValueList}" var="value" varStatus="v">
                    <tr class="active">
                        <td><input type="checkbox" value="${value.id}" /></td>
                        <td>${v.index + 1}</td>
                        <td>${value.value}</td>
                        <td>${value.text}</td>
                        <td>${value.orderNo}</td>
                        <td>${value.typeCode}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</body>

</html>