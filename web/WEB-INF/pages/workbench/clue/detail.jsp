<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>

<head>
    <meta charset="UTF-8">

    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>
    <style>
        #allMsg b {
            display: inline-block;
            min-height: 20px;
        }
    </style>

    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        //默认情况下取消和保存按钮是隐藏的
        let cancelAndSaveBtnDefault = true;

        $(function () {
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                $("#remark").val("");
                cancelAndSaveBtnDefault = true;
            });

            $("#remarkList").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            $("#remarkList").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            $("#remarkList").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            $("#remarkList").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            //给保存按钮添加单击事件
            $("#saveBtn").click(function () {
                const noteContent = $.trim($("#remark").val());
                const clueId = "${requestScope.clue.id}";
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/clue/createClueRemark.do",
                    data: {
                        noteContent: noteContent,
                        clueId: clueId
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == '1') {
                            let htmlStr = "<div id=\"div-" + data.data.id + "\" class=\"remarkDiv\" style=\"height: 60px;\">\n" +
                                "            <img title=\""+data.data.notePerson+"\" src=\"${pageContext.request.contextPath}/image/user-thumbnail.png\"\n" +
                                "                 style=\"width: 30px; height:30px;\">\n" +
                                "            <div style=\"position: relative; top: -40px; margin-left: 40px;\">\n" +
                                "                <h5 id=\"remark-" + data.data.id + "\">" + data.data.noteContent + "</h5>\n" +
                                "                <font color=\"gray\">线索</font>\n" +
                                "                <font color=\"gray\">-</font>\n" +
                                "                <b>${requestScope.clue.fullName}${requestScope.clue.appellation}-${requestScope.clue.company}</b> <small\n" +
                                "                    style=\"color: gray;\"> " + data.data.noteTime + "\n" +
                                "                由" + data.data.notePerson + " 创建</small>\n" +
                                "                <div style=\"position: relative; margin-left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">\n" +
                                "                    <a class=\"myHref\" name=\"edit\" remarkId=\"" + data.data.id + "\" href=\"javascript:void(0);\"><span\n" +
                                "                            class=\"glyphicon glyphicon-edit\"\n" +
                                "                            style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
                                "                    &nbsp;&nbsp;&nbsp;&nbsp;\n" +
                                "                    <a class=\"myHref\" name=\"remove\" remarkId=\"" + data.data.id + "\" href=\"javascript:void(0);\"><span\n" +
                                "                            class=\"glyphicon glyphicon-remove\"\n" +
                                "                            style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
                                "                </div>\n" +
                                "            </div>\n" +
                                "        </div>";
                            $("#remarkDiv").before(htmlStr);
                            $("#cancelBtn").click();
                        }
                    }
                });
            });

            //给编辑图标添加单击事件
            $("#remarkList").on("click", "a[name='edit']", function () {
                const id = $(this).attr("remarkId");
                const noteContent = $("#remark-" + id).text();
                $("#noteContent").val(noteContent);
                $("#remarkId").val(id);
                $("#editRemarkModal").modal("show");
            });

            //给更新按钮添加单击事件
            $("#editRemarkBtn").click(function () {
                const id = $("#remarkId").val();
                const noteContent = $.trim($("#noteContent").val());
                if (noteContent == ""){
                    alert("备注内容不能为空");
                    return;
                }
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/clue/editClueRemarkById.do",
                    data:{
                        id:id,
                        noteContent:noteContent
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            $("#remark-" + id).text(data.data.noteContent);
                            $("#editRemarkModal").modal("hide");
                        }
                    }
                });
            });

            //给取消按钮添加单击事件
            $("#closeBtn").click(function () {
                $("#editRemarkModal").modal("hide");
            });

            //给删除图标添加单击事件
            $("#remarkList").on("click","a[name='remove']", function () {
                const id = $(this).attr("remarkId");
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/clue/removeClueRemarkById.do",
                    data:{
                        id:id
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            $("#div-" + id).remove();
                        }
                    }
                });
            });

            //给关联市场活动图标添加单击事件
            $("#relation").click(function () {
                $("#bundModal").modal("show");
            });

            //给名称输入框添加键盘弹起事件
            $("#name").keydown(function (e) {
                const name = $(this).val();
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/clue/queryActivityByName.do",
                    data:{
                        name:name,
                        clueId:"${requestScope.clue.id}"
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        let htmlStr = "";
                        $.each(data, function (index, obj) {
                            htmlStr += "<tr>\n" +
                                "                        <td><input value='"+obj.id+"' type=\"checkbox\"/></td>\n" +
                                "                        <td>"+obj.name+"</td>\n" +
                                "                        <td>"+obj.startDate+"</td>\n" +
                                "                        <td>"+obj.endDate+"</td>\n" +
                                "                        <td>"+obj.owner+"</td>\n" +
                                "                    </tr>";
                        });
                        $("#queryActivityList").html(htmlStr);
                    }
                });
            });

            //给全选按钮添加单击事件
            $("#allSelectBox").click(function () {
                const isCheck = $(this).prop("checked");
                $("#queryActivityList input[type='checkbox']").prop("checked", isCheck);
            });

            //给单个选择按钮添加单击事件
            $("#queryActivityList").on("click", "input[type='checkbox']", function () {
                const checkedSize = $("#queryActivityList input[type='checkbox']:checked").size();
                const allSize = $("#queryActivityList input[type='checkbox']").size();
                if (checkedSize == allSize) {
                    $("#allSelectBox").prop("checked", true);
                } else {
                    $("#allSelectBox").prop("checked", false);
                }
            });

            //给关联按钮添加单击事件
            $("#confirmRelationBtn").click(function () {
                const obj = $("#queryActivityList input[type='checkbox']:checked");
                if (obj.length == 0){
                    alert("至少需要选择一个进行关联");
                    return;
                }
                const activityIds = new Array();
                $.each(obj, function (index, o) {
                    activityIds.push(o.value);
                });
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/clue/saveRelation.do",
                    data:{
                        activityIds:activityIds,
                        clueId:"${requestScope.clue.id}"
                    },
                    type:"post",
                    dataType:"json",
                    traditional:true,
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            let htmlStr = "";
                            $.each(data.data, function (index, obj) {
                                htmlStr = "<tr id=\"tr-"+obj.id+"\">\n" +
                                    "                        <td>"+obj.name+"</td>\n" +
                                    "                        <td>"+obj.startDate+"</td>\n" +
                                    "                        <td>"+obj.endDate+"</td>\n" +
                                    "                        <td>"+obj.owner+"</td>\n" +
                                    "                        <td><a href=\"javascript:void(0);\" style=\"text-decoration: none;\" name=\"remove\"\n" +
                                    "                               activityId=\""+obj.id+"\"><span\n" +
                                    "                                class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>\n" +
                                    "                    </tr>";
                            });
                            $("#activityList").append(htmlStr);
                            $("#bundModal").modal("hide");
                        }
                    }
                });
            });

            //给关闭关联窗口按钮添加单击事件
            $("#closeRelationBtn").click(function () {
                $("#bundModal").modal("hide");
            });

            //给取消关联图标添加单击事件
            $("#activityList").on("click", "a[name='remove']", function () {
                const activityId = $(this).attr("activityId");
                $.ajax({
                    url:"${pageContext.request.contextPath}/workbench/clue/relieveRelation.do",
                    data:{
                        activityId:activityId,
                        clueId:"${requestScope.clue.id}"
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if (data.code == "0"){
                            alert(data.message);
                        }else if (data.code == "1"){
                            $("#tr-" + activityId).remove();
                        }
                    }
                });
            });

            //给转换按钮添加单击事件
            $("#shiftBtn").click(function () {
                window.location.href = "${pageContext.request.contextPath}/workbench/clue/convert.do?id=${requestScope.clue.id}";
            });
        });
    </script>

</head>

<body>

<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; margin-left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input id="name" type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span id="search" class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input id="allSelectBox" type="checkbox"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="queryActivityList">
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button id="closeRelationBtn" type="button" class="btn btn-default">取消</button>
                <button id="confirmRelationBtn" type="button" class="btn btn-primary">关联</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索备注的模态窗口 -->
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
        <h3>${requestScope.clue.fullName}${requestScope.clue.appellation} - <small>${requestScope.clue.company}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; margin-left: 700px;">
        <button id="shiftBtn" type="button" class="btn btn-default"><span
                class="glyphicon glyphicon-retweet"></span> 转换
        </button>

    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div id="allMsg" style="position: relative; top: -70px;">
    <div style="position: relative; margin-left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.clue.fullName}${requestScope.clue.appellation}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;"><b>${requestScope.clue.owner}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.clue.company}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;"><b>${requestScope.clue.job}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;"><b>${requestScope.clue.email}</b>
        </div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;"><b>${requestScope.clue.phone}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.clue.website}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;"><b>${requestScope.clue.mphone}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">线索状态</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;"><b>${requestScope.clue.state}</b>
        </div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">线索来源</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;"><b>${requestScope.clue.source}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">等级</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;"><b>${requestScope.clue.grade}</b>
        </div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">行业</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;">
            <b>${requestScope.clue.industry}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;"><b>${requestScope.clue.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${requestScope.clue.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;"><b>${requestScope.clue.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${requestScope.clue.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; margin-left: 200px; top: -20px;">
            <b>
                ${requestScope.clue.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; margin-left: 200px; top: -20px;">
            <b>
                ${requestScope.clue.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.clue.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 110px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; margin-left: 200px; top: -20px;">
            <b>
                ${requestScope.clue.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 40px; margin-left: 40px;" id="remarkList">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <c:forEach items="${requestScope.clueRemarkList}" var="remark">
        <div id="div-${remark.id}" class="remarkDiv" style="height: 60px;">
            <img title="${remark.notePerson}" src="${pageContext.request.contextPath}/image/user-thumbnail.png"
                 style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; margin-left: 40px;">
                <h5 id="remark-${remark.id}">${remark.noteContent}</h5>
                <font color="gray">线索</font>
                <font color="gray">-</font>
                <b>${requestScope.clue.fullName}${requestScope.clue.appellation}-${requestScope.clue.company}</b> <small
                    style="color: gray;"> ${remark.showTime}
                由${remark.showPerson} ${remark.editFlag == "0" ? "创建" : "修改"}</small>
                <div style="position: relative; margin-left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" name="edit" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-edit"
                            style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" name="remove" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-remove"
                            style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; margin-left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;margin-left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; margin-left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="activityList">
                <c:forEach items="${requestScope.activityList}" var="a">
                    <tr id="tr-${a.id}">
                        <td>${a.name}</td>
                        <td>${a.startDate}</td>
                        <td>${a.endDate}</td>
                        <td>${a.owner}</td>
                        <td><a href="javascript:void(0);" style="text-decoration: none;" name="remove"
                               activityId="${a.id}"><span
                                class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" id="relation"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>

</html>