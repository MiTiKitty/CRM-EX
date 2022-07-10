package com.itCat.crmEX.settings.service.impl;

import com.itCat.crmEX.settings.domain.Department;
import com.itCat.crmEX.settings.mapper.DepartmentMapper;
import com.itCat.crmEX.settings.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("departmentService")
public class DepartmentServiceImpl implements DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    @Override
    public List<Department> queryAllDepartment() {
        return departmentMapper.selectAllDepartment();
    }

    @Override
    public Department queryDepartmentByNumber(String number) {
        return departmentMapper.selectDepartmentByNumber(number);
    }

    @Override
    public Department queryDepartmentById(String id) {
        return departmentMapper.selectDepartmentById(id);
    }

    @Override
    public List<Department> queryDepartmentsByName(String name) {
        return departmentMapper.selectDepartmentsByName(name);
    }

    @Override
    public int saveDepartment(Department department) {
        return departmentMapper.insertDepartment(department);
    }

    @Override
    public int editDepartmentById(Department department) {
        return departmentMapper.updateDepartmentById(department);
    }

    @Override
    public void removeDepartmentByIds(String[] ids) {
        departmentMapper.deleteDepartmentByIds(ids);
    }
}
