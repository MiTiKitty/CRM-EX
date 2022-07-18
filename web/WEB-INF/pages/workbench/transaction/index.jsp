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
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bs_pagination-master/localization/en.min.js"></script>

    <script type="text/javascript">
        let thePageSize = 10;

        $(function () {
            //先查询
            findTransactionByCondition();

            //给查询按钮添加单击事件
            $("#search").click(function () {
                findTransactionByCondition(1, thePageSize);
            });

            //给全选按钮添加单击事件
            $("#allSelectBox").click(function () {
                const isCheck = $(this).prop("checked");
                $("#transactionList input[type='checkbox']").prop("checked", isCheck);
            });

            //给单个选择按钮添加单击事件
            $("#transactionList").on("click", "input[type='checkbox']", function () {
                const checkedSize = $("#transactionList input[type='checkbox']:checked").size();
                const allSize = $("#transactionList input[type='checkbox']").size();
                if (checkedSize == allSize) {
                    $("#allSelectBox").prop("checked", true);
                } else {
                    $("#allSelectBox").prop("checked", false);
                }
            });

            //给创建按钮添加单击事件
            $("#createBtn").click(function () {
                window.location.href = "${pageContext.request.contextPath}/workbench/transaction/create.do";
            });

            //给修改按钮添加单击事件
            $("#editBtn").click(function () {
                const obj = $("#transactionList input[type='checkbox']:checked");
                if (obj.length != 1) {
                    alert("只能选择一条交易进行修改操作！");
                    return;
                }
                const id = obj[0].value;
                window.location.href = "${pageContext.request.contextPath}/workbench/transaction/edit.do?id=" + id;
            });

            //给删除按钮添加单击事件
            $("#removeBtn").click(function () {
                const tran = $("#transactionList input[type='checkbox']:checked");
                if (tran.length == 0) {
                    alert("至少需要选择一条交易进行删除操作！");
                    return;
                }
                const id = new Array();
                $.each(tran, function (index, obj) {
                    id.push(obj.value);
                });
                if (window.confirm("确定要删除这些交易信息吗?")) {
                    $.ajax({
                        url: "${pageContext.request.contextPath}/workbench/transaction/removeTransaction.do",
                        data: {
                            id: id
                        },
                        type: "post",
                        dataType: "json",
                        traditional: true,
                        success: function (data) {
                            if (data.code == "0") {
                                alert(data.message);
                            } else if (data.code == "1") {
                                findTransactionByCondition(1, thePageSize);
                            }
                        }
                    });
                }
            });

        });

        /**
         * 分页条件查询交易信息
         * @param pageNo
         * @param pageSize
         */
        function findTransactionByCondition(pageNo = 1, pageSize = 10) {
            const owner = $("#owner").val();
            const name = $.trim($("#name").val());
            const customerName = $.trim($("#customerName").val());
            const contactsName = $.trim($("#contactsName").val());
            const stage = $("#stage").val();
            const type = $("#type").val();
            const source = $("#source").val();
            $.ajax({
                url: "${pageContext.request.contextPath}/workbench/transaction/queryTransactionByCondition.do",
                data: {
                    owner: owner,
                    name: name,
                    customerName: customerName,
                    contactsName: contactsName,
                    stage: stage,
                    type: type,
                    source: source,
                    pageSize: pageSize,
                    pageNo: pageNo
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    let htmlStr = "";
                    $.each(data.transactionList, function (index, obj) {
                        htmlStr += "<tr>\n" +
                            "                    <td><input value=\"" + obj.id + "\" type=\"checkbox\"/></td>\n" +
                            "                    <td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='${pageContext.request.contextPath}/workbench/transaction/detail.do?id=" + obj.id + "';\">" + obj.name + "</a>\n" +
                            "                    </td>\n" +
                            "                    <td>" + obj.customer.name + "</td>\n" +
                            "                    <td>" + obj.stage + "</td>\n" +
                            "                    <td>" + obj.type + "</td>\n" +
                            "                    <td>" + obj.owner + "</td>\n" +
                            "                    <td>" + obj.source + "</td>\n" +
                            "                    <td>" + obj.contacts.fullName + "</td>\n" +
                            "                </tr>";
                    });
                    $("#transactionList").html(htmlStr);
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
                            findTransactionByCondition(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }
    </script>
</head>

<body>


<div>
    <div style="position: relative; margin-left: 10px; top: -10px;">
        <div class="page-header">
            <h3>交易列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; margin-left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; padding-left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; margin-left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <select class="form-control" id="owner">
                            <option></option>
                            <c:forEach items="${requestScope.userList}" var="owner">
                                <option value="${owner.id}">${owner.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="customerName">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">阶段</div>
                        <select class="form-control" id="stage">
                            <option></option>
                            <c:forEach items="${requestScope.stageList}" var="v">
                                <option value="${v.value}">${v.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <select class="form-control">
                            <option></option>
                            <c:forEach items="${requestScope.typeList}" var="v">
                                <option value="${v.value}">${v.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="create-clueSource">
                            <option></option>
                            <c:forEach items="${requestScope.sourceList}" var="v">
                                <option value="${v.value}">${v.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">联系人名称</div>
                        <input class="form-control" type="text" id="contactsName">
                    </div>
                </div>

                <button id="search" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
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
                    <td>客户名称</td>
                    <td>阶段</td>
                    <td>类型</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>
                <tbody id="transactionList">
                </tbody>
            </table>
        </div>
        <div style="height: 50px; position: relative;top: 20px;" id="pageDiv">
        </div>
    </div>

</div>
</body>

</html>