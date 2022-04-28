package com.wyn.crm.service.impl;

import com.wyn.crm.entity.TranRemark;
import com.wyn.crm.mapper.TranRemarkMapper;
import com.wyn.crm.service.api.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.PrivateKey;
import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/27
 */
@Service
public class TranRemarkServiceImpl implements TranRemarkService {

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    public List<TranRemark> getAll() {
        return tranRemarkMapper.getAll();
    }

    public int addRemark(TranRemark tranRemark) {
        int insert = tranRemarkMapper.insert(tranRemark);
        return insert;
    }

    public int updateRemark(TranRemark tranRemark) {

        int i = tranRemarkMapper.updateByPrimaryKeySelective(tranRemark);
        return i;
    }

    public int deleteRemark(String id) {
        int i = tranRemarkMapper.deleteByPrimaryKey(id);
        return i;
    }
}
