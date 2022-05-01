package com.wyn.crm.service.api;

import com.github.pagehelper.PageInfo;
import com.wyn.crm.entity.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/26
 */
@Service
public interface TranService {
    // 创建交易信息
    void addTran(Tran tran, User user,String customerName);

    List<Tran> getAllTran();

    PageInfo<Tran> getTranPageByCondition(Map<String, Object> map);

    // 根据id来查找Tran
    Tran getTranById(String id);

    int updateTran(Tran tran);

    int deleteTran(List<String> id);

    List<FunnelVO> queryCountOfTranGroupByStage();

    List<Tran> getTranByCustomerId(String id);

    List<Tran> getTranByContactsId(String id);
}
