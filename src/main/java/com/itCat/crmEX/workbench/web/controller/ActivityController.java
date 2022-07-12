package com.itCat.crmEX.workbench.web.controller;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.commons.domain.ResultObject;
import com.itCat.crmEX.commons.utils.DateUtils;
import com.itCat.crmEX.commons.utils.UUIDUtils;
import com.itCat.crmEX.settings.domain.DictionaryValue;
import com.itCat.crmEX.settings.domain.User;
import com.itCat.crmEX.settings.service.DictionaryValueService;
import com.itCat.crmEX.settings.service.UserService;
import com.itCat.crmEX.workbench.domain.Activity;
import com.itCat.crmEX.workbench.domain.ActivityRemark;
import com.itCat.crmEX.workbench.service.ActivityRemarkService;
import com.itCat.crmEX.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.*;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {

    @Autowired
    private ActivityService activityService;

    @Autowired
    private UserService userService;

    @Autowired
    private DictionaryValueService dictionaryValueService;

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/index.do")
    public String index(HttpServletRequest request) {
        List<User> owners = userService.queryAllUserForOption();
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.MARKET_ACTIVITY_TYPE);
        List<DictionaryValue> stateList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.MARKET_ACTIVITY_STATUS);
        request.setAttribute("owners", owners);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("stateList", stateList);
        return "workbench/activity/index";
    }

    /**
     * 条件查询市场活动列表
     *
     * @param name
     * @param owner
     * @param startDate
     * @param endDate
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/queryActivityByCondition.do")
    @ResponseBody
    public Object queryActivityByCondition(String name, String owner, String startDate, String endDate, String pageNo,
                                           String pageSize) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> result = new HashMap<>();
        int pageNum = Integer.parseInt(pageNo);
        int size = Integer.parseInt(pageSize);
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("pageBegin", (pageNum - 1) * size);
        map.put("pageSize", size);
        List<Activity> activityList = activityService.queryActivityByCondition(map);
        int totalRows = activityService.queryActivityCountByCondition(map);
        result.put("activityList", activityList);
        result.put("totalRows", totalRows);
        return result;
    }

    /**
     * 保存新创建的市场活动
     *
     * @param owner
     * @param source
     * @param name
     * @param state
     * @param startDate
     * @param endDate
     * @param budgetCost
     * @param description
     * @param session
     * @return
     */
    @RequestMapping("/createActivity.do")
    @ResponseBody
    public Object createActivity(String owner, String source, String name, String state, String startDate,
                                 String endDate, String budgetCost, String description, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User sessionUser = (User) session.getAttribute(Constants.SESSION_USER);
        Activity activity = new Activity();
        activity.setId(UUIDUtils.getUUID());
        setActivityField(owner, source, name, state, startDate, endDate, budgetCost, description, sessionUser, activity);
        try {
            int result = activityService.saveActivity(activity);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据市场活动id查找市场活动信息
     *
     * @param id
     * @return
     */
    @RequestMapping("/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id) {
        return activityService.queryActivityById(id);
    }

    /**
     * 根据市场活动修改市场活动信息
     *
     * @param id
     * @param owner
     * @param source
     * @param name
     * @param state
     * @param startDate
     * @param endDate
     * @param budgetCost
     * @param description
     * @param session
     * @return
     */
    @RequestMapping("/editActivity.do")
    @ResponseBody
    public Object editActivity(String id, String owner, String source, String name, String state, String startDate,
                               String endDate, String budgetCost, String description, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User sessionUser = (User) session.getAttribute(Constants.SESSION_USER);
        Activity activity = new Activity();
        activity.setId(id);
        setActivityField(owner, source, name, state, startDate, endDate, budgetCost, description, sessionUser, activity);
        try {
            int result = activityService.editActivityById(activity);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    @RequestMapping("/detail.do")
    public String detail(String id, HttpServletRequest request) {
        Activity activity = activityService.queryActivityForDetailById(id);
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryAllActivityRemarkByActivityId(id);
        request.setAttribute("activity", activity);
        request.setAttribute("activityRemarkList", activityRemarkList);
        return "workbench/activity/detail";
    }

    /**
     * 保存新创建的市场活动备注信息
     *
     * @param noteContent
     * @param activityId
     * @param session
     * @return
     */
    @RequestMapping("/createActivityRemark.do")
    @ResponseBody
    public Object createActivityRemark(String noteContent, String activityId, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User sessionUser = (User) session.getAttribute(Constants.SESSION_USER);
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(UUIDUtils.getUUID());
        activityRemark.setNotePerson(sessionUser.getId());
        activityRemark.setNoteContent(noteContent);
        activityRemark.setNoteTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        activityRemark.setEditFlag(Constants.NOT_EDIT);
        activityRemark.setActivityId(activityId);
        try {
            int result = activityRemarkService.saveActivityRemark(activityRemark);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                activityRemark.setNotePerson(sessionUser.getName());
                resultObject.setData(activityRemark);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据市场活动备注id修改该市场活动备注信息
     *
     * @param id
     * @param noteContent
     * @param session
     * @return
     */
    @RequestMapping("/editActivityRemark.do")
    @ResponseBody
    public Object editActivityRemarkById(String id, String noteContent, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User sessionUser = (User) session.getAttribute(Constants.SESSION_USER);
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setEditPerson(sessionUser.getId());
        activityRemark.setNoteContent(noteContent);
        activityRemark.setEditTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        activityRemark.setEditFlag(Constants.HAVE_EDIT);
        try {
            int result = activityRemarkService.editActivityRemarkById(activityRemark);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                activityRemark.setEditPerson(sessionUser.getName());
                resultObject.setData(activityRemark);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据市场活动备注id删除该市场活动备注信息
     *
     * @param id
     * @return
     */
    @RequestMapping("/removeActivityRemark.do")
    @ResponseBody
    public Object removeActivityRemarkById(String id) {
        ResultObject resultObject = new ResultObject();
        try {
            int result = activityRemarkService.removeActivityRemarkById(id);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据市场活动id集合删除指定的市场活动信息
     *
     * @param id
     * @return
     */
    @RequestMapping("/removeActivityByIds.do")
    @ResponseBody
    public Object removeActivityByIds(String[] id) {
        ResultObject resultObject = new ResultObject();
        try {
            activityService.removeActivityByIds(id);
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 批量导入市场活动
     *
     * @param activityFile
     * @param session
     * @return
     */
    @RequestMapping("/importActivityFile.do")
    @ResponseBody
    public Object importActivityFile(MultipartFile activityFile, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User sessionUser = (User) session.getAttribute(Constants.SESSION_USER);
        try {
            InputStream input = activityFile.getInputStream();
            List<Activity> activityList = importActivityExcel(sessionUser.getId(), sessionUser, input, 0);
            int result = activityService.importActivities(activityList);
            if (result <= 0) {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            } else {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                resultObject.setMessage("数据导入成功");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 下载市场活动示例文件
     *
     * @param response
     * @throws Exception
     */
    @RequestMapping("/exportActivityExample.do")
    public void exportActivityExample(HttpServletResponse response) throws Exception {
        response.setContentType("application/octet-steam;charset=UTF-8");
        response.addHeader("Content-Disposition", "attachment;filename=exportActivityExample.xls");
        OutputStream out = response.getOutputStream();
        List<Activity> activityList = new LinkedList<>();
        Activity activity = new Activity();
        activity.setName("xxx");
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.MARKET_ACTIVITY_TYPE);
        StringBuilder sb = new StringBuilder();
        for (DictionaryValue s : sourceList) {
            sb.append(s.getValue() + " ");
        }
        activity.setSource(sb.toString());
        List<DictionaryValue> stateList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.MARKET_ACTIVITY_STATUS);
        sb = new StringBuilder();
        for (DictionaryValue s : stateList) {
            sb.append(s.getValue() + " ");
        }
        activity.setState(sb.toString());
        activity.setStartDate("yyyy-MM-dd");
        activity.setEndDate("yyyy-MM-dd");
        activity.setBudgetCost(0L);
        activity.setDescription("xxx");
        activityList.add(activity);
        createActivityExcel(out, activityList);
        out.flush();
    }

    /**
     * 导出全部的市场活动
     *
     * @param response
     * @throws Exception
     */
    @RequestMapping("/exportAllActivity.do")
    public void exportAllActivity(HttpServletResponse response) throws Exception {
        response.setContentType("application/octet-steam;charset=UTF-8");
        List<Activity> activityList = activityService.queryAllActivity();
        response.addHeader("Content-Disposition", "attachment;filename=exportAllActivities.xls");
        OutputStream out = response.getOutputStream();
        createActivityExcel(out, activityList);
        out.flush();
    }

    /**
     * 批量选择导出市场活动excel文件
     *
     * @param id
     * @param response
     * @throws Exception
     */
    @RequestMapping("/exportActivitySelect.do")
    public void exportActivitySelect(String[] id, HttpServletResponse response) throws Exception {
        response.setContentType("application/octet-steam;charset=UTF-8");
        List<Activity> activityList = activityService.queryActivityByIds(id);
        response.addHeader("Content-Disposition", "attachment;filename=exportActivitiesSelect.xls");
        OutputStream out = response.getOutputStream();
        createActivityExcel(out, activityList);
        out.flush();
    }

    private void setActivityField(String owner, String source, String name, String state, String startDate,
                                  String endDate, String budgetCost, String description, User sessionUser, Activity activity) {
        activity.setOwner(owner);
        activity.setSource(source);
        activity.setName(name);
        activity.setState(state);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setBudgetCost(Long.parseLong(budgetCost));
        activity.setDescription(description);
        activity.setCreateBy(sessionUser.getId());
        activity.setCreateTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
    }

    /**
     * excel文件的标题行头
     */
    private final String[] titleName = {"序号", "名称", "来源", "状态", "开始日期", "结束日期", "预算成本", "活动描述"};

    /*
        对字段类型的下标定义
     */
    private final int INDEX = 0;
    private final int NAME = 1;
    private final int SOURCE = 2;
    private final int STATE = 3;
    private final int START_DATE = 4;
    private final int END_DATE = 5;
    private final int BUDGET_COST = 6;
    private final int DESCRIPTION = 7;

    /**
     * 市场活动excel文件字段枚举类
     */
    private enum CellIndexEnum {
        index, name, source, state, startDate, endDate, budgetCost, description
    }

    /**
     * 导入市场活动excel文件
     *
     * @param owner
     * @param user
     * @param is
     * @param sheetNum
     * @return
     * @throws IOException
     */
    private List<Activity> importActivityExcel(String owner, User user, InputStream is, int sheetNum) throws IOException {
        List<Activity> activityList = new LinkedList<>();
        //工作区
        HSSFWorkbook wb = new HSSFWorkbook(is);
        //页对象
        HSSFSheet sheet = wb.getSheetAt(sheetNum);
        //行对象
        HSSFRow row = null;
        //单元格对象
        HSSFCell cell = null;
        //获得第二行
        row = sheet.getRow(1);
        Activity activity = null;
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            row = sheet.getRow(i);
            activity = new Activity();
            String name = row.getCell(NAME).getStringCellValue();
            String source = row.getCell(SOURCE).getStringCellValue();
            String state = row.getCell(STATE).getStringCellValue();
            String startDate = DateUtils.formatDate(row.getCell(START_DATE).getDateCellValue(), Constants.DATE_FORMAT);
            String endDate = DateUtils.formatDate(row.getCell(END_DATE).getDateCellValue(), Constants.DATE_FORMAT);
            String budgetCost = ((long) row.getCell(BUDGET_COST).getNumericCellValue()) + "";
            String description = row.getCell(DESCRIPTION).getStringCellValue();
            activity.setId(UUIDUtils.getUUID());
            setActivityField(owner, source, name, state, startDate, endDate, budgetCost, description, user, activity);
            activityList.add(activity);
        }
        return activityList;
    }

    /**
     * 下载市场活动excel文件
     *
     * @param out
     * @throws IOException
     */
    private void createActivityExcel(OutputStream out, List<Activity> activityList) throws IOException {
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet();
        HSSFRow headRow = sheet.createRow(0);
        int index = 0;
        for (String title : titleName) {
            headRow.createCell(index++).setCellValue(title);
        }
        index = 1;
        HSSFRow row = null;
        HSSFCell cell = null;
        for (Activity activity : activityList) {
            row = sheet.createRow(index++);
            cell = row.createCell(INDEX);
            cell.setCellValue(index - 1);
            cell = row.createCell(NAME);
            cell.setCellValue(activity.getName());
            cell = row.createCell(SOURCE);
            cell.setCellValue(activity.getSource());
            cell = row.createCell(STATE);
            cell.setCellValue(activity.getState());
            cell = row.createCell(START_DATE);
            cell.setCellValue(activity.getStartDate());
            cell = row.createCell(END_DATE);
            cell.setCellValue(activity.getEndDate());
            cell = row.createCell(BUDGET_COST);
            cell.setCellValue(activity.getBudgetCost() + "");
            cell = row.createCell(DESCRIPTION);
            cell.setCellValue(activity.getDescription());
        }
        wb.write(out);
        wb.close();
    }

}
