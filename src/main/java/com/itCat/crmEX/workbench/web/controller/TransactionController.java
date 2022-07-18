package com.itCat.crmEX.workbench.web.controller;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.commons.domain.ResultObject;
import com.itCat.crmEX.commons.utils.DateUtils;
import com.itCat.crmEX.commons.utils.UUIDUtils;
import com.itCat.crmEX.settings.domain.DictionaryValue;
import com.itCat.crmEX.settings.domain.User;
import com.itCat.crmEX.settings.service.DictionaryValueService;
import com.itCat.crmEX.settings.service.UserService;
import com.itCat.crmEX.workbench.domain.Customer;
import com.itCat.crmEX.workbench.domain.Transaction;
import com.itCat.crmEX.workbench.domain.TransactionRemark;
import com.itCat.crmEX.workbench.service.ContactsService;
import com.itCat.crmEX.workbench.service.TransactionRemarkService;
import com.itCat.crmEX.workbench.service.TransactionService;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/workbench/transaction")
public class TransactionController {

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private UserService userService;

    @Autowired
    private DictionaryValueService dictionaryValueService;

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private TransactionRemarkService transactionRemarkService;

    @RequestMapping("/index.do")
    public String index(HttpServletRequest request) {
        commonTransactionReady(request);
        return "workbench/transaction/index";
    }

    @RequestMapping("/create.do")
    public String create(HttpServletRequest request) {
        commonTransactionReady(request);
        return "workbench/transaction/create";
    }

    @RequestMapping("/edit.do")
    public String edit(String id, HttpServletRequest request) {
        Transaction transaction = transactionService.queryTransactionById(id);
        commonTransactionReady(request);
        request.setAttribute("transaction", transaction);
        return "workbench/transaction/edit";
    }

    private void commonTransactionReady(HttpServletRequest request) {
        List<User> userList = userService.queryAllUserForOption();
        List<DictionaryValue> stageList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.STAGE);
        List<DictionaryValue> typeList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.TRANSACTION_TYPE);
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.SOURCE);
        request.setAttribute("userList", userList);
        request.setAttribute("stageList", stageList);
        request.setAttribute("typeList", typeList);
        request.setAttribute("sourceList", sourceList);
    }

    @RequestMapping("/detail.do")
    public String detail(String id, HttpServletRequest request) {
        Transaction transaction = transactionService.queryTransactionForDetailById(id);
        List<DictionaryValue> stageList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.STAGE);
        List<TransactionRemark> remarkList = transactionRemarkService.queryAllTransactionByTransactionId(id);
        List<DictionaryValue> okStage = new LinkedList<>();
        List<DictionaryValue> noStage = new LinkedList<>();
        DictionaryValue stage = null;
        int isStage = 0;
        for (DictionaryValue value : stageList) {
            if (value.getValue().equals(transaction.getStage())){
                isStage = 1;
            }
            if (isStage == 0){
                okStage.add(value);
            }else if (isStage == 1){
                isStage = 2;
                stage = value;
            }else {
                noStage.add(value);
            }
        }
        request.setAttribute("transaction", transaction);
        request.setAttribute("okStage", okStage);
        request.setAttribute("noStage", noStage);
        request.setAttribute("stage", stage);
        request.setAttribute("remarkList", remarkList);
        return "workbench/transaction/detail";
    }

    /**
     * 分页条件查询交易信息
     *
     * @param owner
     * @param name
     * @param customerName
     * @param contactsName
     * @param stage
     * @param type
     * @param source
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/queryTransactionByCondition.do")
    @ResponseBody
    public Object queryTransactionByCondition(String owner, String name, String customerName, String contactsName,
                                              String stage, String type, String source, int pageNo, int pageSize) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> result = new HashMap<>();
        map.put("owner", owner);
        map.put("name", name);
        map.put("customerName", customerName);
        map.put("contactsName", contactsName);
        map.put("stage", stage);
        map.put("type", type);
        map.put("source", source);
        map.put("beginPage", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        List<Transaction> transactionList = transactionService.queryTransactionByCondition(map);
        int totalRows = transactionService.queryTransactionCountByCondition(map);
        result.put("transactionList", transactionList);
        result.put("totalRows", totalRows);
        return result;
    }

    /**
     * 根据联系人名称模糊查询联系人信息
     *
     * @param fullName
     * @return
     */
    @RequestMapping("/queryContactsByFullName.do")
    @ResponseBody
    public Object queryContactsByFullName(String fullName, String customerId) {
        Map<String, Object> map = new HashMap<>();
        fullName = "%" + fullName + "%";
        map.put("fullName", fullName);
        map.put("customerId", customerId);
        return contactsService.queryContactsByFullNameAndByCustomerId(map);
    }

    /**
     * 创建新的交易
     *
     * @param owner
     * @param amountOfMoney
     * @param name
     * @param expectedClosingDate
     * @param customerId
     * @param stage
     * @param type
     * @param source
     * @param contactsId
     * @param activityId
     * @param description
     * @param contactSummary
     * @param nextContactTime
     * @param session
     * @return
     */
    @RequestMapping("/createTransaction.do")
    @ResponseBody
    public Object createTransaction(String owner, String amountOfMoney, String name, String expectedClosingDate,
                                    String customerId, String stage, String type, String source, String contactsId,
                                    String activityId, String description, String contactSummary, String nextContactTime,
                                    HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        Transaction transaction = new Transaction();
        transaction.setId(UUIDUtils.getUUID());
        putTransactionField(owner, amountOfMoney, name, expectedClosingDate, customerId, stage, type, source, contactsId, activityId, description, transaction);
        transaction.setCreateBy(user.getId());
        transaction.setCreateTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        transaction.setContactSummary(contactSummary);
        transaction.setNextContactTime(nextContactTime);
        try {
            int result = transactionService.saveTransaction(transaction);
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
     * 根据交易id修改交易信息
     *
     * @param owner
     * @param amountOfMoney
     * @param name
     * @param expectedClosingDate
     * @param customerId
     * @param stage
     * @param type
     * @param source
     * @param contactsId
     * @param activityId
     * @param description
     * @param contactSummary
     * @param nextContactTime
     * @param id
     * @param session
     * @return
     */
    @RequestMapping("/editTransaction.do")
    @ResponseBody
    public Object editTransaction(String owner, String amountOfMoney, String name, String expectedClosingDate,
                                  String customerId, String stage, String type, String source, String contactsId,
                                  String activityId, String description, String contactSummary, String nextContactTime,
                                  String id, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        Transaction transaction = new Transaction();
        transaction.setId(id);
        putTransactionField(owner, amountOfMoney, name, expectedClosingDate, customerId, stage, type, source, contactsId, activityId, description, transaction);
        transaction.setEditBy(user.getId());
        transaction.setEditTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        transaction.setContactSummary(contactSummary);
        transaction.setNextContactTime(nextContactTime);
        try {
            int result = transactionService.editTransactionById(transaction);
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

    private void putTransactionField(String owner, String amountOfMoney, String name, String expectedClosingDate, String customerId, String stage, String type, String source, String contactsId, String activityId, String description, Transaction transaction) {
        transaction.setOwner(owner);
        transaction.setAmountOfMoney(Long.parseLong(amountOfMoney));
        transaction.setName(name);
        transaction.setExpectedClosingDate(expectedClosingDate);
        transaction.setCustomerId(customerId);
        transaction.setStage(stage);
        transaction.setType(type);
        transaction.setSource(source);
        transaction.setContactsId(contactsId);
        transaction.setActivityId(activityId);
        transaction.setDescription(description);
    }

    /**
     * 根据交易id集合删除交易
     *
     * @param id
     * @return
     */
    @RequestMapping("/removeTransaction.do")
    @ResponseBody
    public Object removeTransaction(String[] id) {
        ResultObject resultObject = new ResultObject();
        try {
            transactionService.removeTransactionByIds(id);
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 创建新的交易备注
     *
     * @param transactionRemark
     * @param session
     * @return
     */
    @RequestMapping("/createTransactionRemark.do")
    @ResponseBody
    public Object createTransactionRemark(TransactionRemark transactionRemark, HttpSession session){
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        transactionRemark.setId(UUIDUtils.getUUID());
        transactionRemark.setEditFlag(Constants.NOT_EDIT);
        transactionRemark.setNotePerson(user.getId());
        transactionRemark.setNoteTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = transactionRemarkService.saveTransactionRemark(transactionRemark);
            if (result > 0){
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                transactionRemark.setNotePerson(user.getName());
                resultObject.setData(transactionRemark);
            }else {
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
     * 修改交易备注信息
     *
     * @param transactionRemark
     * @param session
     * @return
     */
    @RequestMapping("/editTransactionRemark.do")
    @ResponseBody
    public Object editTransactionRemark(TransactionRemark transactionRemark, HttpSession session){
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        transactionRemark.setEditFlag(Constants.HAVE_EDIT);
        transactionRemark.setEditPerson(user.getId());
        transactionRemark.setEditTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = transactionRemarkService.editTransactionRemarkById(transactionRemark);
            if (result > 0){
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                transactionRemark.setEditPerson(user.getName());
                resultObject.setData(transactionRemark);
            }else {
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
     * 根据备注id删除交易备注
     * @param id
     * @return
     */
    @RequestMapping("/removeTransactionRemark.do")
    @ResponseBody
    public Object removeTransactionRemark(String id){
        ResultObject resultObject = new ResultObject();
        try {
            int result = transactionRemarkService.removeTransactionRemarkById(id);
            if (result > 0){
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            }else {
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

}
