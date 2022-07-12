package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.ActivityRemark;
import com.itCat.crmEX.workbench.mapper.ActivityRemarkMapper;
import com.itCat.crmEX.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("activityRemarkService")
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;


    @Override
    public List<ActivityRemark> queryAllActivityRemarkByActivityId(String activityId) {
        List<ActivityRemark> remarkList = activityRemarkMapper.selectAllActivityRemarkByActivityId(activityId);
        for (ActivityRemark remark : remarkList) {
            if ("0".equals(remark.getEditFlag())){
                remark.setShowPerson(remark.getNotePerson());
                remark.setShowTime(remark.getNoteTime());
            }else {
                remark.setShowPerson(remark.getEditPerson());
                remark.setShowTime(remark.getEditTime());
            }
        }
        return remarkList;
    }

    @Override
    public int saveActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insertActivityRemark(activityRemark);
    }

    @Override
    public int editActivityRemarkById(ActivityRemark activityRemark) {
        return activityRemarkMapper.editActivityRemarkById(activityRemark);
    }

    @Override
    public int removeActivityRemarkById(String id) {
        return activityRemarkMapper.deleteActivityRemarkById(id);
    }

    @Override
    public int removeActivityRemarkByActivityId(String activityId) {
        return activityRemarkMapper.deleteActivityRemarkByActivityId(activityId);
    }

    @Override
    public int removeActivityRemarkByActivityIds(String[] activityIds) {
        return activityRemarkMapper.deleteActivityRemarkByActivityIds(activityIds);
    }
}
