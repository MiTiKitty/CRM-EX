<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>

<head>
    <meta charset="UTF-8">

    <link href="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css"
          rel="stylesheet"/>

    <style type="text/css">
        .mystage {
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }

        .closingDate {
            font-size: 15px;
            cursor: pointer;
            vertical-align: middle;
        }
    </style>

    <script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

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
                $("#remark").val("");
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $("#transactionRemark").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            $("#transactionRemark").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            $("#transactionRemark").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            $("#transactionRemark").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            //阶段提示框
            $(".mystage").popover({
                trigger: 'manual',
                placement: 'bottom',
                html: 'true',
                animation: false
            }).on("mouseenter", function () {
                var _this = this;
                $(this).popover("show");
                $(this).siblings(".popover").on("mouseleave", function () {
                    $(_this).popover('hide');
                });
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide")
                    }
                }, 100);
            });

            //给保存备注按钮添加单击事件
            $("#saveBtn").click(function () {
                const noteContent = $.trim($("#remark").val());
                if (noteContent == '') {
                    alert("备注信息不能为空！");
                    return;
                }
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/transaction/createTransactionRemark.do",
                    data: {
                        noteContent: noteContent,
                        transactionId:"${requestScope.transaction.id}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == "0") {
                            alert(data.message);
                        } else if (data.code == "1") {
                            const htmlStr = "<div id=\"div-" + data.data.id + "\" class=\"remarkDiv\" style=\"height: 60px;\">\n" +
                                "            <img title=\"" + data.data.notePerson + "\" src=\"${pageContext.request.contextPath}/image/user-thumbnail.png\"\n" +
                                "                 style=\"width: 30px; height:30px;\">\n" +
                                "            <div style=\"position: relative; top: -40px; margin-left: 40px;\">\n" +
                                "                <h5>" + data.data.noteContent + "</h5>\n" +
                                "                <font color=\"gray\">交易</font>\n" +
                                "                <font color=\"gray\">-</font> <b>${requestScope.transaction.name}</b> <small\n" +
                                "                    style=\"color: gray;\"> " + data.data.noteTime + " 由 " + data.data.notePerson + " 创建</small>\n" +
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

            //给备注编辑图标添加单击事件
            $("#transactionRemark").on("click", "a[name='edit']", function () {
                const id = $(this).attr("remarkId");
                const remark = $("#div-" + id + " h5").text();
                $("#remarkId").val(id);
                $("#noteContent").val(remark);
                $("#editRemarkModal").modal("show");
            });

            //给更新备注按钮添加单击事件
            $("#editRemarkBtn").click(function () {
                const id = $("#remarkId").val();
                const noteContent = $.trim($("#noteContent").val());
                if (noteContent == '') {
                    alert("备注信息不能为空！");
                    return;
                }
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/transaction/editTransactionRemark.do",
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
                            $("#div-" + id + " h5").text(noteContent);
                            $("#div-" + id + " small").text(data.data.editTime + " 由 " + data.data.editPerson + "修改");
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
            $("#transactionRemark").on("click", "a[name='remove']", function () {
                const id = $(this).attr("remarkId");
                $.ajax({
                    url: "${pageContext.request.contextPath}/workbench/transaction/removeTransactionRemark.do",
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

<!-- 修改备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改备注</h4>
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
        <h3>${requestScope.transaction.name} <small>￥${requestScope.transaction.amountOfMoney}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 阶段状态 -->
<div id="stage" style="position: relative; margin-left: 40px; top: -50px;">
    阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <c:forEach items="${requestScope.okStage}" var="v">
        <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"
              data-content="${v.value}" style="color: #90F790;"></span> -----------
    </c:forEach>
    <span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom"
          data-content="${requestScope.stage.value}" style="color: #90F790;"></span> -----------
    <c:forEach items="${requestScope.noStage}" var="v">
        <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"
              data-content="${v.value}"></span> -----------
    </c:forEach>
    <span class="closingDate">${requestScope.transaction.expectedClosingDate}</span>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: 0px;">
    <div style="position: relative; margin-left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.transaction.owner}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">金额</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;">
            <b>${requestScope.transaction.amountOfMoney}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.transaction.name}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">预计成交日期</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;">
            <b>${requestScope.transaction.expectedClosingDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.transaction.customer.name}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">阶段</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;">
            <b>${requestScope.transaction.stage}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px;position: relative; color: gray;">类型</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.transaction.type}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.transaction.source}</b></div>
        <div style="width: 300px;position: relative; margin-left: 450px; top: -40px; color: gray;">市场活动源</div>
        <div style="width: 300px;position: relative; margin-left: 650px; top: -60px;">
            <b>${requestScope.transaction.activity.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; margin-left: 450px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">联系人名称</div>
        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.transaction.contacts.fullName}</b></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.transaction.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${requestScope.transaction.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.transaction.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${requestScope.transaction.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; margin-left: 200px; top: -20px;">
            <b>
                ${requestScope.transaction.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; margin-left: 200px; top: -20px;">
            <b>
                ${requestScope.transaction.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; margin-left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 500px;position: relative; margin-left: 200px; top: -20px;">
            <b>${requestScope.transaction.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="transactionRemark" style="position: relative; top: 100px; margin-left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <c:forEach items="${requestScope.remarkList}" var="remark">
        <div id="div-${remark.id}" class="remarkDiv" style="height: 60px;">
            <img title="${remark.notePerson}" src="${pageContext.request.contextPath}/image/user-thumbnail.png"
                 style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; margin-left: 40px;">
                <h5>${remark.noteContent}</h5>
                <font color="gray">交易</font>
                <font color="gray">-</font> <b>${requestScope.transaction.name}</b> <small
                    style="color: gray;"> ${remark.showTime}&nbsp;
                由 ${remark.showPerson}${remark.editFlag == '1' ? " 修改" : " 创建"}</small>
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

<!-- 阶段历史 -->
<div>
    <div style="position: relative; top: 100px; margin-left: 40px;">
        <div class="page-header">
            <h4>阶段历史</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>阶段</td>
                    <td>金额</td>
                    <td>预计成交日期</td>
                    <td>创建时间</td>
                    <td>创建人</td>
                </tr>
                </thead>
                <tbody >
                <tr>
                    <td>资质审查</td>
                    <td>5,000</td>
                    <td>2017-02-07</td>
                    <td>2016-10-10 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                <tr>
                    <td>需求分析</td>
                    <td>5,000</td>
                    <td>20</td>
                    <td>2017-02-07</td>
                    <td>2016-10-20 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                <tr>
                    <td>谈判/复审</td>
                    <td>5,000</td>
                    <td>90</td>
                    <td>2017-02-07</td>
                    <td>2017-02-09 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                </tbody>
            </table>
        </div>

    </div>
</div>

<div style="height: 200px;"></div>

</body>

</html>