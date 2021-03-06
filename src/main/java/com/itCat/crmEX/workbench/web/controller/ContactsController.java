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
import com.itCat.crmEX.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/workbench/contacts")
public class ContactsController {

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private UserService userService;

    @Autowired
    private DictionaryValueService dictionaryValueService;

    @Autowired
    private ContactsRemarkService contactsRemarkService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;

    @Autowired
    private TransactionService transactionService;

    @RequestMapping("/index.do")
    public String index(HttpServletRequest request) {
        commonContactsReady(request);
        return "workbench/contacts/index";
    }

    @RequestMapping("/detail.do")
    public String detail(String id, HttpServletRequest request) {
        Contacts contacts = contactsService.queryContactsForDetailById(id);
        List<ContactsRemark> contactsRemarkList = contactsRemarkService.queryContactsRemarkByContactsId(id);
        List<Activity> activityList = activityService.queryActivityForContactsRelationByContactsId(id);
        List<Transaction> transactionList = transactionService.queryTransactionByContactsId(id);
        commonContactsReady(request);
        request.setAttribute("contacts", contacts);
        request.setAttribute("contactsRemarkList", contactsRemarkList);
        request.setAttribute("activityList", activityList);
        request.setAttribute("transactionList", transactionList);
        return "workbench/contacts/detail";
    }

    private void commonContactsReady(HttpServletRequest request) {
        List<User> userList = userService.queryAllUserForOption();
        List<DictionaryValue> sourceList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.SOURCE);
        List<DictionaryValue> appellationList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.APPELLATION);
        request.setAttribute("userList", userList);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("appellationList", appellationList);
    }

    /**
     * ?????????????????????????????????
     *
     * @param name
     * @param fullName
     * @param owner
     * @param source
     * @param birth
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/queryContactsByCondition.do")
    @ResponseBody
    public Object queryContactsByCondition(String name, String fullName, String owner, String source, String birth,
                                           String pageNo, String pageSize) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> result = new HashMap<>();
        int page = Integer.parseInt(pageNo);
        int size = Integer.parseInt(pageSize);
        map.put("name", name);
        map.put("fullName", fullName);
        map.put("owner", owner);
        map.put("source", source);
        map.put("birth", birth);
        map.put("beginPage", (page - 1) * size);
        map.put("pageSize", size);
        List<Contacts> contactsList = contactsService.queryContactsByCondition(map);
        int totalRows = contactsService.queryContactsCountByCondition(map);
        result.put("contactsList", contactsList);
        result.put("totalRows", totalRows);
        return result;
    }

    /**
     * ?????????????????????????????????
     *
     * @param contacts
     * @param session
     * @return
     */
    @RequestMapping("/createContacts.do")
    @ResponseBody
    public Object createContacts(Contacts contacts, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        contacts.setId(UUIDUtils.getUUID());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = contactsService.saveContacts(contacts);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                resultObject.setData(contacts.getId());
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("??????????????????????????????...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("??????????????????????????????...");
        }
        return resultObject;
    }

    /**
     * ???????????????id?????????????????????
     *
     * @param id
     * @return
     */
    @RequestMapping("/queryContactsById.do")
    @ResponseBody
    public Object queryContactsById(String id){
        return contactsService.queryContactsById(id);
    }

    /**
     * ???????????????id?????????????????????
     *
     * @param contacts
     * @param session
     * @return
     */
    @RequestMapping("/editContacts.do")
    @ResponseBody
    public Object editContacts(Contacts contacts, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        contacts.setEditBy(user.getId());
        contacts.setEditTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = contactsService.editContactsById(contacts);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("??????????????????????????????...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("??????????????????????????????...");
        }
        return resultObject;
    }

    /**
     * ????????????id???????????????????????????
     *
     * @param id
     * @return
     */
    @RequestMapping("/removeContacts.do")
    @ResponseBody
    public Object removeContacts(String[] id) {
        ResultObject resultObject = new ResultObject();
        try {
            contactsService.removeContactsByIds(id);
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("??????????????????????????????...");
        }
        return resultObject;
    }

    /**
     * ???????????????????????????????????????
     *
     * @param contactsRemark
     * @param session
     * @return
     */
    @RequestMapping("/createContactsRemark.do")
    @ResponseBody
    public Object createContactsRemark(ContactsRemark contactsRemark, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        contactsRemark.setId(UUIDUtils.getUUID());
        contactsRemark.setNotePerson(user.getId());
        contactsRemark.setEditFlag(Constants.NOT_EDIT);
        contactsRemark.setNoteTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = contactsRemarkService.saveContactsRemark(contactsRemark);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                contactsRemark.setNotePerson(user.getName());
                resultObject.setData(contactsRemark);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("??????????????????????????????...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("??????????????????????????????...");
        }
        return resultObject;
    }

    /**
     * ???????????????????????????id???????????????????????????
     *
     * @param contactsRemark
     * @param session
     * @return
     */
    @RequestMapping("/editContactsRemark.do")
    @ResponseBody
    public Object editContactsRemark(ContactsRemark contactsRemark, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        contactsRemark.setEditPerson(user.getId());
        contactsRemark.setEditFlag(Constants.HAVE_EDIT);
        contactsRemark.setEditTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = contactsRemarkService.editContactsRemarkById(contactsRemark);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                contactsRemark.setEditPerson(user.getName());
                resultObject.setData(contactsRemark);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("??????????????????????????????...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("??????????????????????????????...");
        }
        return resultObject;
    }

    /**
     * ?????????????????????id??????????????????
     *
     * @param id
     * @return
     */
    @RequestMapping("/removeContactsRemark.do")
    @ResponseBody
    public Object removeContactsRemark(String id) {
        ResultObject resultObject = new ResultObject();
        try {
            int result = contactsRemarkService.removeContactsRemarkById(id);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("??????????????????????????????...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("??????????????????????????????...");
        }
        return resultObject;
    }

    /**
     * ???????????????id????????????????????????????????????????????????????????????
     *
     * @param contactsId
     * @return
     */
    @RequestMapping("/queryActivityByContactsId.do")
    @ResponseBody
    public Object queryActivityByContactsId(String contactsId){
        return activityService.queryActivityForContactsRelationByContactsId(contactsId);
    }

    /**
     * ???????????????????????????????????????????????????????????????????????????
     *
     * @param name
     * @param contactsId
     * @return
     */
    @RequestMapping("/queryActivityByName.do")
    @ResponseBody
    public Object queryActivityByName(String name, String contactsId){
        Map<String, Object> map = new HashMap<>();
        name = "%" + name + "%";
        map.put("name", name);
        map.put("contactsId", contactsId);
        return activityService.queryActivityForContactsByName(map);
    }

    /**
     * ????????????????????????????????????
     * @param activityIds
     * @param contactsId
     * @return
     */
    @RequestMapping("/saveRelation.do")
    @ResponseBody
    public Object saveRelation(String[] activityIds, String contactsId){
        ResultObject resultObject = new ResultObject();
        List<ContactsActivityRelation> relationList = new LinkedList<>();
        ContactsActivityRelation relation = null;
        for (String activityId : activityIds) {
            relation = new ContactsActivityRelation();
            relation.setId(UUIDUtils.getUUID());
            relation.setActivityId(activityId);
            relation.setContactsId(contactsId);
            relationList.add(relation);
        }
        try {
            int result = contactsActivityRelationService.saveContactsActivityRelation(relationList);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                List<Activity> activityList = activityService.queryActivityByIds(activityIds);
                resultObject.setData(activityList);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("??????????????????????????????...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("??????????????????????????????...");
        }
        return resultObject;
    }

    /**
     * ?????????????????????????????????????????????
     * @param activityId
     * @param contactsId
     * @return
     */
    @RequestMapping("/relieveRelation.do")
    @ResponseBody
    public Object relieveRelation(String activityId, String contactsId){
        ResultObject resultObject = new ResultObject();
        Map<String, Object> map = new HashMap<>();
        map.put("activityId", activityId);
        map.put("contactsId", contactsId);
        try {
            int result = contactsActivityRelationService.removeContactsActivityRelation(map);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("??????????????????????????????...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("??????????????????????????????...");
        }
        return resultObject;
    }

}
