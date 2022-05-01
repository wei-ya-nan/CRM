package com.wyn.crm.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wyn.crm.entity.Customer;
import com.wyn.crm.entity.CustomerRemark;
import com.wyn.crm.mapper.CustomerMapper;
import com.wyn.crm.mapper.CustomerRemarkMapper;
import com.wyn.crm.service.api.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/26
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;


    public List<String> queryNameByLikeForAuto(String customerName) {
        List<String>  list = customerMapper.queryNameByLikeForAuto(customerName);
        return list;
    }

    public List<Customer> getAll() {
        List<Customer> customers = customerMapper.selectByExample(null);
        return customers;
    }

    public PageInfo<Customer> queryPage(String name, String owner, String phone, String website, Integer pageNum
            , Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Customer> list = customerMapper.queryPage(name,owner,phone,website);

        PageInfo<Customer> pageInfo = new PageInfo<Customer>(list, 5);
        return pageInfo;
    }

    public int saveCust(Customer customer) {
        int i = customerMapper.insertSelective(customer);
        return i;
    }

    public Customer getOne(String id) {
        Customer customer = customerMapper.selectByPrimaryKey(id);
        return customer;
    }

    public int updateCust(Customer customer) {
        int i = customerMapper.updateByPrimaryKeySelective(customer);
        return i;
    }

    public Customer getConditionOne(String id) {
        return customerMapper.getConditionOne(id);
    }

    public List<CustomerRemark> getCustomerRemark(String id) {
       List<CustomerRemark> list =  customerRemarkMapper.getCustomerRemark(id);
        return list;
    }

    public int saveRemark(CustomerRemark customerRemark) {
        int i = customerRemarkMapper.insertSelective(customerRemark);
        return i;
    }

    public int updateRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.updateByPrimaryKeySelective(customerRemark);
    }

    public int deleteRemark(String id) {
        return customerRemarkMapper.deleteByPrimaryKey(id);
    }
}
