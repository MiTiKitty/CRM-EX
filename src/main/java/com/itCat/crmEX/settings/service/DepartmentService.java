package com.itCat.crmEX.settings.service;

import com.itCat.crmEX.settings.domain.Department;

import java.util.List;

public interface DepartmentService {

    List<Department> queryAllDepartment();

    Department queryDepartmentByNumber(String number);

    Department queryDepartmentById(String id);

    int saveDepartment(Department department);

    int editDepartmentById(Department department);

    void removeDepartmentByIds(String[] ids);

}
