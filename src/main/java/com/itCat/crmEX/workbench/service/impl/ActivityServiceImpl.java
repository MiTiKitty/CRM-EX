package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.Activity;
import com.itCat.crmEX.workbench.mapper.ActivityMapper;
import com.itCat.crmEX.workbench.mapper.ActivityRemarkMapper;
import com.itCat.crmEX.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("activityService")
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    @Override
    public List<Activity> queryActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectActivityByCondition(map);
    }

    @Override
    public List<Activity> queryAllActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectAllActivityByCondition(map);
    }

    @Override
    public List<Activity> queryAllActivity() {
        return activityMapper.selectAllActivity();
    }

    @Override
    public List<Activity> queryActivityByIds(String[] ids) {
        return activityMapper.selectActivityByIds(ids);
    }

    @Override
    public int queryActivityCountByCondition(Map<String, Object> map) {
        return activityMapper.selectActivityCountByCondition(map);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public Activity queryActivityForDetailById(String id) {
        return activityMapper.selectActivityForDetailById(id);
    }

    @Override
    public List<Activity> queryActivityForClueRelationByClueId(String clueId) {
        return activityMapper.selectActivityForClueRelationByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityByName(Map<String, Object> map) {
        return activityMapper.selectActivityForClueByName(map);
    }

    @Override
    public List<Activity> queryActivityForClueConvertByName(Map<String, Object> map) {
        return activityMapper.selectActivityForClueConvertByName(map);
    }

    @Override
    public List<Activity> queryActivityForContactsRelationByContactsId(String contactsId) {
        return activityMapper.selectActivityForContactsRelationByContactsId(contactsId);
    }

    @Override
    public List<Activity> queryActivityForContactsByName(Map<String, Object> map) {
        return activityMapper.selectActivityForContactsByName(map);
    }

    @Override
    public List<Activity> queryActivityForContactsToTransactionByName(Map<String, Object> map) {
        return activityMapper.selectActivityForContactsToTransactionByName(map);
    }

    @Override
    public int importActivities(List<Activity> activityList) {
        return activityMapper.insertActivities(activityList);
    }

    @Override
    public int saveActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public int editActivityById(Activity activity) {
        return activityMapper.updateActivityById(activity);
    }

    @Override
    public void removeActivityByIds(String[] ids) {
        activityRemarkMapper.deleteActivityRemarkByActivityIds(ids);
        activityMapper.deleteActivityByIds(ids);
    }
}
