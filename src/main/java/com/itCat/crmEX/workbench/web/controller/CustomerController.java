package com.itCat.crmEX.workbench.web.controller;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.commons.domain.ResultObject;
import com.itCat.crmEX.commons.utils.DateUtils;
import com.itCat.crmEX.commons.utils.UUIDUtils;
import com.itCat.crmEX.settings.domain.DictionaryValue;
import com.itCat.crmEX.settings.domain.User;
import com.itCat.crmEX.settings.service.DictionaryValueService;
import com.itCat.crmEX.settings.service.UserService;
import com.itCat.crmEX.workbench.domain.Contacts;
import com.itCat.crmEX.workbench.domain.Customer;
import com.itCat.crmEX.workbench.domain.CustomerRemark;
import com.itCat.crmEX.workbench.domain.Transaction;
import com.itCat.crmEX.workbench.service.ContactsService;
import com.itCat.crmEX.workbench.service.CustomerRemarkService;
import com.itCat.crmEX.workbench.service.CustomerService;
import com.itCat.crmEX.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/customer")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private UserService userService;

    @Autowired
    private DictionaryValueService dictionaryValueService;

    @Autowired
    private CustomerRemarkService customerRemarkService;

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private TransactionService transactionService;

    @RequestMapping("/index.do")
    public String index(HttpServletRequest request) {
        commonCustomerReady(request);
        return "workbench/customer/index";
    }

    @RequestMapping("/detail.do")
    public String detail(String id, HttpServletRequest request) {
        Customer customer = customerService.queryCustomerForDetailById(id);
        List<CustomerRemark> remarkList = customerRemarkService.queryAllCustomerRemarkByCustomerId(id);
        List<Transaction> transactionList = transactionService.queryTransactionByCustomerId(id);
        List<Contacts> contactsList = contactsService.queryContactsForCustomerDetailByCustomerId(id);
        commonCustomerReady(request);
        request.setAttribute("customer", customer);
        request.setAttribute("remarkList", remarkList);
        request.setAttribute("transactionList", transactionList);
        request.setAttribute("contactsList", contactsList);
        return "workbench/customer/detail";
    }

    private void commonCustomerReady(HttpServletRequest request) {
        List<User> userList = userService.queryAllUserForOption();
        List<DictionaryValue> gradeList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.GRADE);
        List<DictionaryValue> industryList = dictionaryValueService.queryDictionaryValueByTypeCode(Constants.DictionaryCode.INDUSTRY);
        request.setAttribute("userList", userList);
        request.setAttribute("gradeList", gradeList);
        request.setAttribute("industryList", industryList);
    }

    /**
     * ??????????????????????????????
     *
     * @param name
     * @param phone
     * @param owner
     * @param website
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/queryCustomerByCondition.do")
    @ResponseBody
    public Object queryCustomerByCondition(String name, String phone, String owner, String website, String pageNo, String pageSize) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> result = new HashMap<>();
        int page = Integer.parseInt(pageNo);
        int size = Integer.parseInt(pageSize);
        map.put("name", name);
        map.put("phone", phone);
        map.put("owner", owner);
        map.put("website", website);
        map.put("beginPage", (page - 1) * size);
        map.put("pageSize", size);
        List<Customer> customerList = customerService.queryCustomerByCondition(map);
        int totalRows = customerService.queryCustomerCountByCondition(map);
        result.put("customerList", customerList);
        result.put("totalRows", totalRows);
        return result;
    }

    /**
     * ????????????????????????
     *
     * @param customer
     * @param session
     * @return
     */
    @RequestMapping("/createCustomer.do")
    @ResponseBody
    public Object createCustomer(Customer customer, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        customer.setId(UUIDUtils.getUUID());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = customerService.saveCustomer(customer);
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
     * ????????????id??????????????????
     *
     * @param id
     * @return
     */
    @RequestMapping("/queryCustomerById.do")
    @ResponseBody
    public Object queryCustomerById(String id){
        return customerService.queryCustomerById(id);
    }

    /**
     * ????????????id??????????????????
     *
     * @param customer
     * @param session
     * @return
     */
    @RequestMapping("/editCustomer.do")
    @ResponseBody
    public Object editCustomer(Customer customer, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        customer.setEditBy(user.getId());
        customer.setEditTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = customerService.editCustomerById(customer);
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
     * ????????????id????????????????????????
     *
     * @param id
     * @return
     */
    @RequestMapping("/removeCustomer.do")
    @ResponseBody
    public Object removeCustomer(String[] id) {
        ResultObject resultObject = new ResultObject();
        try {
            customerService.removeCustomerByIds(id);
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
     * @param customerId
     * @return
     */
    @RequestMapping("/queryAllCustomerRemark.do")
    @ResponseBody
    public Object queryAllCustomerRemark(String customerId) {
        return customerRemarkService.queryAllCustomerRemarkByCustomerId(customerId);
    }

    /**
     * ??????????????????????????????
     *
     * @param customerRemark
     * @param session
     * @return
     */
    @RequestMapping("/createCustomerRemark.do")
    @ResponseBody
    public Object createCustomerRemark(CustomerRemark customerRemark, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        customerRemark.setId(UUIDUtils.getUUID());
        customerRemark.setEditFlag(Constants.NOT_EDIT);
        customerRemark.setNotePerson(user.getId());
        customerRemark.setNoteTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = customerRemarkService.saveCustomerRemark(customerRemark);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                customerRemark.setNotePerson(user.getName());
                resultObject.setData(customerRemark);
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
     * ??????????????????id??????????????????
     *
     * @param customerRemark
     * @param session
     * @return
     */
    @RequestMapping("/editCustomerRemark.do")
    @ResponseBody
    public Object editCustomerRemark(CustomerRemark customerRemark, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        customerRemark.setEditFlag(Constants.HAVE_EDIT);
        customerRemark.setEditPerson(user.getId());
        customerRemark.setEditTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = customerRemarkService.editCustomerRemarkById(customerRemark);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                customerRemark.setEditPerson(user.getName());
                resultObject.setData(customerRemark);
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
     * ???????????????????????????id?????????????????????
     *
     * @param id
     * @return
     */
    @RequestMapping("/removeCustomerRemarkById.do")
    @ResponseBody
    public Object removeCustomerRemarkById(String id) {
        ResultObject resultObject = new ResultObject();
        try {
            int result = customerRemarkService.removeCustomerRemarkById(id);
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
     * ??????????????????????????????????????????
     *
     * @return
     */
    @RequestMapping("/queryCustomerByName.do")
    @ResponseBody
    public Object queryCustomerByName(String name) {
        return customerService.queryCustomerByName(name);
    }

    /**
     * ????????????id??????????????????
     *
     * @param id
     * @return
     */
    @RequestMapping("/queryTransactionByCustomerId.do")
    @ResponseBody
    public Object queryTransactionByCustomerId(String id){

        return null;
    }

    /**
     * ????????????id?????????????????????
     *
     * @param id
     * @return
     */
    @RequestMapping("/queryContactsByCustomerId.do")
    @ResponseBody
    public Object queryContactsByCustomerId(String id) {
        return contactsService.queryContactsForCustomerDetailByCustomerId(id);
    }

}
