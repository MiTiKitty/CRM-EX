package com.itCat.crmEX.settings.service.impl;

import com.itCat.crmEX.settings.domain.UserRoleRelation;
import com.itCat.crmEX.settings.mapper.UserRoleRelationMapper;
import com.itCat.crmEX.settings.service.UserRoleRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userRoleRelationService")
public class UserRoleRelationServiceImpl implements UserRoleRelationService {

    @Autowired
    private UserRoleRelationMapper userRoleRelationMapper;

    @Override
    public int saveUserRoleRelation(UserRoleRelation userRoleRelation) {
        return userRoleRelationMapper.insertUserRoleRelation(userRoleRelation);
    }

    @Override
    public int saveUserRoleRelation(List<UserRoleRelation> userRoleRelationList) {
        return userRoleRelationMapper.insertUserRoleRelations(userRoleRelationList);
    }

    @Override
    public int removeUserRoleRelationByRoleId(String roleId) {
        return userRoleRelationMapper.deleteUserRoleRelationByRoleId(roleId);
    }

    @Override
    public int removeUserRoleRelationByUserId(String userId) {
        return userRoleRelationMapper.deleteUserRoleRelationByUserId(userId);
    }

    @Override
    public int removeUserRoleRelationByUserIdAndRoleIds(Map<String, Object> map) {
        return userRoleRelationMapper.deleteUserRoleRelationByUserIdAndRoleIds(map);
    }
}
