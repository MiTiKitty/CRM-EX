<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>

<head>
    <meta charset="UTF-8">

    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>
    <style>
        b {
            display: inline-block;
            min-height: 20px;
        }
    </style>

    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $("#remarkNoteContent").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            //给取消按钮添加单击事件
            $("#cancelBtn").click(function () {
                $("#remarkNoteContent").val("");
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $("#activityRemarkList").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            $("#activityRemarkList").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            $("#activityRemarkList").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            $("#activityRemarkList").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            //给市场活动备注保存按钮添加单击事件
            $("#saveBtn").click(function () {
                const noteContent = $.trim($("#remarkNoteContent").val());
                if (noteContent == '') {
                    alert("备注信息内容不能为空哦！")
                    return;
                }
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/activity/createActivityRemark.do",
                    data: {
                        noteContent: noteContent,
                        activityId: "${requestScope.activity.id}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == "1") {
                            let msg = data.data.noteTime + " 由" + data.data.notePerson + "创建";
                            if (data.data.editFlag == "1") {
                                msg = data.data.editTime + " 由" + data.data.editPerson + "修改";
                            }
                            let htmlStr = "<div class=\"remarkDiv\" style=\"height: 60px;\" id=\"div-" + data.data.id + "\">\n" +
                                "                <img title=\"" + data.data.notePerson + "\" src=\"${pageContext.request.contextPath}/image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">\n" +
                                "                <div style=\"position: relative; top: -40px; margin-left: 40px;\">\n" +
                                "                    <h5 id='content-" + data.data.id + "'>" + data.data.noteContent + "</h5>\n" +
                                "                    <font color=\"gray\">市场活动</font>\n" +
                                "                    <font color=\"gray\">-</font> <b>${requestScope.activity.name}</b> <small style=\"color: gray;\"> " + msg + "</small>\n" +
                                "                    <div style=\"position: relative; margin-left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">\n" +
                                "                        <a class=\"myHref\" name=\"edit\" remarkId=\"" + data.data.id + "\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a> &nbsp;&nbsp;&nbsp;&nbsp;\n" +
                                "                        <a class=\"myHref\" name=\"remove\" remarkId=\"" + data.data.id + "\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
                                "                    </div>\n" +
                                "                </div>\n" +
                                "            </div>";
                            $("#remarkDiv").before(htmlStr);
                            $("#cancelBtn").click();
                        }
                    }
                });
            });

            //给修改图标添加单击事件
            $("#activityRemarkList").on("click", "a[name='edit']", function () {
                const id = $(this).attr("remarkId");
                const noteContent = $("#content-" + id).text();
                $("#noteContent").val(noteContent);
                $("#remarkId").val(id);
                $("#editRemarkModal").modal("show");
            });

            //给更新按钮添加单击事件
            $("#editRemarkBtn").click(function () {
                const id = $("#remarkId").val();
                const noteContent = $.trim($("#noteContent").val());
                if (noteContent == '') {
                    alert("备注信息内容不能为空哦！")
                    return;
                }
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/activity/editActivityRemark.do",
                    data: {
                        id: id,
                        noteContent: noteContent
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == "1") {
                            $("#content-" + id).text(noteContent);
                            $("#editRemarkModal").modal("hide");
                        }
                    }
                });
            });

            //给关闭按钮添加单击事件
            $("#closeBtn").click(function () {
                $("#editRemarkModal").modal("hide");
            });

            //给删除图标谭家单击事件
            $("#activityRemarkList").on("click", "a[name='remove']", function () {
                const id = $(this).attr("remarkId");
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/activity/removeActivityRemark.do",
                    data: {
                        id: id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == '1') {
                            $("#div-" + id).remove();
                        }
                    }
                });
            });
        });
    </script>

</head>

<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="noteContent" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" id="closeBtn">关闭</button>
                <button type="button" class="btn btn-primary" id="editRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 返回按钮 -->
<div style="position: relative; top: 35px; margin-left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; margin-left: 40px; top: -30px;">
    <div class="page-header">
        <h3>市场活动-${requestScope.activity.name} <small>${requestScope.activity.startDate}
            ~ ${requestScope.activity.endDate}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; margin-left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.activity.owner}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;">
            <b>${requestScope.activity.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>

    <div style="position: relative; margin-left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.activity.startDate}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;">
            <b>${requestScope.activity.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">预算成本</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.activity.budgetCost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.activity.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${requestScope.activity.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;"><b>${requestScope.activity.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${requestScope.activity.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; margin-left: 200px; top: -20px;">
            <b>
                <%--市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等--%>
                ${requestScope.activity.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 30px; margin-left: 40px;" id="activityRemarkList">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注 -->
    <c:forEach items="${requestScope.activityRemarkList}" var="remark">
        <div class="remarkDiv" style="height: 60px;" id="div-${remark.id}">
            <img title="${remark.notePerson}" src="${pageContext.request.contextPath}/image/user-thumbnail.png"
                 style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; margin-left: 40px;">
                <h5 id="content-${remark.id}">${remark.noteContent}</h5>
                <font color="gray">市场活动</font>
                <font color="gray">-</font> <b>${requestScope.activity.name}</b> <small style="color: gray;">
                    ${remark.showTime} 由${remark.showPerson}${remark.editFlag == '1' ? "修改" : "创建"}
            </small>
                <div style="position: relative; margin-left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" name="edit" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a> &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" name="remove" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; margin-left: 10px;">
            <textarea id="remarkNoteContent" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;margin-left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>

</html>