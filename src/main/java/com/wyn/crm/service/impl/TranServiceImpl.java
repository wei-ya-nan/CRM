package com.wyn.crm.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wyn.crm.entity.*;
import com.wyn.crm.mapper.CustomerMapper;
import com.wyn.crm.mapper.TranHistoryMapper;
import com.wyn.crm.mapper.TranMapper;
import com.wyn.crm.service.api.TranService;
import com.wyn.crm.utils.DateUtils;
import com.wyn.crm.utils.UUIDUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/26
 */
@Service
public class TranServiceImpl implements TranService {
    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private TranMapper tranMapper;

    @Autowired
    private TranHistoryMapper tranHistoryMapper;


    public void addTran(Tran tran, User user, String customerName) {
        String customerId = tran.getCustomerId();

        Customer customer = customerMapper.selectByPrimaryKey(customerId);

        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getName());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formateDateTime(new Date()));
            customerMapper.insertSelective(customer);
        }
        // 保存创建好的交易
        tran.setCustomerId(customer.getId());
//        System.out.println(tran);
        tranMapper.insertTran(tran);

        //保存交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtils.formateDateTime(new Date()));
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());
        tranHistoryMapper.insertSelective(tranHistory);

    }

    public List<Tran> getAllTran() {
        List<Tran> list = tranMapper.getAll();
        return list;
    }

    public PageInfo<Tran> getTranPageByCondition(Map<String, Object> map) {
        Integer pageNum = Integer.parseInt(map.get("pageNum").toString());
        Integer pageSize = Integer.parseInt(map.get("pageSize").toString());
        PageHelper.startPage(pageNum, pageSize);
        List<Tran> page = tranMapper.getPage(map);
        PageInfo<Tran> pageInfo = new PageInfo<Tran>(page, 5);
        return pageInfo;
    }

    public Tran getTranById(String id) {
        Tran tran = tranMapper.getTranById(id);
        return tran;
    }

    public int updateTran(Tran tran) {
        return tranMapper.updateByPrimaryKeySelective(tran);
    }

    public int deleteTran(List<String> id) {

        return tranMapper.deleteTran(id);
    }

    public List<FunnelVO> queryCountOfTranGroupByStage() {
        List<FunnelVO> list = tranMapper.queryGroupByStage();
        return list;
    }

    public List<Tran> getTranByCustomerId(String id) {
        List<Tran> tranList = tranMapper.getTranByConstomerId(id);
        return tranList;
    }

    public List<Tran> getTranByContactsId(String id) {
        List<Tran> list = tranMapper.getTranByContactsId(id);
        return list;
    }
}
