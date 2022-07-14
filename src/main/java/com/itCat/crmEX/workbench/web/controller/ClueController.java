package com.itCat.crmEX.workbench.web.controller;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.commons.domain.ResultObject;
import com.itCat.crmEX.commons.utils.DateUtils;
import com.itCat.crmEX.commons.utils.UUIDUtils;
import com.itCat.crmEX.settings.domain.DictionaryValue;
import com.itCat.crmEX.settings.domain.User;
import com.itCat.crmEX.settings.service.DictionaryValueService;
import com.itCat.crmEX.settings.service.UserService;
import com.itCat.crmEX.workbench.domain.*;
import com.itCat.crmEX.workbench.service.ActivityService;
import com.itCat.crmEX.workbench.service.ClueActivityRelationService;
import com.itCat.crmEX.workbench.service.ClueRemarkService;
import com.itCat.crmEX.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/workbench/clue")
public class ClueController {

    @Autowired
    private ClueService clueService;

    @Autowired
    private UserService userService;

    @Autowired
    private DictionaryValueService dictionaryValueService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/index.do")
    public String index(HttpServletRequest request) {
        List<User> userList = userService.queryAllUserForOption();
        List<DictionaryValue> gradeList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.GRADE);
        List<DictionaryValue> industryList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.INDUSTRY);
        List<DictionaryValue> appellationList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.APPELLATION);
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.SOURCE);
        List<DictionaryValue> stateList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.STAGE);
        request.setAttribute("userList", userList);
        request.setAttribute("gradeList", gradeList);
        request.setAttribute("industryList", industryList);
        request.setAttribute("appellationList", appellationList);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("stateList", stateList);
        return "workbench/clue/index";
    }

    @RequestMapping("/detail.do")
    public String detail(String id, HttpServletRequest request) {
        Clue clue = clueService.queryClueForDetailById(id);
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkByClueId(id);
        List<Activity> activityList = activityService.queryActivityForClueRelationByClueId(id);
        request.setAttribute("clue", clue);
        request.setAttribute("clueRemarkList", clueRemarkList);
        request.setAttribute("activityList", activityList);
        return "workbench/clue/detail";
    }

    @RequestMapping("/convert.do")
    public String convert(String id, HttpServletRequest request) {
        Clue clue = clueService.queryClueForConvertById(id);
        List<DictionaryValue> stageList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.STAGE);
        List<DictionaryValue> typeList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.TRANSACTION_TYPE);
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.SOURCE);
        request.setAttribute("clue", clue);
        request.setAttribute("stageList", stageList);
        request.setAttribute("typeList", typeList);
        request.setAttribute("sourceList", sourceList);
        return "workbench/clue/convert";
    }

    /**
     * 根据查询条件分页查询线索信息
     *
     * @param fullName
     * @param company
     * @param phone
     * @param source
     * @param owner
     * @param mphone
     * @param state
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/queryClueByCondition.do")
    @ResponseBody
    public Object queryClueByCondition(String fullName, String company, String phone, String source, String owner,
                                       String mphone, String state, String pageNo, String pageSize) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> result = new HashMap<>();
        int page = Integer.parseInt(pageNo);
        int size = Integer.parseInt(pageSize);
        map.put("fullName", fullName);
        map.put("company", company);
        map.put("phone", phone);
        map.put("source", source);
        map.put("owner", owner);
        map.put("mphone", mphone);
        map.put("state", state);
        map.put("beginPage", (page - 1) * size);
        map.put("pageSize", size);
        List<Clue> clueList = clueService.queryClueByCondition(map);
        int totalRows = clueService.queryAllClueCountByCondition(map);
        result.put("clueList", clueList);
        result.put("totalRows", totalRows);
        return result;
    }

    /**
     * 保存新创建的线索信息
     *
     * @param clue
     * @param session
     * @return
     */
    @RequestMapping("/createClue.do")
    @ResponseBody
    public Object createClue(Clue clue, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User sessionUser = (User) session.getAttribute(Constants.SESSION_USER);
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateBy(sessionUser.getId());
        clue.setCreateTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = clueService.saveClue(clue);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据线索id查找线索信息
     *
     * @param id
     * @return
     */
    @RequestMapping("/queryClueById.do")
    @ResponseBody
    public Object queryClueById(String id) {
        return clueService.queryClueById(id);
    }

    /**
     * 根据线索id修改线索信息
     *
     * @param clue
     * @param session
     * @return
     */
    @RequestMapping("/editClue.do")
    @ResponseBody
    public Object editClue(Clue clue, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User sessionUser = (User) session.getAttribute(Constants.SESSION_USER);
        clue.setEditBy(sessionUser.getId());
        clue.setEditTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = clueService.editClueById(clue);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据指定的线索id集合删除线索信息
     *
     * @param id
     * @return
     */
    @RequestMapping("/removeClue.do")
    @ResponseBody
    public Object removeClue(String[] id) {
        ResultObject resultObject = new ResultObject();
        try {
            clueService.removeClueByIds(id);
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 创建一条新的线索备注信息
     *
     * @param clueRemark
     * @param session
     * @return
     */
    @RequestMapping("/createClueRemark.do")
    @ResponseBody
    public Object createClueRemark(ClueRemark clueRemark, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User sessionUser = (User) session.getAttribute(Constants.SESSION_USER);
        clueRemark.setId(UUIDUtils.getUUID());
        clueRemark.setEditFlag(Constants.NOT_EDIT);
        clueRemark.setNotePerson(sessionUser.getId());
        clueRemark.setNoteTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = clueRemarkService.saveClueRemark(clueRemark);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                clueRemark.setNotePerson(sessionUser.getName());
                resultObject.setData(clueRemark);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据线索备注id修改备注信息
     *
     * @param clueRemark
     * @param session
     * @return
     */
    @RequestMapping("/editClueRemarkById.do")
    @ResponseBody
    public Object editClueRemarkById(ClueRemark clueRemark, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User sessionUser = (User) session.getAttribute(Constants.SESSION_USER);
        clueRemark.setEditFlag(Constants.HAVE_EDIT);
        clueRemark.setEditPerson(sessionUser.getId());
        clueRemark.setEditTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = clueRemarkService.editClueRemarkById(clueRemark);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                clueRemark.setEditPerson(sessionUser.getName());
                resultObject.setData(clueRemark);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据线索备注id删除该备注信息
     *
     * @param id
     * @return
     */
    @RequestMapping("/removeClueRemarkById.do")
    @ResponseBody
    public Object removeClueRemarkById(String id) {
        ResultObject resultObject = new ResultObject();
        try {
            int result = clueRemarkService.removeClueRemarkById(id);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据市场活动名称模糊查询还未与当前线索相关联的市场活动信息
     *
     * @param name
     * @return
     */
    @RequestMapping("/queryActivityByName.do")
    @ResponseBody
    public Object queryActivityByName(String name, String clueId) {
        name = "%" + name + "%";
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("clueId", clueId);
        return activityService.queryActivityByName(map);
    }

    /**
     * 设置市场活动与该线索相关联
     *
     * @param activityIds
     * @param clueId
     * @return
     */
    @RequestMapping("/saveRelation.do")
    @ResponseBody
    public Object saveRelation(String[] activityIds, String clueId) {
        ResultObject resultObject = new ResultObject();
        List<ClueActivityRelation> relationList = new LinkedList<>();
        ClueActivityRelation relation = null;
        for (String activityId : activityIds) {
            relation = new ClueActivityRelation();
            relation.setId(UUIDUtils.getUUID());
            relation.setActivityId(activityId);
            relation.setClueId(clueId);
            relationList.add(relation);
        }
        try {
            int result = clueActivityRelationService.saveClueActivityRelation(relationList);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                List<Activity> activityList = activityService.queryActivityByIds(activityIds);
                resultObject.setData(activityList);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 将市场活动与该线索解除关联关系
     *
     * @param activityId
     * @param clueId
     * @return
     */
    @RequestMapping("/relieveRelation.do")
    @ResponseBody
    public Object relieveRelation(String activityId, String clueId) {
        ResultObject resultObject = new ResultObject();
        Map<String, Object> map = new HashMap<>();
        map.put("activityId", activityId);
        map.put("clueId", clueId);
        try {
            int result = clueActivityRelationService.removeClueActivityRelationByClueIdAndActivityId(map);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据市场活动名称模糊查询与当前线索相关联的市场活动信息
     *
     * @param clueId
     * @param name
     * @return
     */
    @RequestMapping("/queryActivityForConvertByName.do")
    @ResponseBody
    public Object queryActivityForConvertByName(String clueId, String name) {
        name = "%" + name + "%";
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("clueId", clueId);
        return activityService.queryActivityForClueConvertByName(map);
    }

    /**
     * 线索转换
     *
     * @param clueId
     * @param amountOfMoney
     * @param name
     * @param expectedClosingDate
     * @param stage
     * @param activityId
     * @param type
     * @param source
     * @param isConvert
     * @param session
     * @return
     */
    @RequestMapping("/createConvert.do")
    @ResponseBody
    public Object createConvert(String clueId, String amountOfMoney, String name, String expectedClosingDate,
                                String stage, String activityId, String type, String source, boolean isConvert,
                                HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);

        //获得线索详细信息
        Clue clue = clueService.queryClueForDetailById(clueId);

        //获得线索备注信息列表
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkForConvertByClueId(clueId);

        //获得线索与市场活动的关联关系列表
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationService.queryClueActivityRelationByClueId(clueId);

        //封装客户
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setOwner(user.getId());
        customer.setName(clue.getCompany());
        customer.setGrade(clue.getGrade());
        customer.setPhone(clue.getPhone());
        customer.setWebsite(clue.getWebsite());
        customer.setIndustry(clue.getIndustry());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));

        //封装联系人
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtils.getUUID());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setAppellation(clue.getAppellation());
        contacts.setFullName(clue.getFullName());
        contacts.setEmail(clue.getEmail());
        contacts.setJob(clue.getJob());
        contacts.setMphone(clue.getMphone());
        contacts.setDescription(clue.getDescription());
        contacts.setAddress(clue.getAddress());
        contacts.setCustomerId(customer.getId());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());

        //封装客户备注信息列表
        List<CustomerRemark> customerRemarkList = new LinkedList<>();
        CustomerRemark customerRemark = null;
        for (ClueRemark clueRemark : clueRemarkList) {
            customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtils.getUUID());
            customerRemark.setNotePerson(clueRemark.getNotePerson());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setNoteTime(clueRemark.getNoteTime());
            customerRemark.setEditPerson(clueRemark.getEditPerson());
            customerRemark.setEditTime(clueRemark.getEditTime());
            customerRemark.setEditFlag(clueRemark.getEditFlag());
            customerRemark.setCustomerId(customer.getId());
            customerRemarkList.add(customerRemark);
        }

        //封装联系人备注信息列表
        List<ContactsRemark> contactsRemarkList = new LinkedList<>();
        ContactsRemark contactsRemark = null;
        for (ClueRemark clueRemark : clueRemarkList) {
            contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtils.getUUID());
            contactsRemark.setNotePerson(clueRemark.getNotePerson());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setNoteTime(clueRemark.getNoteTime());
            contactsRemark.setEditPerson(clueRemark.getEditPerson());
            contactsRemark.setEditTime(clueRemark.getEditTime());
            contactsRemark.setEditFlag(clueRemark.getEditFlag());
            contactsRemark.setContactsId(contacts.getId());
            contactsRemarkList.add(contactsRemark);
        }

        //封装联系人与市场活动关联关系列表
        List<ContactsActivityRelation> relationList = new LinkedList<>();
        ContactsActivityRelation contactsActivityRelation = null;
        for (ClueActivityRelation relation : clueActivityRelationList) {
            contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtils.getUUID());
            contactsActivityRelation.setActivityId(relation.getActivityId());
            contactsActivityRelation.setContactsId(contacts.getId());
            relationList.add(contactsActivityRelation);
        }

        //封装交易
        Transaction transaction = new Transaction();
        transaction.setId(UUIDUtils.getUUID());
        transaction.setOwner(user.getId());
        transaction.setAmountOfMoney(Long.parseLong(amountOfMoney));
        transaction.setName(name);
        transaction.setExpectedClosingDate(expectedClosingDate);
        transaction.setCustomerId(customer.getId());
        transaction.setStage(stage);
        transaction.setType(type);
        transaction.setSource(source);
        transaction.setActivityId(activityId);
        transaction.setContactsId(contacts.getId());
        transaction.setDescription(clue.getDescription());
        transaction.setCreateBy(user.getId());
        transaction.setCreateTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        transaction.setContactSummary(clue.getContactSummary());
        transaction.setNextContactTime(clue.getNextContactTime());

        //封装交易备注信息列表
        List<TransactionRemark> transactionRemarkList = new LinkedList<>();
        TransactionRemark transactionRemark = null;
        for (ClueRemark clueRemark : clueRemarkList) {
            transactionRemark = new TransactionRemark();
            transactionRemark.setId(UUIDUtils.getUUID());
            transactionRemark.setNotePerson(clueRemark.getNotePerson());
            transactionRemark.setNoteContent(clueRemark.getNoteContent());
            transactionRemark.setNoteTime(clueRemark.getNoteTime());
            transactionRemark.setEditPerson(clueRemark.getEditPerson());
            transactionRemark.setEditTime(clueRemark.getEditTime());
            transactionRemark.setEditFlag(clueRemark.getEditFlag());
            transactionRemark.setTransactionId(transaction.getId());
            transactionRemarkList.add(transactionRemark);
        }

        //进行转换操作
        try {
            clueService.saveConvert(customer, contacts, customerRemarkList, contactsRemarkList, relationList, isConvert, transaction, transactionRemarkList, clue.getId());
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

}
