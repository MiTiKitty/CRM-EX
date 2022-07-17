package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.*;
import com.itCat.crmEX.workbench.mapper.*;
import com.itCat.crmEX.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("clueService")
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    private TransactionMapper transactionMapper;

    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Override
    public List<Clue> queryClueByCondition(Map<String, Object> map) {
        return clueMapper.selectClueByCondition(map);
    }

    @Override
    public int queryAllClueCountByCondition(Map<String, Object> map) {
        return clueMapper.selectAllClueCountByCondition(map);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);
    }

    @Override
    public Clue queryClueForConvertById(String id) {
        return clueMapper.selectClueForConvertById(id);
    }

    @Override
    public int saveClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public int editClueById(Clue clue) {
        return clueMapper.updateClueById(clue);
    }

    @Override
    public int removeClueById(String id) {
        return clueMapper.deleteClueById(id);
    }

    @Override
    public void removeClueByIds(String[] ids) {
        clueActivityRelationMapper.deleteClueActivityRelationByClueIds(ids);
        clueRemarkMapper.deleteClueRemarkByClueIds(ids);
        clueMapper.deleteClueByIds(ids);
    }

    /**
     * 数据转换：
     * 把线索中有关公司的信息转换到客户表中
     * 把线索中有关个人的信息转换到联系人表中
     * 把线索的备注信息转换到客户备注表中一份
     * 把线索的备注信息转换到联系人备注表中一份
     * 把线索和市场活动的关联关系转换到联系人和市场活动的关联关系表中
     * 如果需要创建交易，还要往交易表中添加一条记录
     * 如果需要创建交易，还要把线索的备注信息转换到交易备注表中一份
     * 删除线索的备注
     * 删除线索和市场活动的关联关系
     * 删除线索
     *
     * @param customer              客户
     * @param contacts              联系人
     * @param customerRemarkList    客户备注信息列表
     * @param contactsRemarkList    联系人备注信息列表
     * @param relationList          联系人与市场活动的关联关系列表
     * @param isCreateTransaction   是否创建交易的标识
     * @param transaction           交易
     * @param transactionRemarkList 交易备注信息列表
     * @param clueId                线索id
     */
    @Override
    public void saveConvert(Customer customer, Contacts contacts, List<CustomerRemark> customerRemarkList,
                            List<ContactsRemark> contactsRemarkList, List<ContactsActivityRelation> relationList,
                            boolean isCreateTransaction, Transaction transaction,
                            List<TransactionRemark> transactionRemarkList, String clueId) {
        customerMapper.insertCustomer(customer);
        contactsMapper.insertContacts(contacts);
        customerRemarkMapper.insertCustomerRemarks(customerRemarkList);
        contactsRemarkMapper.insertContactsRemarks(contactsRemarkList);
        contactsActivityRelationMapper.insertContactsActivityRelations(relationList);
        if (isCreateTransaction){
            transactionMapper.insertTransaction(transaction);
            transactionRemarkMapper.insertTransactionRemarks(transactionRemarkList);
        }
        clueRemarkMapper.deleteClueRemarkByClueId(clueId);
        clueActivityRelationMapper.deleteClueActivityRelationByClueId(clueId);
        clueMapper.deleteClueById(clueId);
    }


}
