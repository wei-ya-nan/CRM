package com.wyn.crm.service.api;

import com.wyn.crm.entity.TranRemark;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/27
 */
public interface TranRemarkService  {
    List<TranRemark> getAll();

    // 添加备注
    int addRemark(TranRemark tranRemark);

    int updateRemark(TranRemark tranRemark);

    int deleteRemark(String id);
}
